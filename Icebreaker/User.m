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
    self = [super init];
    if (self) {
        _firstName = @"";
        _lastName = @"";
        _facebookID = @"";
        _gender = @"";
        _profilePhoto = [UIImage new];
        _coverPhoto = [UIImage new];
        _pictures = [@[] mutableCopy];
        _aboutInformation = @"";
        _matches = [@[] mutableCopy];
        _friends = [@[] mutableCopy];
        _likes = [@[] mutableCopy];
        _rejectedProfiles = [@[] mutableCopy];
        _acceptedProfiles = [@[] mutableCopy];
    }
    return self;
}

+(User *)newUserWithFirstName:(NSString *)firstName
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
                rejectedProfiles:(NSMutableArray *)rejectedProfiles
                acceptedProfiles:(NSMutableArray *)acceptedProfiles
{
    User *newUser = [[User alloc]init];
        newUser.firstName = firstName;
        newUser.lastName= lastName;
        newUser.facebookID = facebookID;
        newUser.gender = gender;
        newUser.profilePhoto = profilePhoto;
        newUser.coverPhoto = coverPhoto;
        newUser.pictures = pictures;
        newUser.aboutInformation = aboutInformation;
        newUser.matches = matches;
        newUser.friends = friends;
        newUser.likes = likes;
        newUser.rejectedProfiles = rejectedProfiles;
        newUser.acceptedProfiles = acceptedProfiles;
    
    return newUser;
}

@end
