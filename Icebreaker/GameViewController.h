//
//  Game.h
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultViewController.h"

@interface GameViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UITextField *answerTextField;

- (IBAction)doneButtonTapped:(id)sender;

@end
