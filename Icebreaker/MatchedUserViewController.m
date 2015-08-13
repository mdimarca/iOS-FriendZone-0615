//
//  MatchedUserViewController.m
//  Icebreaker
//
//  Created by Nicholas Ang on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "MatchedUserViewController.h"

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupInformation
{
    self.userProfileImage.layer.cornerRadius = 65;
    self.userProfileImage.clipsToBounds = YES;
}

- (void)setUpTitleView
{
    self.navigationBar.title = @"Joe";
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
