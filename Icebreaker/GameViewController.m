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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    

}




- (IBAction)doneButtonTapped:(id)sender {
  
    [self doneButtonHelperwithCompletion:^(BOOL success) {
    }];
    
}

-(void)doneButtonHelperwithCompletion:(void (^)(BOOL success))completionBlock{
    
    NSString *answerOne = self.answerOneTextField.text;
    NSString *answerTwo = self.answerTwoTextField.text;
    NSString *answerThree = self.answerThreeTextField.text;

    //SAVE CURRENT USER
    PFUser *user = [PFUser currentUser];
    user[@"q_a"] = @{self.matchedUser[@"facebookID"]:@{@"Crunchy peanut butter or smooth?":answerOne,
                                                      @"What's your favorite island?":answerTwo,
                                                      @"How many countries have you visited?":answerThree}},
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
