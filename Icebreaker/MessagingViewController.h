//
//  MessagingViewController.h
//  Icebreaker
//
//  Created by Gan Chau on 8/6/15.
//  Copyright (c) 2015 ChickenBiscuit. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import <Parse/Parse.h>

@interface MessagingViewController : JSQMessagesViewController

@property (nonatomic, strong) NSString *chatNumber;
@property (nonatomic, strong) UIImage *matchedUserImage;
@property (nonatomic, strong) NSString *matchedUserID;
@property (nonatomic, strong) NSString *matchedUserName;

@end
