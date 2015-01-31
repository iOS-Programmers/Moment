//
//  DelMomentZanHttp.m
//  Moment
//
//  Created by Jyh on 15/1/31.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "DelMomentZanHttp.h"

@implementation DelMomentZanHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[DelMomentZanPara alloc] init];
        self.resultModel = [[DelMomentZan alloc] init];
        self.apiFuncName = @"delThreadRecommend";
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
