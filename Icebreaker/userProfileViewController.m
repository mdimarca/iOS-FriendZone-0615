//
//  userProfileViewController.m
//  Icebreaker
//
//  Created by Gan Chau on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "userProfileViewController.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import "DataStore.h"

@interface userProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverPhotoImageView;
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *profilePhotoImageView;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;
@property (weak, nonatomic) IBOutlet UITextView *likesTextView;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end

@implementation userProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateData];

}

- (void)updateData
{
    DataStore *dataStore = [DataStore sharedDataStore];
//    NSLog(@"COVER PHOTO ISSUE: %@", self);
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", dataStore.user.firstName, dataStore.user.lastName];
    self.coverPhotoImageView.image = dataStore.user.coverPhoto;
    self.coverPhotoImageView.clipsToBounds = YES;
    
    self.profilePhotoImageView.layer.cornerRadius = 40;
    self.profilePhotoImageView.layer.borderWidth = 1;
    self.profilePhotoImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profilePhotoImageView.clipsToBounds = YES;
    
    self.aboutLabel.text = [NSString stringWithFormat:@"About %@", dataStore.user.firstName];
    self.aboutTextView.text = dataStore.user.aboutInformation;
    
    NSString *likesString = @"";
    if (dataStore.user.likes) {
        for (NSString *like in dataStore.user.likes) {
            likesString = [likesString stringByAppendingString:[NSString stringWithFormat:@"%@\n", like]];
        }
    }

    self.likesTextView.text = likesString;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutButtonTapped:(id)sender {
    [PFUser logOut];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
