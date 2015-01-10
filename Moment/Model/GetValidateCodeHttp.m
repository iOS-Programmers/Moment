//
//  GetValidateCodeHttp.m
//  Moment
//
//  Created by Jyh on 1/10/15.
//  Copyright (c) 2015 YH. All rights reserved.
//

#import "GetValidateCodeHttp.h"

@implementation GetValidateCodeHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[GetValidateCodePara alloc] init];
        self.resultModel = [[GetValidateCode alloc] init];
        self.apiFuncName = @"getValidateCode";
    }
    return self;
}


- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock
{
    self.parameter.confirm = [NSString stringWithFormat:@"%@",[[MTAPP_KEY md5] md5]];
    [self getDataWithParameters:self.parameter completionBlock:completionBlock failedBlock:failedBlock];
}

@end
