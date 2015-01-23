//
//  CheckValidateCodeHttp.m
//  Moment
//
//  Created by Jyh on 1/23/15.
//  Copyright (c) 2015 YH. All rights reserved.
//

#import "CheckValidateCodeHttp.h"

@implementation CheckValidateCodeHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[CheckValidateCodePara alloc] init];
        self.resultModel = [[CheckValidateCode alloc] init];
        self.apiFuncName = @"checkValidateCode";
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
