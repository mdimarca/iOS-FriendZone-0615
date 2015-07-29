//
//  MatchedUserViewController.m
//  Icebreaker
//
//  Created by Nicholas Ang on 7/29/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "MatchedUserViewController.h"

@interface MatchedUserViewController () <iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@property (nonatomic, strong) NSArray *userPictures;

@end

@implementation MatchedUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTitleView];
    
    //Populate userPictures Array
    self.userPictures = @[@1,@2,@3,@4,@5];
    
    self.iCarousel.type = iCarouselTypeLinear;
    
    self.iCarousel.delegate = self;
    self.iCarousel.dataSource = self;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpTitleView{
    
    UIView *navigationview = [[UIView alloc]initWithFrame:CGRectMake(-50, -25, 40, 40)];
    UIImageView *profilePictureView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PlaceHolder.jpg"]];
    profilePictureView.frame = CGRectMake(0, 0, 40, 40);
    
    [navigationview addSubview:profilePictureView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 20, 20)];
    nameLabel.text = @"hello";
    [navigationview addSubview:nameLabel];
    
    self.navigationBar.titleView = [[UIView alloc]init];
    [self.navigationBar.titleView addSubview:navigationview];
}

#pragma mark - iCarousel

-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 5;
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"PlaceHolder.jpg"];
        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [self.userPictures[index] stringValue];
    
    return view;

    
    return view;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
