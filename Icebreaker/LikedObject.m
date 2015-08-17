//
//  LikedObject.m
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 7/29/15.
//  Copyright (c) 2015 ChickenBiscuit. All rights reserved.
//

#import "LikedObject.h"

@implementation LikedObject

-(instancetype)initWithName:(NSString *)likedObjectName likedObjectName:(UIImage *)image {
    self = [super init];
    if (self) {
        _likedObjectName = likedObjectName;
        _likedObjectImage = image;
    }
    return self;
}

@end
