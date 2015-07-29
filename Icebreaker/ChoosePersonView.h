//
//  ChoosePersonView.h
//  Icebreaker
//
//  Created by Nicholas Ang on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "MDCSwipeToChooseView.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "PersonModel.h"


@interface ChoosePersonView : MDCSwipeToChooseView

@property (nonatomic, strong) PersonModel *person;



- (instancetype)initWithFrame:(CGRect)frame
                       person:(PersonModel *)person
                      options:(MDCSwipeToChooseViewOptions *)options;


@end
