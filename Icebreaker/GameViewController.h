//
//  Game.h
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultViewController.h"
#import <Parse/Parse.h>

@interface GameViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *questionOneLabel;
@property (strong, nonatomic) IBOutlet UITextField *answerOneTextField;

@property (strong, nonatomic) IBOutlet UILabel *questionTwoLabel;
@property (strong, nonatomic) IBOutlet UITextField *answerTwoTextField;

@property (strong, nonatomic) IBOutlet UILabel *questionThreeLabel;
@property (strong, nonatomic) IBOutlet UITextField *answerThreeTextField;
@property (strong, nonatomic) IBOutlet UIButton *nextQuestionButton;

- (IBAction)doneButtonTapped:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *peanutImage;
@property (strong, nonatomic) IBOutlet UIImageView *islandImage;
@property (strong, nonatomic) IBOutlet UIImageView *cityImage;

@property (nonatomic, strong) PFUser *matchedUser;

@end
