//
//  SystemMessage.m
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "SystemMessage.h"

@implementation SystemMessage

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self.objMapDic setObject:@"Message" forKey:@"dataArray"];
    }
    return self;
}


@end
