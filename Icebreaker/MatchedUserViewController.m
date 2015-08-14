//
//  MatchedUserViewController.m
//  Icebreaker
//
//  Created by Nicholas Ang on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "MatchedUserViewController.h"
#import "GameViewController.h"

@interface MatchedUserViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *userAboutInformationTextView;
@property (weak, nonatomic) IBOutlet UITextView *userLikesTextView;

@end

@implementation MatchedUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInformation];
    [self setUpTitleView];
}

- (void)setupInformation
{
    self.userProfileImage.layer.cornerRadius = 65;
    self.userProfileImage.clipsToBounds = YES;
     UIImage *profilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.matchedUser[@"profile_photo"]]]];
    self.userProfileImage.image = profilePhoto;
    
    
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.matchedUser[@"first_name"], self.matchedUser[@"last_name"]];
    self.userAboutInformationTextView.text = self.matchedUser[@"aboutInformation"];
    NSString *likesString = @"";
    if (self.matchedUser[@"likes"]) {
        for (NSString *like in self.matchedUser[@"likes"]) {
            likesString = [likesString stringByAppendingString:[NSString stringWithFormat:@"%@\n", like]];
        }
    }
    
    self.userLikesTextView.text = likesString;
}

- (void)setUpTitleView
{
    self.navigationBar.title = self.matchedUser[@"first_name"];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"@Game"]) {
        GameViewController *gameVC = segue.destinationViewController;
        gameVC.matchedUser = self.matchedUser;
        
    }
   


}


@end
