//
//  ChoosePersonViewOurs.m
//  Icebreaker
//
//  Created by Josette DiMarcantonio on 8/5/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "ChoosePersonViewOurs.h"



@interface ChoosePersonViewOurs ()


@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *nameLabel;


@end

@implementation ChoosePersonViewOurs

-(instancetype)initWithFrame:(CGRect)frame
                        user:(User *)user
                     options:(MDCSwipeToChooseViewOptions *)options{
    self = [super initWithFrame:frame options:options];
    if (self) {
        _user = user;
        self.imageView.image = user.profilePhoto;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        [self constructInformationView];
    }
    return self;
}

-(void)constructInformationView {
    CGFloat bottomHeight = 60.f;
    CGRect bottomFrame = CGRectMake(0, CGRectGetHeight(self.bounds) - bottomHeight, CGRectGetWidth(self.bounds), bottomHeight);
    
    _informationView = [[UIView alloc]initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview: _informationView];
    
    [self constructNameLabel];
}

-(void)constructNameLabel {
    CGFloat leftPadding = 12.f;
    CGFloat topPadding = 17.f;
    CGRect frame = CGRectMake(leftPadding, topPadding, floorf(CGRectGetWidth(_informationView.frame)/2), CGRectGetHeight(_informationView.frame) - topPadding);
    
    _nameLabel = [[UILabel alloc] initWithFrame:frame];
    _nameLabel.text = [NSString stringWithFormat:@"%@", self.user.firstName];
    [_informationView addSubview:_nameLabel];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end