//
//  ModifyAvatarHttp.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "ModifyAvatar.h"
#import "ModifyAvatarPara.h"

@interface ModifyAvatarHttp : LXHttpModel

@property (nonatomic, strong) ModifyAvatarPara *parameter;
@property (nonatomic, strong) ModifyAvatar *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
