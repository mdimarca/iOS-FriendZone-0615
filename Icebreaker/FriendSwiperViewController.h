//
//  friendSwiperViewController.h
//  Icebreaker
//
//  Created by Gan Chau on 7/28/15.
//  Copyright (c) 2015 ChickenBiscuit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosePersonViewOurs.h"
#import "User.h"

@interface FriendSwiperViewController : UIViewController

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) ChoosePersonViewOurs *frontCardView;
@property (strong, nonatomic) ChoosePersonViewOurs *backCardView;

@end
