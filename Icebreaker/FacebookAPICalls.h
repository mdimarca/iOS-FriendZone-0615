//
//  FacebookAPICalls.h
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBSDKProfilePictureView.h"
#import "FBSDKGraphRequest.h"

@interface FacebookAPICalls : NSObject

-(void)getUserInformationWithCompletion:(void (^)(NSString *name, NSNumber *age, NSMutableArray *pictures))completionBlock;

@end
