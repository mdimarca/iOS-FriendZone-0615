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
#import "friendSwiperViewController.h"


@interface LoginViewController ()

@property (strong, nonatomic) NSString *facebookIDLocal;
@property (strong, nonatomic) NSString *parseIDLocal;
@property (strong, nonatomic) User *localUser;
@property (nonatomic) BOOL previouslyLoggedIn;
@property (weak, nonatomic) IBOutlet UIImageView *loginImage1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image2TrailingConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *loginImage2;
@property (weak, nonatomic) IBOutlet UIImageView *loginImage3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image2LeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image1LeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image3TopConstraint;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *facebookButtonBottomConstraint;

//@property (weak, nonatomic) IBOutlet UIView *hackView;
@property (nonatomic, strong) DataStore *dataStore;

@end

@implementation LoginViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)facebookLoginTapped:(id)sender {
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataStore = [DataStore sharedDataStore];
    
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [self imageReset];
    [self facebookLoginButtonAnimation];
}

- (void)facebookLoginButtonAnimation {
    [UIView animateWithDuration:.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.facebookButtonBottomConstraint.constant = 30;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:.15
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.facebookButtonBottomConstraint.constant = 25;
                                              [self.view layoutIfNeeded];
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:.15
                                                                    delay:0
                                                                  options:UIViewAnimationOptionCurveEaseOut
                                                               animations:^{
                                                                   self.facebookButtonBottomConstraint.constant = 30;
                                                                   [self.view layoutIfNeeded];
                                                               } completion:^(BOOL finished) {
                                                                   
                                                               }];
                                          }];
                     }];
}

- (void)imageReset
{
    self.image1LeadingConstraint.constant = 0;
    self.image2LeadingConstraint.constant = 0;
    self.image3TopConstraint.constant = 0;
    self.loginImage2.alpha = 0;
    self.loginImage3.alpha = 0;
}

- (void)animateImages
{
    [UIView animateKeyframesWithDuration:18
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0
                                                          relativeDuration:0.4
                                                                animations:^{
                                                                    self.image1LeadingConstraint.constant = -100;
                                                                    [self.view layoutIfNeeded];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.2
                                                          relativeDuration:0.2
                                                                animations:^{
                                                                    self.loginImage2.alpha = 1;
                                                                    self.image2LeadingConstraint.constant = -50;
                                                                    [self.view layoutIfNeeded];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.4
                                                          relativeDuration:0.4
                                                                animations:^{
                                                                    self.image2LeadingConstraint.constant = -150;
                                                                    [self.view layoutIfNeeded];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.6
                                                          relativeDuration:0.2
                                                                animations:^{
                                                                    self.loginImage3.alpha = 1;
                                                                    self.image3TopConstraint.constant = -50;
                                                                    [self.view layoutIfNeeded];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.8
                                                          relativeDuration:0.2
                                                                animations:^{
                                                                    self.image3TopConstraint.constant = -100;
                                                                    [self.view layoutIfNeeded];
                                                                }];
                              }
                              completion:^(BOOL finished) {
                                  NSLog(@"Animation completed.");
                              }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self animateImages];
    
    self.previouslyLoggedIn = NO;
    if ([PFUser currentUser] ||
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        self.previouslyLoggedIn = YES;
//        self.hackView.hidden = NO;
        
        
    }

    
    if (self.previouslyLoggedIn) {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createLocalUserWithFirstName:(NSString *)firstName lastName:(NSString *)lastName facebookID:(NSString *)facebookID gender:(NSString *)gender aboutInformation:(NSString *)aboutInformation likes:(NSArray *)likes coverPhoto:(UIImage *)coverPhoto {
    
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
    
    
    NSDictionary *params = @{ @"fields" : @"id, first_name, last_name, gender, picture.width(400).height(400), cover, bio, likes" };
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
            if (aboutInformation != nil) {
                user[@"aboutInformation"] = aboutInformation;
            }
            else{
                user[@"aboutInformation"] = @"";
            }
            user[@"coverPhotoURLString"] = coverPhotoURLString;
            user[@"likes"] = [likes copy];
            user[@"matches"] = [@[] mutableCopy];
            user[@"profile_photo"] = profilePhotoURLString;
            user[@"rejected_profiles"] = [@[] mutableCopy];
            user[@"accepted_profiles"] = [@[] mutableCopy];
            
            //Parse search for users
            PFQuery *userQuery = [PFUser query];
            [userQuery findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error)
             {
                 for (PFUser *user in object) {
                     NSLog(@"Query result: %@", user[@"first_name"]);
                 }
             }];
            
            //SHARED LOCAL USER
            self.localUser = [[User alloc] init];
            self.localUser.firstName = firstName;
            self.localUser.lastName = lastName;
            self.localUser.coverPhoto = coverPhoto;
            self.localUser.profilePhoto = profilePhoto;
            self.localUser.gender = gender;
            self.localUser.aboutInformation = aboutInformation;
            self.localUser.likes = likes;
            self.localUser.facebookID = facebookID;
            self.localUser.pictures = [@[] mutableCopy];
            self.localUser.friends = [@[] mutableCopy];
            DataStore *dataStore = [DataStore sharedDataStore];
            dataStore.user = self.localUser;
         
            //SAVES INFORMATION ON PARSE
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    PFQuery *queryForCurrentUser = [PFQuery queryWithClassName:@"Relationship"];
                    [queryForCurrentUser whereKey:@"owner" equalTo:user];
                    [queryForCurrentUser getFirstObjectInBackgroundWithBlock:^(PFObject *userRelationship, NSError *error) {
    
                        if (error.code == 101) {
                            NSLog(@"USERRELATIONSHIP %@",userRelationship);
                            NSLog(@"RELATIONSHIP DOESNT EXIST");
                            PFObject *matchesInHeaven = [PFObject objectWithClassName:@"Relationship"];
                            matchesInHeaven[@"owner"] = user;
                            [matchesInHeaven saveInBackground];
                            
                            NSLog(@"The user's information and relations have been updated");
                            }
                        }];
                } else {
                    NSLog(@"Error updating user information: %@", error.description);
                }
            }];
        }
    }];
}

//-(BOOL)doesRelationshipExist{
//     PFUser *currentUser = [PFUser currentUser];
//    PFQuery *queryForCurrentUser = [PFQuery queryWithClassName:@"Relationship"];
//    [queryForCurrentUser whereKey:@"owner" equalTo:currentUser];
//    [queryForCurrentUser getFirstObjectInBackgroundWithBlock:^(PFObject *userRelationship, NSError *error) {
//        if (!error) {
//            if (userRelationship != nil){
//                return YES;
//            }
//        }
//    }];
//    return NO;
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"loginSegue"]) {
        if (self.previouslyLoggedIn) {
            //DO PARSE
            [self.dataStore fetchCurrentUserData];
        }
        else if (!self.previouslyLoggedIn){
            //MUST CREATE AN INSTANCE OF THE USER LOGGING IN ON PARSE AND LOCALLY FOR USE
            [self getFacebookUserDataAndPutInParse];
        }
    }
}

@end
