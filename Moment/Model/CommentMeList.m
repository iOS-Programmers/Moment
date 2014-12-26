//
//  CommentMeList.m
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "CommentMeList.h"

@implementation CommentMeList

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self.objMapDic setObject:@"CommentMe" forKey:@"dataArray"];
    }
    return self;
}

@end
