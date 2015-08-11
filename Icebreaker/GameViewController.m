//
//  Game.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "GameViewController.h"
#import <Parse.h>

@implementation GameViewController 


- (IBAction)doneButtonTapped:(id)sender {
  
    [self doneButtonHelperwithCompletion:^(BOOL success) {

    }];
    
//    NSArray *questions = @[@"Question One" @"Question Two" @"Question Three"];
//    self.questionLabel.text = questions[0];
    
}

- (IBAction)nextQuestionButtonTapped:(id)sender {
    
    self.questionTwoLabel.alpha = 1;
    self.answerTwoTextField.alpha = 1;
    
    
    if ((![self.answerTwoTextField.text isEqualToString:@""])) {
        self.questionThreeLabel.alpha = 1;
        self.answerThreeTextField.alpha = 1;
        
        self.nextQuestionButton.alpha = 0;
    }
}

-(void)doneButtonHelperwithCompletion:(void (^)(BOOL success))completionBlock{
    NSString *answer = self.answerOneTextField.text;
    
    PFUser *user = [PFUser currentUser];
    user[@"answer"] = @[answer];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!error) {
            completionBlock(YES);
        } else {
            // There was an error saving the currentUser.
            NSLog(@"error");
            completionBlock(NO);
        }
    }];
    
    ResultViewController *resultVC = [[ResultViewController alloc] init];
    resultVC.answerLabel.text = answer;
    
    NSLog (@"Answer: %@", answer);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        
    ResultViewController *destinationVC = segue.destinationViewController;
    destinationVC.answerOne = self.answerOneTextField.text;
}

-(void) viewDidLoad {
    
    self.questionTwoLabel.alpha = 0;
    self.questionThreeLabel.alpha = 0;
    
    self.answerTwoTextField.alpha = 0;
    self.answerThreeTextField.alpha = 0;

}
@end
