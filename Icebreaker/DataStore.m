//
//  DataStore.m
//  Icebreaker
//
//  Created by Gan Chau on 7/30/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "DataStore.h"

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
        _user = [[User alloc] initWithName:@""
                                facebookID:@""
                                    gender:@""
                                  pictures:[@[] mutableCopy]
                          aboutInformation:@""
                                   matches:[@[] mutableCopy]
                                   friends:[@[] mutableCopy]
                                     likes:[@[] mutableCopy]];
    }
    return self;
}

@end
