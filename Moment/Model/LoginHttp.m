//
//  LoginHttp.m
//  Chemayi
//
//  Created by Bird on 14-3-27.
//  Copyright (c) 2014年 Chemayi. All rights reserved.
//

#import "LoginHttp.h"

@implementation LoginHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[LoginPara alloc] init];
        self.resultModel = [[Login alloc] init];
        self.apiFuncName = @"userLogin";
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
