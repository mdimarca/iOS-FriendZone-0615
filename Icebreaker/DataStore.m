//
//  DataStore.m
//  Icebreaker
//
//  Created by Gan Chau on 7/30/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "DataStore.h"
#import "User.h"

@implementation DataStore

+ (instancetype)sharedDataStore {
    static DataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedDataStore = [[DataStore alloc] init];
    });
    return _sharedDataStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _user = [[User alloc] init];
        _potentialMatchArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)fetchMatchesWithCompletionBlock:(void (^)(BOOL success))completion {
    
    [ParseAPICalls getPotentialMatchesWithCompletionBlock:^(NSArray *matches, BOOL success) {
        
        if (success) {
            self.potentialMatchArray = [matches mutableCopy];
            
            for (User *person in matches) {
                
                NSLog(@"====== INSIDE FETCH ==== Name: %@", person.firstName);
            }

            
            completion(YES);
        } else {
            
            completion(NO);
        }
}];
}

-(void)fetchCurrentUserData{
    
    PFUser *currentUser = [PFUser currentUser];
    
    NSString *currentUserURLString = currentUser[@"coverPhotoURLString"];
    UIImage *coverPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentUserURLString]]];
    
    self.user = [User newUserWithFirstName:currentUser[@"first_name"]
                                  lastName:currentUser[@"last_name"]
                                facebookID:currentUser[@"facebookID"]
                                    gender:currentUser[@"gender"]
                              profilePhoto:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentUser[@"profile_photo"]]]]
                                coverPhoto:coverPhoto
                                  pictures:[@[] mutableCopy]
                          aboutInformation:currentUser[@"aboutInformation"]
                                   matches:currentUser[@"matches"]
                                   friends:[@[] mutableCopy]
                                     likes:currentUser[@"likes"]
                          rejectedProfiles:currentUser[@"rejected_profiles"]
                          acceptedProfiles:currentUser[@"accepted_profiles"]];
    
    NSLog(@"%@ ACCEPTED PROFILES",self.user.acceptedProfiles);
    
}


@end
