//
//  Friend.m
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 7/29/15.
//  Copyright (c) 2015 ChickenBiscuit. All rights reserved.
//

#import "Friend.h"

@implementation Friend

-(instancetype)initWithFriendName:(NSString *)friendName friendProfilePicture:(UIImage *)friendProfilePicture {
    self = [super init];
    if (self) {
        _friendName = friendName;
        _friendProfilePicture = friendProfilePicture;
    }
    return self;
}

@end
