//
//  MatchesTableViewController.m
//  Icebreaker
//
//  Created by Nicholas Ang on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "MatchesTableViewController.h"
#import "MatchesTableViewCell.h"
#import "DataStore.h"
#import "User.h"
#import "ParseAPICalls.h"
#import "MatchedUserViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MatchesTableViewController ()

@property (nonatomic, strong) DataStore *dataStore;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSArray *matches;

@end

@implementation MatchesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupData];
}

- (void)setupData
{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [ParseAPICalls getMatchesFromParseWithCompletionBlock:^(BOOL success, NSArray *matches) {
        if (success) {
            self.matches = matches;
            [self.tableView reloadData];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
                });
            });
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.matches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchesTableViewCell *cell = (MatchesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    PFUser *currentMatch = self.matches[indexPath.row];
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@", currentMatch[@"first_name"], currentMatch[@"last_name"]];
    UIImage *profilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentMatch[@"profile_photo"]]]];
    cell.userProfilePicture.image = profilePhoto;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.index = indexPath.row;
    [self performSegueWithIdentifier:@"matchProfileSegue" sender:self];
}



 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.

     MatchedUserViewController *destinationVC = segue.destinationViewController;
     destinationVC.matchedUser = self.matches[self.index];
 }


@end
