//
//  FacebookAPICalls.m
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "FacebookAPICalls.h"
#import "DataStore.h"

@interface FacebookAPICalls ()

@end

@implementation FacebookAPICalls

+ (void)getUserInformationWithCompletion:(void (^)(User *user))completionBlock {
    
    NSDictionary *params = @{ @"fields" : @"id, first_name, last_name, gender, picture.width(100).height(100)" };
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me" parameters:params];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"fetched user:%@", result);
            
            NSString *name = [NSString stringWithFormat:@"%@ %@", result[@"first_name"], result[@"last_name"]];
            NSString *facebookID = result[@"id"];
            NSString *gender = result[@"gender"];
            
            DataStore *dataManager = [DataStore sharedDataStore];
            
            dataManager.user.name = name;
            dataManager.user.facebookID = facebookID;
            dataManager.user.gender = gender;
            
            
            completionBlock(dataManager.user);
        }
    }];

}

@end
