//
//  Result.h
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import <Parse/Parse.h>


@interface ResultViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *answerOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *answerTwoLabel;
@property (strong, nonatomic) IBOutlet UILabel *answerThreeLabel;

@property (weak, nonatomic) IBOutlet UILabel *otherUserAnswerLabelOne;

@property (weak, nonatomic) IBOutlet UILabel *otherUserAnswerLabelTwo;

@property (weak, nonatomic) IBOutlet UILabel *otherUserAnwerLabelThree;



@property (weak, nonatomic) IBOutlet UILabel *questionOneLabel;

@property (weak, nonatomic) IBOutlet UILabel *questionTwoLabel;

@property (weak, nonatomic) IBOutlet UILabel *questionThreeLabel;

@property (strong, nonatomic) NSString *answerOne;
@property (strong, nonatomic) NSString *answerTwo;
@property (strong, nonatomic) NSString *answerThree;

@property (nonatomic, strong) PFUser *matchedUser;


@end
