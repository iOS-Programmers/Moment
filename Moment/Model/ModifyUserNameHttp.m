//
//  ModifyUserNameHttp.m
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "ModifyUserNameHttp.h"

@implementation ModifyUserNameHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[ModifyUserNamePara alloc] init];
        self.resultModel = [[ModifyUserName alloc] init];
        self.apiFuncName = @"updateMyUsername";
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
