//
//  MatchesTableViewCell.m
//  Icebreaker
//
//  Created by Nicholas Ang on 7/29/15.
//  Copyright (c) 2015 ChickenBiscuit. All rights reserved.
//

#import "MatchesTableViewCell.h"

@implementation MatchesTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.userProfilePicture.layer.cornerRadius = 25;
    self.userProfilePicture.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
