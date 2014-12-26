//
//  SupportCommentHttp.m
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "SupportCommentHttp.h"

@implementation SupportCommentHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[SupportCommentPara alloc] init];
        self.resultModel = [[SupportComment alloc] init];
        self.apiFuncName = @"addCommentRecommend";
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
