//
//  MomentList.m
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MomentList.h"

@implementation MomentList

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self.objMapDic setObject:@"MomentDetail" forKey:@"dataArray"];
    }
    return self;
}

@end
