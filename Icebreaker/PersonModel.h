//
//  PersonModel.h
//  Icebreaker
//
//  Created by Nicholas Ang on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

@interface PersonModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *profilePicture;


@property (nonatomic, strong) NSMutableArray *personMatches;



@end
