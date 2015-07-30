//
//  userProfileViewController.m
//  Icebreaker
//
//  Created by Gan Chau on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "userProfileViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "DataStore.h"

@interface userProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation userProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DataStore *dataStore = [DataStore sharedDataStore];
    
    self.userNameLabel.text = dataStore.user.name;
    NSLog(@"%@", dataStore.user.name);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
