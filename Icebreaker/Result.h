//
//  Result.h
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface Result : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *answerLabel;

@property (strong, nonatomic) NSString *answerOne;
@property (strong, nonatomic) NSString *answerTwo;
@property (strong, nonatomic) NSString *answerThree;

@property (strong, nonatomic) NSArray *questions;

@end
