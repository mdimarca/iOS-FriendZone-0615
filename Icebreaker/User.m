//
//  User.m
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)init
{
    return [self initWithFirstName:@""
                          lastName:@""
                        facebookID:@""
                            gender:@""
                      profilePhoto:nil
                        coverPhoto:nil
                          pictures:[@[] mutableCopy]
                  aboutInformation:@""
                           matches:[@[] mutableCopy]
                           friends:[@[] mutableCopy]
                             likes:[@[] mutableCopy]];
}

-(instancetype)initWithFirstName:(NSString *)firstName
                        lastName:(NSString *)lastName
                      facebookID:(NSString *)facebookID
                          gender:(NSString *)gender
                    profilePhoto:(UIImage *)profilePhoto
                      coverPhoto:(UIImage *)coverPhoto
                        pictures:(NSMutableArray *)pictures
                aboutInformation:(NSString *)aboutInformation
                         matches:(NSMutableArray *)matches
                         friends:(NSMutableArray *)friends
                           likes:(NSMutableArray *)likes
{
    self = [super init];
    
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
        _facebookID = facebookID;
        _gender = gender;
        _profilePhoto = profilePhoto;
        _coverPhoto = coverPhoto;
        _pictures = pictures;
        _aboutInformation = aboutInformation;
        _matches = matches;
        _friends = friends;
        _likes = likes;
    }
    
    return self;
}

@end
