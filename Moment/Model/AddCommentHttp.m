//
//  AddCommentHttp.m
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "AddCommentHttp.h"

@implementation AddCommentHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[AddCommentPara alloc] init];
        self.resultModel = [[AddComment alloc] init];
        self.apiFuncName = @"addComment";
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
