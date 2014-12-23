//
//  CommentListHttp.h
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "CommentList.h"
#import "CommentListPara.h"

@interface CommentListHttp : LXHttpModel

@property (nonatomic, strong) CommentListPara *parameter;
@property (nonatomic, strong) CommentList *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
