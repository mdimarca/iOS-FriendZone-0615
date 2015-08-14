//
//  Result.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "ResultViewController.h"



@interface ResultViewController ()

@property (nonatomic, strong) NSDictionary *myQuestionsAndAnswers;
@property (nonatomic, strong) NSDictionary *matchedUsersQuestionsAndAnswers;

@property (nonatomic, strong) NSArray *arrayOfMyAnswers;
@property (nonatomic, strong) NSArray *arrayOfOtherUsersAnswers;
@property (nonatomic, strong) NSArray *arrayOfQuestions;



@end

@implementation ResultViewController

-(void) viewDidLoad
{
    self.arrayOfMyAnswers = @[self.answerOneLabel,self.answerTwoLabel,self.answerThreeLabel];
    self.arrayOfOtherUsersAnswers= @[self.otherUserAnswerLblone,self.otherUserAnswerLabelTwo,self.otherUserAnwerLabelThree];
    self.arrayOfQuestions= @[self.questionOneLabel,self.questionTwoLabel,self.questionThreeLabel];

    [self getQuestionsAndAnswersWithCompletion:^(BOOL success) {
        if (success) {
              [self setupUI];
        }
    }];

}

- (void)setupUI
{

    NSInteger trackNum = 0;
    for (NSString *key in self.myQuestionsAndAnswers) {
        UILabel *labelQuestion = self.arrayOfQuestions[trackNum];
        labelQuestion.text = key;
        UILabel *labelAnswer = self.arrayOfMyAnswers[trackNum];
        labelAnswer.text = self.myQuestionsAndAnswers[key];
        trackNum ++;
    }
    trackNum = 0;
    for (NSString *key in self.matchedUsersQuestionsAndAnswers) {
        UILabel *labelQuestion = self.arrayOfOtherUsersAnswers[trackNum];
        labelQuestion.text = self.matchedUsersQuestionsAndAnswers[key];
        trackNum++;
    }
  
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Chat"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(chatPressed)];
    self.navigationItem.rightBarButtonItem = button;
}

- (void)chatPressed {
    
    NSLog(@"Chat was pressed!");
    [self performSegueWithIdentifier:@"@Chat" sender:self];
}

-(void)getQuestionsAndAnswersWithCompletion:(void (^)(BOOL success))completionBlock{
    
    //GET QUESTIONS FROM OTHER USER & OUR QUESTIONS
    PFQuery *query = [PFUser query];
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:@"facebookID" equalTo:self.matchedUser[@"facebookID"]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *userHere, NSError *error) {
        if (!error) {
            PFUser *matchedUser = (PFUser *)userHere;
            self.matchedUsersQuestionsAndAnswers = matchedUser[@"q_a"][currentUser[@"facebookID"]];
            self.myQuestionsAndAnswers = currentUser[@"q_a"][self.matchedUser[@"facebookID"]];
            completionBlock(YES);
        }
        else{
            NSLog(@"ERROR %@",error);
        }
        
    }];

    
}
    

    
@end
