//
//  SystemMessageHttp.m
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "SystemMessageHttp.h"

@implementation SystemMessageHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[SystemMessagePara alloc] init];
        self.resultModel = [[SystemMessage alloc] init];
        self.apiFuncName = @"mySystemMessage";
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
