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
#import <Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "User.h"
#import "DataStore.h"

@interface LoginViewController ()

@property (strong, nonatomic) NSString *facebookIDLocal;
@property (strong, nonatomic) NSString *parseIDLocal;
@property (strong, nonatomic) User *localUser;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //FACEBOOK PERMISSIONS
    [PFFacebookUtils logInInBackgroundWithReadPermissions:@[ @"public_profile", @"user_about_me", @"user_likes", @"user_friends" ] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else {
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook.");
            } else {
                NSLog(@"User logged in through Facebook.");
            }

            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createLocalUserWithFirstName:(NSString *)firstName lastName:(NSString *)lastName facebookID:(NSString *)facebookID gender:(NSString *)gender aboutInformation:(NSString *)aboutInformation likes:(NSArray *)likes coverPhoto:(UIImage *)coverPhoto {
    
    //MAKE A LOCAL INSTANCE OF THE USER
//    User *user = [self.user initWithFirstName:firstName
//                   lastName:lastName
//                 facebookID:facebookID
//                     gender:gender
//                 coverPhoto:coverPhoto
//                   pictures:<#(NSMutableArray *)#>
//           aboutInformation:aboutInformation
//                    matches:[[NSMutableArray alloc] init];
//                    friends:<#(NSMutableArray *)#>
//                      likes:likes];
    
//    //PUT LOCAL USER INSTANCE IN SHARED DATA
//    self.user = user;
}

-(void)getFacebookUserDataAndPutInParse{
    //FACEBOOK DATA CALL
    
    //NSDictionary *friendsParam = @{ @"fields" : @"data"};
    FBSDKGraphRequest *friendsRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/friends" parameters:nil];
    [friendsRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"friends of user: %@", result);
        } else {
            NSLog(@"Cannot fetch friends: %@", error.description);
        }
    }];

    
    NSDictionary *params = @{ @"fields" : @"id, first_name, last_name, gender, picture.width(100).height(100), cover, bio, likes" };
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me" parameters:params];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"fetched user:%@", result);
            
            //FACEBOOK DATA
            NSString *firstName = result[@"first_name"];
            NSString *lastName = result[@"last_name"];
            NSString *facebookID = result[@"id"];
            NSString *gender = result[@"gender"];
            NSString *aboutInformation = result[@"bio"];
            NSArray *likesData = result[@"likes"][@"data"];
            NSMutableArray *likes = [@[] mutableCopy];
            NSString *coverPhotoURLString = result[@"cover"][@"source"];
            UIImage *coverPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:coverPhotoURLString]]];
            
            NSString *profilePhotoURLString = result[@"picture"][@"data"][@"url"];
            UIImage *profilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilePhotoURLString]]];
            
            for (NSDictionary *likesDictionary in likesData) {
                NSString *like = likesDictionary[@"name"];
                [likes addObject:like];
                
                NSLog(@"I like %@", like);
            }
            
            //SET THE LOCAL PROPERTY EQUAL TO THE FACEBOOK ID SINCE IT IS UNIQUE
            self.facebookIDLocal = facebookID;
            
            //FACEBOOK DATA -> PARSE USER OBJECT
            PFUser *user = [PFUser currentUser];
            user[@"first_name"] = firstName;
            user[@"last_name"] = lastName;
            user[@"facebookID"] = facebookID;
            user[@"gender"] = gender;
            user[@"aboutInformation"] = aboutInformation;
            user[@"coverPhotoURLString"] = coverPhotoURLString;
            user[@"likes"] = [likes copy];
            user[@"matches"] = [@[] mutableCopy];
            
            //SHARED LOCAL USER
            self.localUser = [[User alloc] init];
            self.localUser.firstName = firstName;
            self.localUser.lastName = lastName;
            self.localUser.coverPhoto = coverPhoto;
            self.localUser.profilePhoto = profilePhoto;
            self.localUser.gender = gender;
            self.localUser.aboutInformation = aboutInformation;
            self.localUser.likes = likes;
            DataStore *dataStore = [DataStore sharedDataStore];
            dataStore.user = self.localUser;
            
            //SAVES INFORMATION ON PARSE
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    NSLog(@"The user's information and relations have been updated");
                } else {
                    NSLog(@"Error updating user information: %@", error.description);
                }
            }];
            
            //CREATE A LOCAL USER
//            [self createLocalUserWithFirstName:firstName
//                                      lastName:lastName
//                                    facebookID:facebookID
//                                        gender:gender
//                              aboutInformation:aboutInformation
//                                         likes:[likes copy]
//                                    coverPhoto:coverPhoto];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
        //MUST CREATE AN INSTANCE OF THE USER LOGGING IN ON PARSE AND LOCALLY FOR USE
        [self getFacebookUserDataAndPutInParse];
    }
}

@end
