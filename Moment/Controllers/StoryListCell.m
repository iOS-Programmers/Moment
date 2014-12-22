//
//  StoryListCell.m
//  Moment
//
//  Created by Jyh on 14/12/10.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "StoryListCell.h"
#import "MyStory.h"

@implementation StoryListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateStoryCellWithInfo:(MyStory *)detail
{
    if (!FBIsEmpty(detail)) {
        
        self.title.text = detail.title;
        self.contentLabel.text = detail.content;
        self.timeLabel.text = [LXUtils secondChangToDateString:detail.dateline];
        
    }
}

@end
