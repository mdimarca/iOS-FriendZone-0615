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
    DataStore *dataManager = [DataStore sharedDataStore];
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *userQuery = [PFUser query];
    
    NSLog(@"FACEBOOK ID OF SWIPE %@",facebookID);
    
    [userQuery whereKey:@"facebookID" equalTo:facebookID];
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *object, NSError *error)
     {
         if (object != nil) {
             PFUser *user = (PFUser *)object[0];
             
             NSLog(@"SWIPED USERNAME %@",user[@"first_name"]);
             
             NSMutableArray *otherUserAcceptedProfiles= [user[@"accepted_profiles"] mutableCopy];
             
            NSLog(@"%@ SWIPED USERS ACCEPTED USRS PROFILES",otherUserAcceptedProfiles);
             
                NSLog(@"%@ MY FACEBOOK ID",dataManager.user.facebookID);
             
             if ([otherUserAcceptedProfiles containsObject:dataManager.user.facebookID]) {
                 
                   NSLog(@"%@ OTHER USRS PROFILES",otherUserAcceptedProfiles);
              
                 
                 //being here means you're a match!!!
                 
                 //             otherUser = user;
                 
                 //Check if the users property matches
                 
                 //convert pfuser to a local instance
                 NSString *profilephotoURLString = user[@"profilePhoto"];
                 UIImage *profilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profilephotoURLString]]];
                 UIImage *coverPhotograph = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user[@"coverPhotoURLString"]]]];
                 
                 User *matchUser = [User newUserWithFirstName:user[@"first_name"]
                                                     lastName: user[@"last_name"]
                                                   facebookID:user[@"facebookID"]
                                                       gender:user[@"gender"]
                                                 profilePhoto:profilePhoto
                                                   coverPhoto:coverPhotograph
                                                     pictures:[@[] mutableCopy]
                                             aboutInformation:user[@"aboutInformation"]
                                                      matches:user[@"matches"]
                                                      friends:[@[] mutableCopy]
                                                        likes:user[@"likes"]
                                             rejectedProfiles:user[@"rejected_profiles"]
                                             acceptedProfiles:user[@"accepted_profiles"]];
                 
                 [dataManager.user.matches addObject:matchUser];
                 
                 completionBlock(YES,matchUser);
                 
             } else {
                 //not a match.
                 completionBlock(NO, nil);
             }
         } else {
             completionBlock(NO,nil);
         }
     }];
    
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The currentUser saved successfully.
            NSLog(@"all good");
        } else {
            // There was an error saving the currentUser.
            NSLog(@"error");
            
        }
    }];
    
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


@end
