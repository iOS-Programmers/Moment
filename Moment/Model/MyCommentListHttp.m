//
//  MyCommentListHttp.m
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "MyCommentListHttp.h"

@implementation MyCommentListHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[MyCommentListPara alloc] init];
        self.resultModel = [[MyCommentList alloc] init];
        self.apiFuncName = @"myComment";
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
