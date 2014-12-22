//
//  UploadPictureHttp.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "UploadPicture.h"
#import "UploadPicturePara.h"

@interface UploadPictureHttp : LXHttpModel

@property (nonatomic, strong)UploadPicturePara *parameter;
@property (nonatomic, strong)UploadPicture *resultModel;

- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
