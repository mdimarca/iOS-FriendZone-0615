//
//  LoginViewController.m
//  Icebreaker
//
//  Created by Gan Chau on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import "friendSwiperViewController.h"
#import <Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>


@interface LoginViewController () //<FBSDKLoginButtonDelegate>

//@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Log In with Read Permissions
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[ @"public_profile", @"user_about_me", @"user_likes" ] block:^(PFUser *user, NSError *error) {
//        if (!user) {
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//            
//
//        } else if (user.isNew) {
//            NSLog(@"User signed up and logged in through Facebook!");
//            
//                        [self performSegueWithIdentifier:@"loginSegue" sender:self];
//
//        } else {
//            NSLog(@"User logged in through Facebook!");
//            
//                        [self performSegueWithIdentifier:@"loginSegue" sender:self];
//
//        }
//    }];
//    
//    // Request new Publish Permissions
//    [PFFacebookUtils linkUserInBackground:[PFUser currentUser]
//                   withPublishPermissions:@[ @"publish_actions"]
//                                    block:^(BOOL succeeded, NSError *error) {
//                                        if (succeeded) {
//                                            NSLog(@"User now has read and publish permissions!");
//                                        }
//                                    }];
    
    
    
    
    
    
    
    
    
    
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[ @"public_profile", @"user_about_me", @"user_likes" ] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else {
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook.");
            } else {
                NSLog(@"User logged in through Facebook.");
            }
//            [PFFacebookUtils linkUserInBackground:[PFUser currentUser]
//                           withPublishPermissions:@[ @"publish_actions"]
//                                            block:^(BOOL succeeded, NSError *error) {
//                                                if (succeeded) {
//                                                    NSLog(@"User now has read and publish permissions!");
//                                                }
//                                            }];
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
            
        }
    }];
     
        
        
//        else if (user.isNew) {
//            NSLog(@"User signed up and logged in through Facebook!");
//            
//            [PFFacebookUtils linkUserInBackground:[PFUser currentUser]
//                           withPublishPermissions:@[ @"publish_actions"]
//                                            block:^(BOOL succeeded, NSError *error) {
//                                                if (succeeded) {
//                                                    NSLog(@"User now has read and publish permissions!");
//                                                }
//                                            }];
//
//            
//            [self performSegueWithIdentifier:@"loginSegue" sender:self];
//            
//        } else {
//            
//            NSLog(@"User logged in through Facebook!");
//            
//            [PFFacebookUtils linkUserInBackground:[PFUser currentUser]
//                           withPublishPermissions:@[ @"publish_actions"]
//                                            block:^(BOOL succeeded, NSError *error) {
//                                                if (succeeded) {
//                                                    NSLog(@"User now has read and publish permissions!");
//                                                }
//                                            }];
//
//            
//            [self performSegueWithIdentifier:@"loginSegue" sender:self];
//
//        }
//    }];
    
//     Request new Publish Permissions
//        [PFFacebookUtils linkUserInBackground:[PFUser currentUser]
//                       withPublishPermissions:@[ @"publish_actions"]
//                                        block:^(BOOL succeeded, NSError *error) {
//                                            if (succeeded) {
//                                                NSLog(@"User now has read and publish permissions!");
//                                            }
//                                        }];

    
//    self.loginButton.readPermissions = @[@"public_profile", @"user_about_me", @"user_likes"];
//    self.loginButton.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
        
        
        
        NSDictionary *params = @{ @"fields" : @"id, first_name, last_name, gender, picture.width(100).height(100), cover, bio, likes" };
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me" parameters:params];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSLog(@"fetched user:%@", result);
                
                NSString *firstName = result[@"first_name"];
                NSString *lastName = result[@"last_name"];
                NSString *facebookID = result[@"id"];
                NSString *gender = result[@"gender"];
                NSString *aboutInformation = result[@"bio"];
                NSArray *likesData = result[@"likes"][@"data"];
                NSMutableArray *likes = [@[] mutableCopy];
                
            

                NSString *coverPhotoURLString = result[@"cover"][@"source"];
                UIImage *coverPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:coverPhotoURLString]]];
                
                PFUser *user = [PFUser currentUser];
                user[@"first_name"] = firstName;
                user[@"last_name"] = lastName;
                user[@"facebookID"] = facebookID;
                user[@"gender"] = gender;
                user[@"aboutInformation"] = aboutInformation;
                user[@"coverPhotoURLString"] = coverPhotoURLString;
                
//                PFRelation *likeRelation = [user relationForKey:@"likes"];
                //need to put an array of the user's likes in there
                for (NSDictionary *likesDictionary in likesData) {
                    NSString *like = likesDictionary[@"name"];
                    
//                    PFObject *likePFObject = [PFObject objectWithClassName:@"like"];
//                    likePFObject[@"content"] = like;
//                    [likeRelation addObject:likePFObject];
                    [likes addObject:like];
                    
                    NSLog(@"I like %@", like);
                }
                
                user[@"likes"] = [likes copy];
                
                
                //saves the information for a user on parse
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded){
                        NSLog(@"The user's information and relations have been updated");
                    } else {
                        NSLog(@"Error updating user information: %@", error.description);
                    }
                }];
            }
        }];
        

    }
}

//#pragma mark - FB Login Button delegate method
//- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
//{
//    [self performSegueWithIdentifier:@"loginSegue" sender:self];
//}
//
//- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
//{
//    
//}

@end
