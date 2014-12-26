//
//  SysMessageCell.m
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "SysMessageCell.h"
#import "Message.h"

@implementation SysMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateMessageCellWithInfo:(Message *)messageDetail
{
    if (!FBIsEmpty(messageDetail)) {
        
        self.titleLb.text = messageDetail.title;
        self.contentLabel.text = messageDetail.note;
        self.timeLabel.text = [LXUtils secondChangToDateString:messageDetail.dateline];
        
    }
}
@end
