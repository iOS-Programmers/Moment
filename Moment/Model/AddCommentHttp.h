//
//  AddCommentHttp.h
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "AddComment.h"
#import "AddCommentPara.h"

@interface AddCommentHttp : LXHttpModel

@property (nonatomic, strong) AddCommentPara *parameter;
@property (nonatomic, strong) AddComment *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
