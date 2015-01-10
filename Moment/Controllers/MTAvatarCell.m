//
//  MTAvatarCell.m
//  Moment
//
//  Created by Jyh on 1/11/15.
//  Copyright (c) 2015 YH. All rights reserved.
//

#import "MTAvatarCell.h"

#define imageWidth 60

@implementation MTAvatarCell

- (void)awakeFromNib
{
    self.imageView.layer.cornerRadius = 5;
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
    CGFloat x = 15;
    self.imageView.frame = CGRectMake(x, y, imageWidth, imageWidth);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = CGRectGetMaxY(self.imageView.frame) + 15;
    self.textLabel.frame = tmpFrame;
}

@end
