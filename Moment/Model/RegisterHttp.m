//
//  RegisterHttp.m
//  Moment
//
//  Created by Jyh on 14/12/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "RegisterHttp.h"

@implementation RegisterHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[RegisterPara alloc] init];
        self.resultModel = [[Register alloc] init];
        self.apiFuncName = @"userRegister";
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
