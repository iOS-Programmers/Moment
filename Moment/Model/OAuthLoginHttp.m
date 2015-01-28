//
//  OAuthLoginHttp.m
//  Moment
//
//  Created by Jyh on 15/1/27.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "OAuthLoginHttp.h"

@implementation OAuthLoginHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[OAuthLoginPara alloc] init];
        self.resultModel = [[OAuthLogin alloc] init];
        self.apiFuncName = @"OAuthLogin";
    }
    return self;
}


- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock
{
    self.parameter.confirm = [NSString stringWithFormat:@"%@",[[MTAPP_KEY md5] md5]];
    [self getDataWithParameters:self.parameter completionBlock:completionBlock failedBlock:failedBlock];
}

@end
