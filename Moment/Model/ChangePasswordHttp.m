//
//  ChangePasswordHttp.m
//  Moment
//
//  Created by Jyh on 1/23/15.
//  Copyright (c) 2015 YH. All rights reserved.
//

#import "ChangePasswordHttp.h"

@implementation ChangePasswordHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[ChangePasswordPara alloc] init];
        self.resultModel = [[ChangePassword alloc] init];
        self.apiFuncName = @"changePassword";
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
