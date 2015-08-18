//
//  userProfileViewController.m
//  Icebreaker
//
//  Created by Gan Chau on 7/29/15.
//  Copyright (c) 2015 ChickenBiscuit. All rights reserved.
//

#import "UserProfileViewController.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import "DataStore.h"
#import "LikesViewController.h"
#import "LikesCollectionViewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface UserProfileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverPhotoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (weak, nonatomic) IBOutlet UICollectionView *likesCollectionView;

@property (nonatomic, strong) NSMutableDictionary *likesDictionary;
@property (nonatomic, strong) NSMutableArray *pageLikesText;
@property (nonatomic, strong) NSMutableArray *pictures;

@property (nonatomic, strong) DataStore *dataStore;

@end

static NSString * const reuseIdentifier = @"likesView";

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  
    [self setUpCoverPhotoBlurView];
    self.pictures = [[NSMutableArray alloc]init];
    self.pageLikesText = [[NSMutableArray alloc]init];
    
    self.likesCollectionView.delegate = self;
    self.likesCollectionView.dataSource = self;
    
    self.logOutButton.layer.cornerRadius = 2.0;
    self.logOutButton.clipsToBounds = YES;
    
    self.dataStore = [DataStore sharedDataStore];
    
//    self.pageLikesText = self.dataStore.user.likes;
    [self.likesCollectionView setShowsHorizontalScrollIndicator:NO];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setItemSize:CGSizeMake(100.0, 124.0)];
    [self.likesCollectionView setCollectionViewLayout:flowLayout];

    self.likesCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self updateData];
    [self.likesCollectionView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)setUpCoverPhotoBlurView{
   
    UIView *alphaView = [[UIView alloc]initWithFrame:self.coverPhotoImageView.bounds];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.4;
    [self.coverPhotoImageView addSubview:alphaView];
    
}

- (void)updateData
{
    
    self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.dataStore.user.firstName, self.dataStore.user.lastName];
    self.coverPhotoImageView.image = self.dataStore.user.coverPhoto;
    self.coverPhotoImageView.clipsToBounds = YES;
    self.coverPhotoImageView.layer.masksToBounds = YES;
    
    self.profilePhotoImageView.image = self.dataStore.user.profilePhoto;
    self.profilePhotoImageView.layer.cornerRadius = 50;
    self.profilePhotoImageView.layer.borderWidth = 2;
    self.profilePhotoImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.profilePhotoImageView.clipsToBounds = YES;
    
    self.aboutLabel.text = [NSString stringWithFormat:@"About %@", self.dataStore.user.firstName];
    self.aboutTextView.text = self.dataStore.user.aboutInformation;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getLikesCoverPhotoFromParseWithCompletionBlock:^(BOOL success) {
        if (success) {
              [self.likesCollectionView reloadData];
        }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

  
}

-(void)getLikesCoverPhotoFromParseWithCompletionBlock:(void (^)(BOOL success))completionBlock{
    PFUser *user = [PFUser currentUser];
    self.likesDictionary = user[@"likes"];
    if (self.likesDictionary.count > 0) {
        for (NSString *like in self.likesDictionary){
            UIImage *profilePhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.likesDictionary[like]]]];
            [self.pictures addObject:profilePhoto];
            [self.pageLikesText addObject:like];
        }
        completionBlock(YES);
    }
    else{
        completionBlock(NO);
    }
}


- (IBAction)logOutButtonTapped:(id)sender
{
    [PFUser logOut];
    
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"User logged out");
    }];
}

- (IBAction)closeButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissing profile view controller");
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.likesDictionary count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    LikesCollectionViewCell *likesViewCell = (LikesCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"likesView" forIndexPath:indexPath];
//    NSLog(@"%@ TEXT",self.pargeLikesText[indexPath.row]);
    likesViewCell.likeText.text = self.pageLikesText[indexPath.row];
    likesViewCell.pageLikeImage.image = self.pictures[indexPath.row];
    likesViewCell.pageLikeImage.layer.cornerRadius = likesViewCell.pageLikeImage.frame.size.width / 2;
    likesViewCell.pageLikeImage.layer.masksToBounds = YES;
    likesViewCell.pageLikeImage.layer.borderWidth = 2.0;
    likesViewCell.pageLikeImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [UIView animateWithDuration:0.6 animations:^{
        likesViewCell.pageLikeImage.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];

  
    
    // Configure the cell
    
    return likesViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGPoint scrollVelocity = [self.likesCollectionView.panGestureRecognizer velocityInView:self.likesCollectionView.superview];
    
    LikesCollectionViewCell *likesViewCell =(LikesCollectionViewCell *)cell;
    [UIView animateWithDuration:0.6 animations:^{
        likesViewCell.pageLikeImage.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
    

    if (scrollVelocity.y > 0.0f){
       
    
    
        NSLog(@"going down");
    }
    else if (scrollVelocity.y < 0.0f)
        NSLog(@"going up");
    
}


#pragma mark <UICollectionViewDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10; // This is the minimum inter item spacing, can be more
}



- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    
    UICollectionViewLayoutAttributes *attributes = [self initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    [UIView animateWithDuration:0.25 animations:^{
        attributes.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
      return attributes;
    
}

- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    
     UICollectionViewLayoutAttributes *attributes = [self finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    [UIView animateWithDuration:0.25 animations:^{
        attributes.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
    return attributes;
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(10, -10, 10, 10);
//}

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*r
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */





@end
