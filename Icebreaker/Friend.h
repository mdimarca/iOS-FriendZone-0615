//
//  Friend.h
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Friend : NSObject

@property (strong, nonatomic) NSString *friendName;
@property (strong, nonatomic) UIImage *friendProfilePicture;

-(instancetype)initWithFriendName:(NSString *)friendName friendProfilePicture:(UIImage *)friendProfilePicture;

@end
