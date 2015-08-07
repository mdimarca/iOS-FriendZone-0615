//
//  User.h
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) UIImage *profilePhoto;
@property (strong, nonatomic) UIImage *coverPhoto;
@property (strong, nonatomic) NSMutableArray *pictures;
@property (strong, nonatomic) NSString *aboutInformation;
@property (strong, nonatomic) NSMutableArray *matches;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *likes;
@property (nonatomic, strong) NSMutableArray *rejectedProfiles;
@property (nonatomic, strong) NSMutableArray *acceptedProfiles;

//@property (strong, nonatomic) JSQMessages *messages;

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
             acceptedProfiles:(NSMutableArray *)acceptedProfiles;

@end
