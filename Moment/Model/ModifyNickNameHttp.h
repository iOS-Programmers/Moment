//
//  ModifyNickNameHttp.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "ModifyNickName.h"
#import "ModifyNickNamePara.h"

@interface ModifyNickNameHttp : LXHttpModel

@property (nonatomic, strong) ModifyNickNamePara *parameter;
@property (nonatomic, strong) ModifyNickName *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
