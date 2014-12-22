//
//  MomentListHttp.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "MomentList.h"
#import "MomentListPara.h"

@interface MomentListHttp : LXHttpModel

@property (nonatomic, strong) MomentListPara *parameter;
@property (nonatomic, strong) MomentList *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
