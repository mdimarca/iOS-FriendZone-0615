//
//  Game.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "Game.h"

@implementation Game


- (IBAction)doneButtonTapped:(id)sender {
    
    NSString *answer = self.answerTextField.text;
    
    Result *resultVC = [[Result alloc] init];
    resultVC.answerLabel.text = answer;
    
    NSLog (@"Answer: %@", answer);
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Result *destinationVC = segue.destinationViewController;
    destinationVC.answerOne = self.answerTextField.text;
}

-(void) viewDidLoad {
    


}
@end
