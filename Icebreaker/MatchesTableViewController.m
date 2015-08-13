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

@interface MatchesTableViewController ()


@property (nonatomic, strong) DataStore *dataStore;
@property (nonatomic, strong) NSArray *matchesDemoData;

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
    self.dataStore = [DataStore sharedDataStore];
    
    NSLog(@"CHECK ACCEPTED %@",self.dataStore.user.acceptedProfiles);
    NSLog(@"CHECK REJECTED %@",self.dataStore.user.rejectedProfiles);
    
    User *match1 = [User createUserForMatchWithName:@"Joe" ProfilePhoto:[UIImage imageNamed:@"PlaceHolder"]];
    User *match2 = [User createUserForMatchWithName:@"Mary" ProfilePhoto:[UIImage imageNamed:@"clip"]];
    User *match3 = [User createUserForMatchWithName:@"Jackson" ProfilePhoto:[UIImage imageNamed:@"play"]];
    
    self.matchesDemoData = @[match1, match2, match3];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.matchesDemoData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MatchesTableViewCell *cell = (MatchesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    
    User *currentMatch = self.matchesDemoData[indexPath.row];
    
    cell.name.text = currentMatch.firstName;
    cell.userProfilePicture.image = currentMatch.profilePhoto;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"matchProfileSegue" sender:self];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
