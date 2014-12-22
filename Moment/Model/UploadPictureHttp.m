//
//  UploadPictureHttp.m
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "UploadPictureHttp.h"

@implementation UploadPictureHttp

- (id)init
{
    self = [super init];
    if (nil != self){
        self.parameter = [[UploadPicturePara alloc] init];
        self.resultModel = [[UploadPicture alloc] init];
        self.apiFuncName = @"picsUpload";
    }
    return self;
}


- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock
{
    self.parameter.confirm = [[NSString stringWithFormat:@"%@%@",[MTAPP_KEY md5],[MTUserInfo userID]] md5];
    [self uploadDataWithParameters:self.parameter completionBlock:completionBlock failedBlock:failedBlock];
}

@end
