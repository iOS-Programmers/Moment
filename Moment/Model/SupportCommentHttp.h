//
//  SupportCommentHttp.h
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "SupportComment.h"
#import "SupportCommentPara.h"

@interface SupportCommentHttp : LXHttpModel

@property (nonatomic, strong) SupportCommentPara *parameter;
@property (nonatomic, strong) SupportComment *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
