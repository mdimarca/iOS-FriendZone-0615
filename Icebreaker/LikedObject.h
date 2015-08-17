//
//  LikedObject.h
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 7/29/15.
//  Copyright (c) 2015 ChickenBiscuit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LikedObject : NSObject

@property (strong, nonatomic) NSString *likedObjectName;
@property (strong, nonatomic) UIImage *likedObjectImage;

-(instancetype)initWithName:(NSString *)likedObjectName likedObjectName:(UIImage *)image;

@end
