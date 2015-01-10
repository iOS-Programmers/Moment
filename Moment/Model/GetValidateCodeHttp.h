//
//  GetValidateCodeHttp.h
//  Moment
//
//  Created by Jyh on 1/10/15.
//  Copyright (c) 2015 YH. All rights reserved.
//

#import "LXHttpModel.h"

#import "GetValidateCode.h"
#import "GetValidateCodePara.h"

@interface GetValidateCodeHttp : LXHttpModel

@property (nonatomic, strong) GetValidateCodePara *parameter;
@property (nonatomic, strong) GetValidateCode *resultModel;

- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
