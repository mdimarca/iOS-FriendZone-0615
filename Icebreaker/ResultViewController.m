//
//  Result.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "ResultViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "DataStore.h"


@interface ResultViewController ()

@property (nonatomic, strong) NSMutableDictionary *myQuestionsAndAnswers;
@property (nonatomic, strong) NSMutableDictionary *matchedUsersQuestionsAndAnswers;

@property (nonatomic, strong) NSArray *arrayOfMyAnswers;
@property (nonatomic, strong) NSArray *arrayOfOtherUsersAnswers;
@property (nonatomic, strong) NSArray *arrayOfQuestions;

@property (nonatomic) BOOL brokenIce;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *otherProfilePhoto;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *myProfilePhoto;
@property (strong, nonatomic) DataStore *dataStore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myPhoto1RightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myPhoto2RightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myPhoto3RightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherPhoto1LeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherPhoto2LeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherPhoto3LeftConstraint;

@end

@implementation ResultViewController

-(void) viewDidLoad
{
    self.view.clipsToBounds = YES;
    self.navigationItem.title = @"Answers";
    
    self.dataStore = [DataStore sharedDataStore];
    self.brokenIce = NO;
    
    self.arrayOfMyAnswers = @[self.answerOneLabel,self.answerTwoLabel,self.answerThreeLabel];
    self.arrayOfOtherUsersAnswers= @[self.otherUserAnswerLblone,self.otherUserAnswerLabelTwo,self.otherUserAnwerLabelThree];
    self.arrayOfQuestions= @[self.questionOneLabel,self.questionTwoLabel,self.questionThreeLabel];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getQuestionsAndAnswersWithCompletion:^(BOOL success) {
        if (success) {
            [self setupUI];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    [self animateViews];
    [self checkIfBrokenIce];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(checkIfBrokenIce) userInfo:nil repeats:YES];

    [timer fire];
}

- (void)animateViews
{
    [UIView animateKeyframesWithDuration:1.5
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0
                                                          relativeDuration:0.33
                                                                animations:^{
                                                                    self.questionOneLabel.alpha = 1;
                                                                    self.myPhoto1RightConstraint.constant = 0;
                                                                    self.otherPhoto1LeftConstraint.constant = 0;
                                                                    [self.view layoutIfNeeded];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.33
                                                          relativeDuration:0.34
                                                                animations:^{
                                                                    self.questionTwoLabel.alpha = 1;
                                                                    self.myPhoto2RightConstraint.constant = 0;
                                                                    self.otherPhoto2LeftConstraint.constant = 0;
                                                                    [self.view layoutIfNeeded];
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:.67
                                                          relativeDuration:0.33
                                                                animations:^{
                                                                    self.questionThreeLabel.alpha = 1;
                                                                    self.myPhoto3RightConstraint.constant = 0;
                                                                    self.otherPhoto3LeftConstraint.constant = 0;
                                                                    [self.view layoutIfNeeded];
                                                                }];
                              } completion:^(BOOL finished) {
                                  NSLog(@"Finished animating Questions");
                              }];
    
    
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
    
    UIImage *matchedPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.matchedUser[@"profile_photo"]]]];
    UIImage *myPhoto = self.dataStore.user.profilePhoto;
    
    for (UIImageView *otherImage in self.otherProfilePhoto) {
        otherImage.layer.cornerRadius = 25;
        otherImage.clipsToBounds = YES;
        otherImage.image = matchedPhoto;
        otherImage.hidden = NO;
    }

    for (UIImageView *myImage in self.myProfilePhoto) {
        myImage.layer.cornerRadius = 25;
        myImage.clipsToBounds = YES;
        myImage.image = myPhoto;
        myImage.hidden = NO;
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
