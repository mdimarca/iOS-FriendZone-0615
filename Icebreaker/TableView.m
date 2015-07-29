//
//  TableView.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "TableView.h"

@implementation TableView


-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        // Initialize
    }
    return self;
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nextResponder touchesBegan:touches withEvent:event];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
