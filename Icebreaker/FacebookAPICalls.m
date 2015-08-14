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
    
    NSDictionary *params = @{ @"fields" : @"id, first_name, last_name, gender, picture.width(400).height(400), cover, bio, likes" };
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me" parameters:params];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"fetched user:%@", result);
            
            NSString *firstName = result[@"first_name"];
            NSString *lastName = result[@"last_name"];
            NSString *facebookID = result[@"id"];
            NSString *gender = result[@"gender"];
            NSString *aboutInformation = result[@"bio"];
            
            NSURL *coverURL = [NSURL URLWithString:result[@"cover"][@"source"]];
            NSData *coverData = [NSData dataWithContentsOfURL:coverURL];
            UIImage *coverPhoto = [UIImage imageWithData:coverData];
            
            DataStore *dataManager = [DataStore sharedDataStore];
            
            dataManager.user.firstName = firstName;
            dataManager.user.lastName = lastName;
            dataManager.user.facebookID = facebookID;
            dataManager.user.gender = gender;
            dataManager.user.coverPhoto = coverPhoto;
            dataManager.user.aboutInformation= aboutInformation;
            
            
            completionBlock(dataManager.user);
        }
    }];
}

@end
