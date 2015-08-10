//
//  Result.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/10/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "Result.h"

@implementation Result

-(void) viewDidLoad {
    
//    Game *gameVC = [[Game alloc]init];
    
    self.answerLabel.text = self.answerOne;
    
    self.questions = @[@"Question One" @"Question Two" @"Question Three"];
    
    NSArray *germanMakes = @[@"Mercedes-Benz", @"BMW", @"Porsche",
                             @"Opel", @"Volkswagen", @"Audi"];
}


@end
