//
//  FacebookAPICalls.m
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "FacebookAPICalls.h"

@implementation FacebookAPICalls

//-(void)getUserInformationWithCompletion:(void (^)(NSString *name, NSNumber *age, NSMutableArray *pictures))completionBlock {
//
//    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,picture.width(100).height(100)"}]
//     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//         if (!error) {
//             NSLog(@"%@",result);
//             
//             //name
//             NSString *name = result[@"name"];
//             
//             //profile picture stuff
//             NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
//             NSData  *data = [NSData dataWithContentsOfURL:url];
//
//             //age
//             
//         }
//     }];
//
//}

@end
