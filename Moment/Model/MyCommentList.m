//
//  MyCommentList.m
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "MyCommentList.h"

@implementation MyCommentList

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self.objMapDic setObject:@"MyComment" forKey:@"dataArray"];
    }
    return self;
}

@end
