//
//  ViewController.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 7/28/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "friendSwiperViewController.h"

@interface ViewController () <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    //loginButton.center = self.view.center;
    //[self.view addSubview:loginButton];
    
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.delegate = self;
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // segue to next view
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - FB Login Button delegate method
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
        UINavigationController *navController = [segue destinationViewController];
        friendSwiperViewController *friendSwiperViewContollerThing = navController.viewControllers.firstObject;
    }
}

@end
