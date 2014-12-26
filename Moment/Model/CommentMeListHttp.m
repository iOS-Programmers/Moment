//
//  CommentMeListHttp.m
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "CommentMeListHttp.h"

@implementation CommentMeListHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[CommentMeListPara alloc] init];
        self.resultModel = [[CommentMeList alloc] init];
        self.apiFuncName = @"myThreadComment";
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
