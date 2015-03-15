//
//  FindMomentCell.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "FindMomentCell.h"
#import "MomentDetail.h"


@implementation FindMomentCell

- (void)awakeFromNib {
    // Initialization code
    self.avtarImage.layer.cornerRadius = 5;
    self.avtarImage.layer.masksToBounds = YES;
    
    self.reportBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.reportBtn.layer.borderWidth = 0.5;
    self.reportBtn.layer.cornerRadius = 5;
    self.reportBtn.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateMomentCellWithInfo:(MomentDetail *)detail
{
    if (!FBIsEmpty(detail)) {
        
        if (!FBIsEmpty(detail.avatar)) {
            [self.avtarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,detail.avatar]] placeholderImage:[UIImage imageNamed:@"Oval 7 + Oval 11"]];
            self.avtarImage.layer.cornerRadius = 17;
            self.avtarImage.layer.masksToBounds = YES;
        }
        if (!FBIsEmpty(detail.litpic)) {
            [self.coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,detail.litpic]] placeholderImage:nil];
        }
        
        self.titleLabel.text = detail.title;
        self.contentLabel.text = detail.content;
        self.recommendNmLabel.text = detail.recommend_add;
        if ([detail.recommend_add integerValue] > 0) {
            self.likeBtn.selected = YES;
        }
        self.nickNameLabel.text = detail.author;
    }
}


@end
