//
//  PersionInfoAvatarCell.m
//  Moment
//
//  Created by Jyh on 1/11/15.
//  Copyright (c) 2015 YH. All rights reserved.
//

#import "PersionInfoAvatarCell.h"

#define imageWidth 60

@implementation PersionInfoAvatarCell

- (void)awakeFromNib
{
    self.imageView.layer.cornerRadius = 8;
    self.imageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat y = (self.bounds.size.height - imageWidth) / 2;
    CGFloat x = IOS7_OR_LATER? 220:228 ;
    self.imageView.frame = CGRectMake(x, y, imageWidth, imageWidth);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 15;
    self.textLabel.frame = tmpFrame;
}


@end
