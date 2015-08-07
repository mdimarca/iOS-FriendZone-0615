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
static const CGFloat ChoosePersonButtonHVerticalPadding = 20.f;

@interface friendSwiperViewController () <MDCSwipeToChooseDelegate>

@property (strong, nonatomic) DataStore *dataManager;
@property (strong, nonatomic) NSMutableArray *potentialMatches;
@property (nonatomic, strong) NSMutableArray *trackPotentialMatches;

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
}

#pragma mark - MDCSwipeToChooseDelegate Callbacks

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    DataStore *dataManager = self.dataManager;

     User *user = self.trackPotentialMatches[0];
    
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




@end
