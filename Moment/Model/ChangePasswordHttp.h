//
//  ChangePasswordHttp.h
//  Moment
//
//  Created by Jyh on 1/23/15.
//  Copyright (c) 2015 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "ChangePassword.h"
#import "ChangePasswordPara.h"

@interface ChangePasswordHttp : LXHttpModel

@property (nonatomic, strong) ChangePasswordPara *parameter;
@property (nonatomic, strong) ChangePassword *resultModel;

- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;


@end
