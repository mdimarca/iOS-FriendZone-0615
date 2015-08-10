//
//  ChoosePersonViewOurs.h
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 8/5/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "MDCSwipeToChooseView.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import <Parse/Parse.h>
#import "ParseAPICalls.h"
#import "DataStore.h"
#import "User.h"

@interface ChoosePersonViewOurs : MDCSwipeToChooseView

@property (strong, nonatomic, readonly) User *user;

-(instancetype)initWithFrame:(CGRect)frame
                        user:(User *)user
                     options:(MDCSwipeToChooseViewOptions *)options;

@end
