//
//  User.m
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initWith:(NSString *)name gender:(NSString *)gender age:(NSNumber *)age pictures:(NSMutableArray *)pictures aboutInformation:(NSString *)aboutInformation matches:(NSMutableArray *)matches friends:(NSMutableArray *)friends likes:(NSMutableArray *)likes {
    self = [super init];
    if (self) {
        _name = name;
        _gender = gender;
        _age = age;
        _pictures = pictures;
        _aboutInformation = aboutInformation;
        _matches = matches;
        _friends = friends;
        _likes = likes;
    }
    return self;
}

@end
