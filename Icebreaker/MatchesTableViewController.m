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
    
    User *match1 = [User newUserWithFirstName:@"Marshall"
                                     lastName:@"Walker"
                                   facebookID:@"125555"
                                       gender:@"male"
                                 profilePhoto:[UIImage imageNamed:@"liked_2x"]
                                   coverPhoto:nil
                                     pictures:[@[] mutableCopy]
                             aboutInformation:@"I have an insane collection of My Little Ponies. When I grow up, I want to be real pony trainer."
                                      matches:[@[] mutableCopy]
                                      friends:[@[] mutableCopy]
                                        likes:[@[@"chocolate", @"banana", @"hamburgers", @"the sky", @"churros", @"Facebook"] mutableCopy]
                             rejectedProfiles:[@[] mutableCopy]
                             acceptedProfiles:[@[] mutableCopy]];
    
    User *match2 = [User newUserWithFirstName:@"Julia"
                                     lastName:@"Washington"
                                   facebookID:@"120393"
                                       gender:@"female"
                                 profilePhoto:[UIImage imageNamed:@"nope_2x"]
                                   coverPhoto:nil
                                     pictures:[@[] mutableCopy]
                             aboutInformation:@"I am a professional ice cream taster and armpit sniffer. I own 43 turtles, and I have one puppy named Paul."
                                      matches:[@[] mutableCopy]
                                      friends:[@[] mutableCopy]
                                        likes:[@[@"Chipotle", @"NBA", @"Santa Claus", @"Smurfs", @"roses", @"hoses", @"noses", @"beer"] mutableCopy]
                             rejectedProfiles:[@[] mutableCopy]
                             acceptedProfiles:[@[] mutableCopy]];
    
    User *match3 = [User newUserWithFirstName:@"Miguel"
                                     lastName:@"Jaxson"
                                   facebookID:@"123456"
                                       gender:@"male"
                                 profilePhoto:[UIImage imageNamed:@"PlaceHolder"]
                                   coverPhoto:nil
                                     pictures:[@[] mutableCopy]
                             aboutInformation:@"I like to play football in the desert while wearing cowboy boots. I also love to read and play with my puppy, Jimmo."
                                      matches:[@[] mutableCopy]
                                      friends:[@[] mutableCopy]
                                        likes:[@[@"cowboys", @"cotton", @"vanilla", @"the moon", @"rocks", @"Game of Thrones"] mutableCopy]
                             rejectedProfiles:[@[] mutableCopy]
                             acceptedProfiles:[@[] mutableCopy]];
    
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
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@", currentMatch.firstName, currentMatch.lastName];
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
