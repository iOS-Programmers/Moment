//
//  RegisterHttp.h
//  Moment
//
//  Created by Jyh on 14/12/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "Register.h"
#import "RegisterPara.h"

@interface RegisterHttp : LXHttpModel

@property (nonatomic, strong) RegisterPara *parameter;
@property (nonatomic, strong) Register *resultModel;

- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
