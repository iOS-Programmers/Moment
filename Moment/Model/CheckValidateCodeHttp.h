//
//  CheckValidateCodeHttp.h
//  Moment
//
//  Created by Jyh on 1/23/15.
//  Copyright (c) 2015 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "CheckValidateCode.h"
#import "CheckValidateCodePara.h"

@interface CheckValidateCodeHttp : LXHttpModel

@property (nonatomic, strong) CheckValidateCodePara *parameter;
@property (nonatomic, strong) CheckValidateCode *resultModel;

- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;


@end
