//
//  MyStoryList.m
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MyStoryList.h"

@implementation MyStoryList

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self.objMapDic setObject:@"MyStory" forKey:@"dataArray"];
    }
    return self;
}

@end
