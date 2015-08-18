//
//  Game.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscuit. All rights reserved.
//

#import "GameViewController.h"
#import <Parse.h>


@interface GameViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSArray *arrayOfAnswers;
@property (nonatomic, strong) NSArray *questions;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneButtonTopConstraint;

@end

@implementation GameViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    [self setupData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setupUI
{
    self.navigationItem.title = @"Questions";
    
    self.answerOneTextField.delegate = self;
    self.answerTwoTextField.delegate = self;
    self.answerThreeTextField.delegate = self;
    
    self.doneButton.enabled = NO;
    self.doneButton.layer.cornerRadius = 4;
    self.doneButton.alpha = 0;
    self.doneButtonTopConstraint.constant = 400;
    
    [self enableDoneButton];
}

- (void)setupData
{
    self.arrayOfAnswers  = @[self.answerOneTextField, self.answerTwoTextField, self.answerThreeTextField];
    self.questions = @[@"Crunchy peanut butter or smooth?", @"What's your favorite island?",  @"How many countries have you visited?"];
    if (self.isIceBroken) {
        [self performSegueWithIdentifier:@"resultViewSegue" sender:self];
    }
}

#pragma marks UITextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.answerOneTextField]) {
        [self.answerTwoTextField becomeFirstResponder];
    } else if ([textField isEqual:self.answerTwoTextField]) {
        [self.answerThreeTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (IBAction)answer1TextFieldEditingChanged:(id)sender
{
    [self enableDoneButton];
}

- (IBAction)answer2TextFieldEditingChanged:(id)sender
{
    [self enableDoneButton];
}

- (IBAction)answer3TextFieldEditingChanged:(id)sender
{
    [self enableDoneButton];
}

- (void)enableDoneButton
{
    if (self.answerOneTextField.text.length > 0 &&
        self.answerTwoTextField.text.length > 0 &&
        self.answerThreeTextField.text.length > 0) {
        self.doneButton.enabled = YES;
        
        [UIView animateKeyframesWithDuration:0.6
                                       delay:0
                                     options:UIViewKeyframeAnimationOptionCalculationModeLinear
                                  animations:^{
                                      [UIView addKeyframeWithRelativeStartTime:0
                                                              relativeDuration:0.1
                                                                    animations:^{
                                                                        self.doneButton.alpha = 1;
                                                                        [self.view layoutIfNeeded];
                                                                    }];
                                      [UIView addKeyframeWithRelativeStartTime:0.1
                                                              relativeDuration:0.9
                                                                    animations:^{
                                                                        self.doneButtonTopConstraint.constant = 30;
                                                                        [self.view layoutIfNeeded];
                                                                    }];
                                  } completion:^(BOOL finished) {
                                      NSLog(@"Finished animating done button");
                                  }];
    } else {
        
        self.doneButton.enabled = NO;
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.doneButton.alpha = 0;
                         }];
    }
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
        if (!([answer isEqual:@"" ] || [answer isEqual:nil])) {
            [questionsAndAnswers setObject:answer forKey:self.questions[trackNum]];
        }
        trackNum++;
    }
    
    //SAVE CURRENT USER
    PFUser *user = [PFUser currentUser];
    user[@"q_a"] = @{self.matchedUser[@"facebookID"] : questionsAndAnswers},
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
