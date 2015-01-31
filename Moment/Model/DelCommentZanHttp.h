//
//  DelCommentZanHttp.h
//  Moment
//
//  Created by Jyh on 15/1/31.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "DelCommentZan.h"
#import "DelCommentZanPara.h"

@interface DelCommentZanHttp : LXHttpModel

@property (nonatomic, strong) DelCommentZanPara *parameter;
@property (nonatomic, strong) DelCommentZan *resultModel;

- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
