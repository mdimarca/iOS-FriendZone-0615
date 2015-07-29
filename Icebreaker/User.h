//
//  User.h
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSMutableArray *pictures;
@property (strong, nonatomic) NSString *aboutInformation;
@property (strong, nonatomic) NSMutableArray *matches;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *likes;

//@property (strong, nonatomic) JSQMessages *messages;

@end