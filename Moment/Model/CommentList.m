//
//  CommentList.m
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "CommentList.h"

@implementation CommentList

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self.objMapDic setObject:@"CommentInfo" forKey:@"dataArray"];
    }
    return self;
}

@end
