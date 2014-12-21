//
//  LoginHttp.h
//  Chemayi
//
//  Created by Bird on 14-3-27.
//  Copyright (c) 2014年 Chemayi. All rights reserved.
//

#import "LXHttpModel.h"
#import "Login.h"
#import "LoginPara.h"

@interface LoginHttp : LXHttpModel
@property (nonatomic, strong) LoginPara *parameter;
@property (nonatomic, strong) Login *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;
@end
