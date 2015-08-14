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
    

//    User *match1 = [User newUserWithFirstName:@"Marshall"
//                                     lastName:@"Walker"
//                                   facebookID:@"125555"
//                                       gender:@"male"
//                                 profilePhoto:[UIImage imageNamed:@"liked_2x"]
//                                   coverPhoto:nil
//                                     pictures:[@[] mutableCopy]
//                             aboutInformation:@"I have an insane collection of My Little Ponies. When I grow up, I want to be real pony trainer."
//                                      matches:[@[] mutableCopy]
//                                      friends:[@[] mutableCopy]
//                                        likes:[@[@"chocolate", @"banana", @"hamburgers", @"the sky", @"churros", @"Facebook"] mutableCopy]
//                             rejectedProfiles:[@[] mutableCopy]
//                             acceptedProfiles:[@[] mutableCopy]];
//    
//    User *match2 = [User newUserWithFirstName:@"Julia"
//                                     lastName:@"Washington"
//                                   facebookID:@"120393"
//                                       gender:@"female"
//                                 profilePhoto:[UIImage imageNamed:@"nope_2x"]
//                                   coverPhoto:nil
//                                     pictures:[@[] mutableCopy]
//                             aboutInformation:@"I am a professional ice cream taster and armpit sniffer. I own 43 turtles, and I have one puppy named Paul."
//                                      matches:[@[] mutableCopy]
//                                      friends:[@[] mutableCopy]
//                                        likes:[@[@"Chipotle", @"NBA", @"Santa Claus", @"Smurfs", @"roses", @"hoses", @"noses", @"beer"] mutableCopy]
//                             rejectedProfiles:[@[] mutableCopy]
//                             acceptedProfiles:[@[] mutableCopy]];
//    
//    User *match3 = [User newUserWithFirstName:@"Miguel"
//                                     lastName:@"Jaxson"
//                                   facebookID:@"123456"
//                                       gender:@"male"
//                                 profilePhoto:[UIImage imageNamed:@"PlaceHolder"]
//                                   coverPhoto:nil
//                                     pictures:[@[] mutableCopy]
//                             aboutInformation:@"I like to play football in the desert while wearing cowboy boots. I also love to read and play with my puppy, Jimmo."
//                                      matches:[@[] mutableCopy]
//                                      friends:[@[] mutableCopy]
//                                        likes:[@[@"cowboys", @"cotton", @"vanilla", @"the moon", @"rocks", @"Game of Thrones"] mutableCopy]
//                             rejectedProfiles:[@[] mutableCopy]
//                             acceptedProfiles:[@[] mutableCopy]];
//    
//    self.dataStore.user.matches = [@[match1, match2, match3] mutableCopy];
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
