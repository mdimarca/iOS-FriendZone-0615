//
//  ChoosePersonView.m
//  Icebreaker
//
//  Created by Nicholas Ang on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "ChoosePersonView.h"

@implementation ChoosePersonView


- (instancetype)initWithFrame:(CGRect)frame
                       person:(PersonModel *)person
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        self.person = person;
        self.imageView.image = self.person.profilePicture;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        
    }
    return self;
}


@end
