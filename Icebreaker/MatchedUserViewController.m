//
//  MatchedUserViewController.m
//  Icebreaker
//
//  Created by Nicholas Ang on 7/29/15.
//  Copyright (c) 2015 ChickenBiscuit. All rights reserved.
//

#import "MatchedUserViewController.h"
#import "GameViewController.h"

@interface MatchedUserViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *userAboutInformationTextView;
@property (weak, nonatomic) IBOutlet UITextView *userLikesTextView;

@property(nonatomic) BOOL iceBroken;

@property (weak, nonatomic) IBOutlet UIImageView *profileCoverPhoto;
@property (weak, nonatomic) IBOutlet UIButton *breakTheIceButton;

@end

@implementation MatchedUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInformation];
    [self setUpTitleView];
    
    //CHECK if icebroken
    self.iceBroken = NO;
    
    PFUser *currentUser = [PFUser currentUser];
    NSMutableArray *iceBrokenArray = currentUser[@"ice_broken"];
    if ([iceBrokenArray containsObject:self.matchedUser[@"facebookID"]]) {
       //SET ICE BREAK
        self.iceBroken  = YES;
    }
    [self setUpCoverPhotoBlurView];
    
    self.breakTheIceButton.layer.cornerRadius = 4;
}

- (void)setupInformation
{
    self.userProfileImage.layer.cornerRadius = 65;
    self.userProfileImage.clipsToBounds = YES;
     UIImage *profilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.matchedUser[@"profile_photo"]]]];
    self.userProfileImage.image = profilePhoto;
    self.userProfileImage.layer.borderWidth = 2;
    self.userProfileImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.matchedUser[@"first_name"], self.matchedUser[@"last_name"]];
    self.userAboutInformationTextView.text = self.matchedUser[@"aboutInformation"];
    NSString *likesString = @"";
    if (self.matchedUser[@"likes"]) {
        for (NSString *like in self.matchedUser[@"likes"]) {
            likesString = [likesString stringByAppendingString:[NSString stringWithFormat:@"%@\n", like]];
        }
    }
    
    UIImage *coverProfile = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.matchedUser[@"coverPhotoURLString"]]]];
    NSLog(@"%@ COVERPHOTO",coverProfile);
    self.profileCoverPhoto.image = coverProfile;
    self.profileCoverPhoto.clipsToBounds = YES;
    self.userLikesTextView.text = likesString;
}

-(void)setUpCoverPhotoBlurView{
    UIView *alphaView = [[UIView alloc]initWithFrame:self.profileCoverPhoto.bounds];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.4;
    [self.profileCoverPhoto addSubview:alphaView];
}

- (void)setUpTitleView
{
    self.navigationBar.title = self.matchedUser[@"first_name"];
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GameViewController *gameVC = [segue destinationViewController];
    gameVC.matchedUser = self.matchedUser;
    gameVC.isIceBroken = self.iceBroken;
    NSLog(@"ICEBROKEN USERS %d",self.iceBroken);
}


@end
