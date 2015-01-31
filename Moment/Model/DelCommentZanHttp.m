//
//  DelCommentZanHttp.m
//  Moment
//
//  Created by Jyh on 15/1/31.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "DelCommentZanHttp.h"

@implementation DelCommentZanHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[DelCommentZanPara alloc] init];
        self.resultModel = [[DelCommentZan alloc] init];
        self.apiFuncName = @"delCommentRecommend";
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
