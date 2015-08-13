//
//  friendSwiperViewController.m
//  Icebreaker
//
//  Created by Gan Chau on 7/28/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "friendSwiperViewController.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "DataStore.h"
#import "ChoosePersonViewOurs.h"

static const CGFloat ChoosePersonButtonHorizontalPadding = 88.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@interface friendSwiperViewController () < MDCSwipeToChooseDelegate>

@property (strong, nonatomic) DataStore *dataManager;
@property (strong, nonatomic) NSMutableArray *potentialMatches;
@property (nonatomic, strong) NSMutableArray *trackPotentialMatches;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIView *matchView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftProfilePictureConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightProfilePictureConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *matchNotificationLabelTop;

@property (weak, nonatomic) IBOutlet UILabel *itsAMatchLabel;
@property (strong, nonatomic) IBOutlet UIView *viewProperty;

@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UIButton *rejectButton;

@end

@implementation friendSwiperViewController

#pragma mark - Creating and Customizing a MDCSwipeToChooseView

- (void)viewDidLoad {
    [super viewDidLoad];
    //INITIALIZE THE DATA MANAGER
    self.dataManager = [DataStore sharedDataStore];
    //GET POTENTIAL MATCHES FROM DATA STORE
    
    self.trackPotentialMatches = [@[]mutableCopy];
    
    NSLog(@"LOCAL USER2 %@",self.dataManager.user.facebookID);
    
    [ParseAPICalls getMatchesFromParseWithCompletionBlock:^(BOOL success, NSArray *matches) {
        if (success) {
            NSLog(@"WWOWOWOOWOWOWOWOWOWOWOWO!!! : %@", matches);
        }
    }];

    [self.dataManager fetchMatchesWithCompletionBlock:^(BOOL success) {
        if (success) {
            
            self.potentialMatches = [self.dataManager.potentialMatchArray mutableCopy];
            NSLog(@"%@ POTENTIAL",self.potentialMatches);

            self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
            [self.view addSubview:self.frontCardView];
            
            self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
            [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
            
            //update UI stuff
        } else {
            //failure, alert user of failure
        }
    }];
    self.viewProperty.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    self.matchView.hidden = YES;
    self.itsAMatchLabel.hidden = YES;
    
    
    self.leftProfilePictureConstraint.constant -= 160.0;
    self.rightProfilePictureConstraint.constant -= 160.0;
    self.matchNotificationLabelTop.constant += 40.0;
    
    self.leftImage.autoresizingMask = NO;
    self.rightImage.autoresizingMask = NO;
    self.itsAMatchLabel.autoresizingMask = NO;
    
    [self constructNopeButton];
    [self constructLikedButton];
}

-(void)displayMatchNotification:(User *)otherUser{
    NSLog(@"GETTING CALLED");
    PFUser *localUser = [PFUser currentUser];
    UIImage *profilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:localUser[@"profile_photo"]]]];
    
    self.leftImage.image = profilePhoto;
    self.rightImage.image = otherUser.profilePhoto;
    [self animateMatchPictures];
}

-(void)animateMatchPictures{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.view.frame;
    effectView.alpha = 0.5;
    [self.view addSubview:effectView];
    
    self.leftImage.layer.cornerRadius = 50;
    self.rightImage.layer.cornerRadius = 50;
    self.leftImage.layer.masksToBounds = YES;
    self.rightImage.layer.masksToBounds = YES;
    [self.view bringSubviewToFront:self.matchView];
    
    self.matchView.hidden = NO;
    
    self.rightImage.hidden = NO;
    self.leftImage.hidden = NO;
    self.rightImage.alpha = 1.0;
    self.leftImage.alpha = 1.0;
    self.itsAMatchLabel.hidden = NO;
    self.itsAMatchLabel.alpha = 1.0;
    
    [UIView animateWithDuration:1.3 animations:^{
        self.leftProfilePictureConstraint.constant += 160.0;
        self.rightProfilePictureConstraint.constant += 160.0;
        self.matchNotificationLabelTop.constant -= 40.0;
        effectView.alpha = 1;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            self.rightImage.alpha = 0.0;
            self.leftImage.alpha = 0.0;
            self.itsAMatchLabel.alpha = 0.0;
            effectView.alpha = 0.1;
            
            NSLog(@"ANIMATE");
        } completion:^(BOOL finished) {
            self.matchView.hidden = YES;
            self.leftProfilePictureConstraint.constant -= 160.0;
            self.rightProfilePictureConstraint.constant -= 160.0;
            self.matchNotificationLabelTop.constant += 40.0;
            self.rightImage.hidden = YES;
            self.leftImage.hidden = YES;
            [effectView removeFromSuperview];
        }];
    }];
}

-(void)keepOrRemoveLikeAndRejectButton{
    DataStore *dataManager = [DataStore sharedDataStore];
    //hides the like and reject buttons if there isnt anyone to show
    if (dataManager.potentialMatchArray.count == 0 ||
        dataManager.potentialMatchArray == nil) {
        //        self.rejectButton.hidden = YES;
        //        self.likeButton.hidden = YES;
        [self.rejectButton removeFromSuperview];
        [self.likeButton removeFromSuperview];
    }
}

#pragma mark - MDCSwipeToChooseDelegate Callbacks

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    DataStore *dataManager = self.dataManager;
    [self keepOrRemoveLikeAndRejectButton];

    User *user = self.trackPotentialMatches[0];
    [self displayMatchNotification:user];
    
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"Photo rejected!");
        [user.rejectedProfiles addObject:user.facebookID];
        [ParseAPICalls updateParsePotentialMatchesWithFacebookID:user.facebookID withAccepted:NO withCompletion:^(BOOL success) {
            
        }];
    } else {
        NSLog(@"Photo liked!");
        [user.acceptedProfiles addObject:user.facebookID];
        [ParseAPICalls updateParsePotentialMatchesWithFacebookID:user.facebookID withAccepted:YES withCompletion:^(BOOL success) {
        }];
        [ParseAPICalls isSwipeAMatch:user.facebookID withCompletion:^(BOOL success, User *matchedUser) {
            if(success){
                //GO to main thread and update the views
                NSLog(@"MATCHED");
                [ParseAPICalls updateMatchWithLocalUser:dataManager.user withOtherParseUser:dataManager.potentialMatchArray[0] withCompletion:^(BOOL success) {
                }];
            }
        }];
        [self.trackPotentialMatches removeObjectAtIndex:0];
    }
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        self.backCardView.alpha = 0.0;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.backCardView.alpha = 1.f;
        } completion:nil];
    }
}

-(ChoosePersonViewOurs *)popPersonViewWithFrame:(CGRect)frame{
    
    if (self.potentialMatches.count ==0) {
        return  nil;
    }
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x, frame.origin.y - (state.thresholdRatio * 10.f), CGRectGetWidth(frame), CGRectGetHeight(frame));
    };
    ChoosePersonViewOurs *personView = [[ChoosePersonViewOurs alloc] initWithFrame:frame user:self.potentialMatches[0] options:options];
    [self.trackPotentialMatches addObject:self.potentialMatches[0]];
    [self.potentialMatches removeObjectAtIndex:0];
    return personView;
    
}

-(void)setFrontCardView:(ChoosePersonViewOurs *)frontCardView{
    _frontCardView = frontCardView;
    self.user = frontCardView.user;
}

#pragma mark - Construction

-(CGRect)frontCardViewFrame{
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 90.f;
    CGFloat bottomPadding = 320.f;
    return CGRectMake(horizontalPadding, topPadding, CGRectGetWidth(self.view.frame) - (horizontalPadding *2), CGRectGetHeight(self.view.frame) - bottomPadding);
}


-(CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    
    return CGRectMake(frontFrame.origin.x, frontFrame.origin.y + 10.f, CGRectGetWidth(frontFrame), CGRectGetHeight(frontFrame));
    
}

#pragma mark - button creation

// Create and add the "nope" button.
- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"nope@2x.png"];
    button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding + 450.f,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:247.f/255.f
                                         green:91.f/255.f
                                          blue:37.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    
    self.rejectButton = button;
    
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"liked@2x.png"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding + 450.f,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    
    self.likeButton = button;
    
    [self.view addSubview:button];
}

#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

@end
