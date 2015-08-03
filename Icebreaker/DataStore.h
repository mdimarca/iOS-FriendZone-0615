//
//  DataStore.h
//  Icebreaker
//
//  Created by Gan Chau on 7/30/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface DataStore : NSObject

@property (strong, nonatomic) User *user;

+(instancetype)sharedDataStore;

@end