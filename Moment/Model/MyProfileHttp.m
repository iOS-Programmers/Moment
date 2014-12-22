//
//  MyProfileHttp.m
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MyProfileHttp.h"

@implementation MyProfileHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[MyProfilePara alloc] init];
        self.resultModel = [[MyProfile alloc] init];
        self.apiFuncName = @"myProfile";
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
