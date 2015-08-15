//
//  Result.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "ResultViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>



@interface ResultViewController ()

@property (nonatomic, strong) NSMutableDictionary *myQuestionsAndAnswers;
@property (nonatomic, strong) NSMutableDictionary *matchedUsersQuestionsAndAnswers;

@property (nonatomic, strong) NSArray *arrayOfMyAnswers;
@property (nonatomic, strong) NSArray *arrayOfOtherUsersAnswers;
@property (nonatomic, strong) NSArray *arrayOfQuestions;

@property (nonatomic) BOOL brokenIce;


@end

@implementation ResultViewController

-(void) viewDidLoad
{
    self.brokenIce = NO;
    
    self.arrayOfMyAnswers = @[self.answerOneLabel,self.answerTwoLabel,self.answerThreeLabel];
    self.arrayOfOtherUsersAnswers= @[self.otherUserAnswerLblone,self.otherUserAnswerLabelTwo,self.otherUserAnwerLabelThree];
    self.arrayOfQuestions= @[self.questionOneLabel,self.questionTwoLabel,self.questionThreeLabel];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getQuestionsAndAnswersWithCompletion:^(BOOL success) {
        if (success) {
            [self setupUI];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkIfBrokenIce];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(checkIfBrokenIce) userInfo:nil repeats:YES];

    [timer fire];
}

-(void)checkIfBrokenIce
{
    [self checkAllQuestionsAreAnsweredWithCompletion:^(BOOL success) {
        if (success) {
            self.brokenIce = YES;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else{
            self.navigationItem.rightBarButtonItem.enabled = NO;
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
    if (self.brokenIce == YES) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
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
            [self checkAllQuestionsAreAnsweredWithCompletion:^(BOOL success) {
                if (success) {
                    //MAKE CHAT BUTTON ENABLE
                }
            }];
        }
        else{
            NSLog(@"ERROR %@",error);
        }
        
    }];
}

-(void)checkAllQuestionsAreAnsweredWithCompletion:(void (^)(BOOL success))completionBlock{
    
    PFUser *currentUser = [PFUser currentUser];
    NSMutableArray *iceBrokenArray = currentUser[@"ice_broken"];
    if (self.matchedUsersQuestionsAndAnswers.count == 3 && self.myQuestionsAndAnswers.count == 3) {
        //UPDDATE ICEBROKEN FOR MYSELF
        //Check if broken the ice before
        if (![iceBrokenArray containsObject:self.matchedUser[@"facebookID"]]) {
            //ADD broken the ice
            [iceBrokenArray addObject:self.matchedUser[@"facebookID"]];
            //SAVE THE ARRAY
            currentUser[@"ice_broken"] = iceBrokenArray;
            [currentUser saveInBackground];
            NSLog(@"ICEBROKEN USERS%@",iceBrokenArray);
        }
    }
    if ([iceBrokenArray containsObject:self.matchedUser[@"facebookID"]]) {
        completionBlock(YES);
    }
    else{
        completionBlock(NO);
    }
}
@end
