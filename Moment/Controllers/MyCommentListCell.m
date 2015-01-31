//
//  MyCommentListCell.m
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MyCommentListCell.h"

@implementation MyCommentListCell

- (void)awakeFromNib {
    // Initialization code
    
    self.avatarImage.layer.cornerRadius = CGRectGetWidth(self.avatarImage.frame)/2;
    self.avatarImage.layer.masksToBounds = YES;
    
    self.storyBGView.layer.cornerRadius = 5;
    self.storyBGView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
