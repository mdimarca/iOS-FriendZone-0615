//
//  ParseAPICalls.m
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 8/5/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "ParseAPICalls.h"
#import "DataStore.h"

@interface ParseAPICalls ()


@end

@implementation ParseAPICalls



+ (void)getPotentialMatchesWithCompletionBlock:(void (^)(NSArray *matches, BOOL success))completionBlock {
    
    NSMutableArray *potentialMatchesArray = [NSMutableArray new];
    PFUser *currentUserHere = [PFUser currentUser];
    
    PFQuery *userQuery = [PFUser query];
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error)
     {
         if (error == nil) {
             for (PFUser *user in object) {
                 if (![self isUserAlreadySwipedOrSelf:user]) {
                     
                     UIImage *coverPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user[@"coverPhotoURLString"]]]];
                     UIImage *profilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user[@"profile_photo"]]]];
                     NSLog(@"%@",profilePhoto);
                     
                     User *localUser = [User newUserWithFirstName:user[@"first_name"]
                                                         lastName: user[@"last_name"]
                                                       facebookID:user[@"facebookID"]
                                                           gender:user[@"gender"]
                                                     profilePhoto:profilePhoto
                                                       coverPhoto:coverPhoto
                                                         pictures:[@[] mutableCopy]
                                                 aboutInformation:user[@"aboutInformation"]
                                                          matches:user[@"matches"]
                                                          friends:[@[] mutableCopy]
                                                            likes:user[@"likes"]
                                                 rejectedProfiles:user[@"rejected_profiles"]
                                                 acceptedProfiles:user[@"accepted_profiles"]];
                     [potentialMatchesArray addObject:localUser];
                     
                     NSLog(@"The users first name WHICH IS A MATCH IS !!! : %@", localUser.firstName);
                     
                 }
             }
             completionBlock(potentialMatchesArray, YES);
         }
         
         completionBlock(nil, NO);
     }];
}

+(BOOL)isUserAlreadySwipedOrSelf:(PFUser *)unfilteredPotentialMatch{
    DataStore *dataManager = [DataStore sharedDataStore];
    User *localUser = dataManager.user;
    NSString *otherUserFacebookID = unfilteredPotentialMatch[@"facebookID"];
    
    NSLog(@"This is the facebook ID from the method: %@", otherUserFacebookID);
    
    return [localUser.acceptedProfiles containsObject:otherUserFacebookID] ||
    [localUser.rejectedProfiles containsObject:otherUserFacebookID] ||
    [localUser.facebookID isEqualToString:otherUserFacebookID];
}

+(void)updateParsePotentialMatchesWithFacebookID:(NSString *)facebookID withAccepted:(BOOL)accepted withCompletion:(void (^)(BOOL success))completionBlock {
    PFUser *currentUser = [PFUser currentUser];
    
    if (accepted) {
        [currentUser addObject:facebookID forKey:@"accepted_profiles"];
    } else {
        [currentUser addObject:facebookID forKey:@"rejected_profiles"];
    }
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The currentUser saved successfully.
            completionBlock(YES);
        } else {
            // There was an error saving the currentUser.
            NSLog(@"error");
            completionBlock(NO);
        }
    }];
}

+(void)isSwipeAMatch:(NSString *)facebookID withCompletion:(void (^)(BOOL success, User *matchedUser))completionBlock {
    
//    DataStore *dataManager = [DataStore sharedDataStore];
    
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"facebookID" equalTo:facebookID];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *userHere, NSError *error) {
        
        PFUser *userWeJustLiked = (PFUser *)userHere;
        
        NSArray *likesMadeFromUserWeJustLiked = userWeJustLiked[@"accepted_profiles"];
        
//        UIImage *profilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userWeJustLiked[@"profile_photo"]]]];
//        
//        NSString *name = userWeJustLiked[@"first_name"];
        
        NSString *currentUserFBID = currentUser[@"facebookID"];

        if ([likesMadeFromUserWeJustLiked containsObject:currentUserFBID]) {
            
            
        
            
            

            
            
            //This is saving OURSELF (the currentUser) to the user we just liked.

            PFQuery *newQuery = [PFQuery queryWithClassName:@"Relationship"];
            
            [newQuery whereKey:@"owner" equalTo:userWeJustLiked];
            
            [newQuery getFirstObjectInBackgroundWithBlock:^(PFObject *userRelationship, NSError *error) {
                
                
                PFRelation *otherUserRelation = userRelationship[@"matchesMade"];
                
                [otherUserRelation addObject:currentUser];
                
                [userRelationship saveInBackground];
                

                
            
            }];
                
            
            
            //This is saving the person we just liked to OUR (currentUser) matchesMade relationship in parse
            PFQuery *queryForCurrentUser = [PFQuery queryWithClassName:@"Relationship"];
            
            [queryForCurrentUser whereKey:@"owner" equalTo:currentUser];
            
            [queryForCurrentUser getFirstObjectInBackgroundWithBlock:^(PFObject *userRelationship, NSError *error) {
                
                
                PFRelation *relation = userRelationship[@"matchesMade"];
                
                [relation addObject:userWeJustLiked];
                
                [userRelationship saveInBackground];
                
                
                
                
            }];
            

            
            
            
            
//            PFRelation *relation = [currentUser relationForKey:@"matchesMade"];
//            [relation addObject:userFromRequest];
//            
//            [currentUser saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
//                if (success) {
//                    
//                    
//                    NSLog(@"Cool, successs");
//                    
//                    PFRelation *otherUserRelation = [userFromRequest relationForKey:@"matchesMade"];
//                    
//                    
//                    [otherUserRelation addObject:currentUser];
//                    
//                    [userFromRequest saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
//                        if (success) {
//                            
//                            NSLog(@"Added to other persons LIKE, ");
//                            
//                            
//                            
//                        }
//                    }];

                    
                    
                    
                }
            }];

            
           
            
            
            

    
    
//    PFQuery *userQuery = [PFUser query];
//    
//    NSLog(@"FACEBOOK ID OF SWIPE %@",facebookID);
//    
//    [userQuery whereKey:@"facebookID" equalTo:facebookID];
//    
//    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error)
//     {
//         if (object != nil) {
//             PFUser *user = (PFUser *)object[0];
//             
//             NSLog(@"SWIPED USERNAME %@",user[@"first_name"]);
//             
//             NSMutableArray *otherUserAcceptedProfiles= [user[@"accepted_profiles"] mutableCopy];
//             
//             NSLog(@"%@ SWIPED USERS ACCEPTED USRS PROFILES",otherUserAcceptedProfiles);
//             
//             NSLog(@"%@ MY FACEBOOK ID",dataManager.user.facebookID);
//             
//             if ([otherUserAcceptedProfiles containsObject:dataManager.user.facebookID]) {
//                 
//                 NSLog(@"%@ OTHER USRS PROFILES",otherUserAcceptedProfiles);
//                 
//                 
//                 //being here means you're a match!!!
//                 
//                 //             otherUser = user;
//                 
//                 //Check if the users property matches
//                 
//                 //convert pfuser to a local instance
//                 NSString *profilephotoURLString = user[@"profilePhoto"];
//                 UIImage *profilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilephotoURLString]]];
//                 UIImage *coverPhotograph = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user[@"coverPhotoURLString"]]]];
//                 
//                 User *matchUser = [User newUserWithFirstName:user[@"first_name"]
//                                                     lastName: user[@"last_name"]
//                                                   facebookID:user[@"facebookID"]
//                                                       gender:user[@"gender"]
//                                                 profilePhoto:profilePhoto
//                                                   coverPhoto:coverPhotograph
//                                                     pictures:[@[] mutableCopy]
//                                             aboutInformation:user[@"aboutInformation"]
//                                                      matches:user[@"matches"]
//                                                      friends:[@[] mutableCopy]
//                                                        likes:user[@"likes"]
//                                             rejectedProfiles:user[@"rejected_profiles"]
//                                             acceptedProfiles:user[@"accepted_profiles"]];
//                 
//                 [dataManager.user.matches addObject:matchUser];
//                 
//                 completionBlock(YES,matchUser);
//                 
//             } else {
//                 //not a match.
//                 completionBlock(NO, nil);
//             }
//         } else {
//             completionBlock(NO,nil);
//         }
//     }];
//    
//    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            // The currentUser saved successfully.
//            NSLog(@"all good");
//        } else {
//            // There was an error saving the currentUser.
//            NSLog(@"error");
//            
//        }
//    }];
    
    //    [self updateMatchWithLocalUser:dataManager.user withOtherParseUser:otherUser withCompletion:^(BOOL success) {
    //        if (success) {
    //            NSLog(@"success update the other user on parse");
    //        } else {
    //            NSLog(@"failed update the other user on parse");
    //        }
    //    }];
}

+(void)updateMatchWithLocalUser:(User *)currentLocalUser withOtherParseUser:(PFUser *)otherUser withCompletion:(void (^)(BOOL success))completionBlock {
    PFUser *currentUser = [PFUser currentUser];
    PFUser *otherUserHere = otherUser;
    //    [otherUserHere[@"matches"] addObject:currentLocalUser.facebookID];
    [currentUser addObject:otherUserHere[@"facebookID"] forKey:@"matches"];
    [otherUserHere addObject:currentLocalUser.facebookID forKey:@"matches"];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The currentUser saved successfully.
            completionBlock(YES);
        } else {
            // There was an error saving the currentUser.
            NSLog(@"error");
            completionBlock(NO);
        }
    }];
    
    [otherUserHere saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The currentUser saved successfully.
            completionBlock(YES);
        } else {
            // There was an error saving the currentUser.
            NSLog(@"error");
            completionBlock(NO);
        }
    }];
}

+ (void)getMatchesFromParseWithCompletionBlock:(void (^)(BOOL success, NSArray *matches))completionBlock
{
    
    //**** PF Relation gets created *********
 

    
//    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // There was an error
//            NSLog(@"WHAT IS THIS?????    ______--------> %@", objects);
//
//        } else {
//            // objects has all the Posts the current user liked.
//        }
//    }];
    
    // set up our query for a User object
    PFQuery *userQuery = [PFUser query];
    
    // configure any constraints on your query...
    // for example, you may want users who are also playing with or against you
    // tell the query to fetch all of the Weapon objects along with the user
    // get the "many" at the same time that you're getting the "one"
    
    [userQuery includeKey:@"matches"];
    
    // execute the query
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        
        
        
        // objects contains all of the User objects, and their associated Weapon objects, too
    }];
    
    
    
//    //convert pfuser to a local instance
//    NSString *profilephotoURLString = user[@"profilePhoto"];
//    UIImage *profilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilephotoURLString]]];
//    UIImage *coverPhotograph = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user[@"coverPhotoURLString"]]]];
//    
//    User *matchUser = [User newUserWithFirstName:user[@"first_name"]
//                                        lastName: user[@"last_name"]
//                                      facebookID:user[@"facebookID"]
//                                          gender:user[@"gender"]
//                                    profilePhoto:profilePhoto
//                                      coverPhoto:coverPhotograph
//                                        pictures:[@[] mutableCopy]
//                                aboutInformation:user[@"aboutInformation"]
//                                         matches:user[@"matches"]
//                                         friends:[@[] mutableCopy]
//                                           likes:user[@"likes"]
//                                rejectedProfiles:user[@"rejected_profiles"]
//                                acceptedProfiles:user[@"accepted_profiles"]];
//    
//    
//    NSLog(@"What are you: %@", user);
//    NSLog(@"My god, this would be cooL: %@", matchUser.firstName);
//    
//    NSLog(@"ARRAY ARRAY ARAY:::??? :%@", matchUser.matches);
//    
//    
//    
//    NSArray *matches = user[@"matches"];
//    
//    NSLog(@"Is this actually WORKING!!!! _ %@", matches);
//    
//    completionBlock(YES, matches);
//    
//} else {
//    
//    completionBlock(NO, nil);
//}
//}];





}


@end
