//
//  MyCommentListHttp.h
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "MyCommentList.h"
#import "MyCommentListPara.h"

@interface MyCommentListHttp : LXHttpModel

@property (nonatomic, strong) MyCommentListPara *parameter;
@property (nonatomic, strong) MyCommentList *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
