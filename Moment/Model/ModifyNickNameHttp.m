//
//  ModifyNickNameHttp.m
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "ModifyNickNameHttp.h"

@implementation ModifyNickNameHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[ModifyNickNamePara alloc] init];
        self.resultModel = [[ModifyNickName alloc] init];
        self.apiFuncName = @"updateMyNickname";
    }
    return self;
}


- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock
{
    self.parameter.confirm = [[NSString stringWithFormat:@"%@%@",[MTAPP_KEY md5],[MTUserInfo userID]] md5];
    [self getDataWithParameters:self.parameter completionBlock:completionBlock failedBlock:failedBlock];
}

@end
