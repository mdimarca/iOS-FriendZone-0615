//
//  MatchedUserViewController.h
//  Icebreaker
//
//  Created by Nicholas Ang on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <Parse/Parse.h>

@interface MatchedUserViewController : UIViewController

@property (strong, nonatomic) PFUser *matchedUser;

@end
