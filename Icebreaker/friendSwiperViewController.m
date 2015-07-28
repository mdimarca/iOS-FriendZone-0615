//
//  friendSwiperViewController.m
//  Icebreaker
//
//  Created by Gan Chau on 7/28/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "friendSwiperViewController.h"
#import "FBSDKProfilePictureView.h"
#import "FBSDKGraphRequest.h"

@interface friendSwiperViewController ()

@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *FBProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *FBUsername;

@end

@implementation friendSwiperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.FBProfileImageView.layer.cornerRadius = 125;
    self.FBProfileImageView.clipsToBounds = YES;
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"%@",result);
             self.FBUsername.text = result[@"name"];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
