//
//  ModifyUserNameHttp.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "ModifyUserName.h"
#import "ModifyUserNamePara.h"

@interface ModifyUserNameHttp : LXHttpModel

@property (nonatomic, strong) ModifyUserNamePara *parameter;
@property (nonatomic, strong) ModifyUserName *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;


@end
