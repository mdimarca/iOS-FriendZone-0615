//
//  LinkedStoryboardSegue.h
//  Icebreaker
//
//  Created by Gan Chau on 7/29/15.
//  Copyright (c) 2015 ChickenBiscuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkedStoryboardSegue : UIStoryboardSegue

+ (UIViewController *)sceneNamed:(NSString *)identifier;

@end

