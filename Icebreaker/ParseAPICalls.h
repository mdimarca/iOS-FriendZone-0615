//
//  ParseAPICalls.h
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 8/5/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User.h"

@interface ParseAPICalls : NSObject

//+(NSArray *)getPotentialMatches;

+ (void)getPotentialMatchesWithCompletionBlock:(void (^)(NSArray *matches, BOOL success))completionBlock;

+ (void)updateParsePotentialMatchesWithFacebookID:(NSString *)facebookID
                                     withAccepted:(BOOL)accepted
                                   withCompletion:(void (^)(BOOL success))completionBlock;

+ (void)isSwipeAMatch:(NSString *)facebookID
       withCompletion:(void (^)(BOOL success, User *matchedUser))completionBlock;

+ (void)updateMatchWithLocalUser:(User *)currentLocalUser
              withOtherParseUser:(PFUser *)otherUser
                  withCompletion:(void (^)(BOOL success))completionBlock;

+ (void)getMatchesFromParseWithCompletionBlock:(void (^)(BOOL success, NSArray *matches))completionBlock;



@end
