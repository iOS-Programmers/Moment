//
//  MTTextFiedBGView.m
//  Moment
//
//  Created by Jyh on 14/12/18.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MTTextFiedBGView.h"

@implementation MTTextFiedBGView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}


@end
