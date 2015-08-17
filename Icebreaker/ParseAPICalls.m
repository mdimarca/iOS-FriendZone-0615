//
//  ParseAPICalls.m
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 8/5/15.
//  Copyright (c) 2015 ChickenBiscuit. All rights reserved.
//

#import "ParseAPICalls.h"
#import "DataStore.h"

@interface ParseAPICalls ()

@end

@implementation ParseAPICalls

+ (void)getPotentialMatchesWithCompletionBlock:(void (^)(NSArray *matches, BOOL success))completionBlock
{
    NSMutableArray *potentialMatchesArray = [NSMutableArray new];
    
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
                                                         lastName:user[@"last_name"]
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

+ (BOOL)isUserAlreadySwipedOrSelf:(PFUser *)unfilteredPotentialMatch
{
    DataStore *dataManager = [DataStore sharedDataStore];
    User *localUser = dataManager.user;
    NSString *otherUserFacebookID = unfilteredPotentialMatch[@"facebookID"];
    
    NSLog(@"This is the facebook ID from the method: %@", otherUserFacebookID);
    
    return [localUser.acceptedProfiles containsObject:otherUserFacebookID] ||
    [localUser.rejectedProfiles containsObject:otherUserFacebookID] ||
    [localUser.facebookID isEqualToString:otherUserFacebookID];
}

+ (void)updateParsePotentialMatchesWithFacebookID:(NSString *)facebookID
                                     withAccepted:(BOOL)accepted
                                   withCompletion:(void (^)(BOOL success))completionBlock {
    
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

+ (void)isSwipeAMatch:(NSString *)facebookID
       withCompletion:(void (^)(BOOL success, User *matchedUser))completionBlock {
    
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"facebookID" equalTo:facebookID];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *userHere, NSError *error) {
        PFUser *userWeJustLiked = (PFUser *)userHere;
        NSArray *likesMadeFromUserWeJustLiked = userWeJustLiked[@"accepted_profiles"];
        NSString *currentUserFBID = currentUser[@"facebookID"];
        
        if ([likesMadeFromUserWeJustLiked containsObject:currentUserFBID]) {
            //This is saving OURSELF (the currentUser) to the user we just liked.
            PFQuery *newQuery = [PFQuery queryWithClassName:@"Relationship"];
            
            [newQuery whereKey:@"owner" equalTo:userWeJustLiked];
            [newQuery getFirstObjectInBackgroundWithBlock:^(PFObject *userRelationship, NSError *error) {
                if (!error) {
                    PFRelation *otherUserRelation = userRelationship[@"matchesMade"];
                    [otherUserRelation addObject:currentUser];
                    [userRelationship saveInBackground];
                } else{
                    NSLog(@"error");
                }
            }];
            //This is saving the person we just liked to OUR (currentUser) matchesMade relationship in parse
            PFQuery *queryForCurrentUser = [PFQuery queryWithClassName:@"Relationship"];
            [
             queryForCurrentUser whereKey:@"owner" equalTo:currentUser];
            [queryForCurrentUser getFirstObjectInBackgroundWithBlock:^(PFObject *userRelationship, NSError *error) {
                if (!error) {
                    PFRelation *relation = userRelationship[@"matchesMade"];
                    [relation addObject:userWeJustLiked];
                    [userRelationship saveInBackground];
                } else {
                    NSLog(@"error");
                }
                completionBlock(YES, nil);
            }];
        } else {
            completionBlock(NO,nil);
        }
    }];
}

//        UIImage *profilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userWeJustLiked[@"profile_photo"]]]];
//
//        NSString *name = userWeJustLiked[@"first_name"];

+ (void)updateMatchWithLocalUser:(User *)currentLocalUser
              withOtherParseUser:(PFUser *)otherUser
                  withCompletion:(void (^)(BOOL success))completionBlock {
    //
    //    PFUser *currentUser = [PFUser currentUser];
    //    PFUser *otherUserHere = otherUser;
    //    //    [otherUserHere[@"matches"] addObject:currentLocalUser.facebookID];
    //    [currentUser addObject:otherUserHere[@"facebookID"] forKey:@"matches"];
    //    [otherUserHere addObject:currentLocalUser.facebookID forKey:@"matches"];
    //
    //    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    //        if (!error) {
    //            // The currentUser saved successfully.
    //            completionBlock(YES);
    //        } else {
    //            // There was an error saving the currentUser.
    //            NSLog(@"error");
    //            completionBlock(NO);
    //        }
    //    }];
    //
    //    [otherUserHere saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    //        if (!error) {
    //            // The currentUser saved successfully.
    //            completionBlock(YES);
    //        } else {
    //            // There was an error saving the currentUser.
    //            NSLog(@"error");
    //            completionBlock(NO);
    //        }
    //    }];
}

+ (void)getMatchesFromParseWithCompletionBlock:(void (^)(BOOL success, NSArray *matches))completionBlock
{
    PFQuery *newQuery = [PFQuery queryWithClassName:@"Relationship"];
    
    [newQuery whereKey:@"owner" equalTo:[PFUser currentUser]];
    
    [newQuery getFirstObjectInBackgroundWithBlock:^(PFObject *userRelationship, NSError *error) {
        if (!error) {
            PFRelation *otherUserRelation = userRelationship[@"matchesMade"];
            NSLog(@"GETTING MATCHES %@",otherUserRelation);
            PFQuery *query = [otherUserRelation query];
            [query findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error){
                if (!error) {
                        completionBlock(YES,object);
                }
                else{
                    NSLog(@"error %@",error);
                }
            }];
        }
        else{
            completionBlock(NO,nil);
            NSLog(@"error");
        }
    }];
}



@end
