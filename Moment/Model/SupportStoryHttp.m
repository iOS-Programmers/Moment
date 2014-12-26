//
//  SupportStoryHttp.m
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "SupportStoryHttp.h"

@implementation SupportStoryHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[SupportStoryPara alloc] init];
        self.resultModel = [[SupportStory alloc] init];
        self.apiFuncName = @"addThreadRecommend";
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
