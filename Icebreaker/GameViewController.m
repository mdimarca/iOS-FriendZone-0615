//
//  Game.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "GameViewController.h"
#import <Parse.h>


@interface GameViewController ()

@property (nonatomic, strong) NSArray *arrayOfAnswers;
@property (nonatomic, strong) NSArray *questions;

@end



@implementation GameViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.arrayOfAnswers  = @[self.answerOneTextField, self.answerTwoTextField, self.answerThreeTextField];
    self.questions = @[@"Crunchy peanut butter or smooth?", @"What's your favorite island?",  @"How many countries have you visited?"];
}




- (IBAction)doneButtonTapped:(id)sender {
  
    [self doneButtonHelperwithCompletion:^(BOOL success) {
    }];
    
}

-(void)doneButtonHelperwithCompletion:(void (^)(BOOL success))completionBlock{
    
    NSMutableDictionary *questionsAndAnswers = [@{} mutableCopy];
    NSInteger trackNum =0;
    for (UITextField *answerTextField in self.arrayOfAnswers) {
        NSString *answer = answerTextField.text;
        if (!([answer isEqual:@"" ] && [answer isEqual:nil])) {
            [questionsAndAnswers setObject:answer forKey:self.questions[trackNum]];
        }
        trackNum++;
    }
    
    //SAVE CURRENT USER
    PFUser *user = [PFUser currentUser];
    user[@"q_a"] = @{self.matchedUser[@"facebookID"]:questionsAndAnswers},
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!error) {
            completionBlock(YES);
        } else {
            // There was an error saving the currentUser.
            NSLog(@"error");
            completionBlock(NO);
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ResultViewController *destinationVC = segue.destinationViewController;
    destinationVC.matchedUser = self.matchedUser;
}

@end
