//
//  ViewController.h
//  Icebreaker
//
//  Created by Omar El-Fanek on 7/28/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface ChatViewController : UIViewController 

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *chat;
@property (nonatomic, strong) Firebase *firebase;


@property (strong, nonatomic) IBOutlet UIButton *nameField;
@property (strong, nonatomic) IBOutlet UITextField *field;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

