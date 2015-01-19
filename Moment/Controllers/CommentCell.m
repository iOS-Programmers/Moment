//
//  CommentCell.m
//  Moment
//
//  Created by Jyh on 14/12/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "CommentCell.h"
#import "CommentInfo.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    self.avatarImage.layer.cornerRadius = CGRectGetWidth(self.avatarImage.frame)/2;
    self.avatarImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUIWithCommentInfo:(CommentInfo *)info
{
    [self.avatarImage sd_setImageWithURL:[NSURL  URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_PRE,info.avatar]] placeholderImage:[UIImage imageNamed:@"touxiang_pinglun + Oval 7"]];
    
    self.timeLabel.text = [LXUtils secondChangToDateString:info.dateline];
    self.contentLabel.text = info.message;
    
}
@end
