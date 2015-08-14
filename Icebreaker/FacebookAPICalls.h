//
//  FacebookAPICalls.h
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "User.h"

@interface FacebookAPICalls : NSObject

+ (void)getUserInformationWithCompletion:(void (^)(User *user))completionBlock;

@end
