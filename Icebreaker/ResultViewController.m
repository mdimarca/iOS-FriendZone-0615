//
//  Result.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "ResultViewController.h"

@implementation ResultViewController

-(void) viewDidLoad
{
    [self setupUI];
}

- (void)setupUI
{
    self.answerOneLabel.text = self.answerOne;
    self.answerTwoLabel.text = self.answerTwo;
    self.answerThreeLabel.text = self.answerThree;
    
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

@end
