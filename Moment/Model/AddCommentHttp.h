//
//  AddCommentHttp.h
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"

@interface AddCommentHttp : LXHttpModel

@property (nonatomic, strong) MomentInfoPara *parameter;
@property (nonatomic, strong) MomentInfo *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
