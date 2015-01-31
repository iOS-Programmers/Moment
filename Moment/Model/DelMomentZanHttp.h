//
//  DelMomentZanHttp.h
//  Moment
//
//  Created by Jyh on 15/1/31.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "DelMomentZan.h"
#import "DelMomentZanPara.h"

@interface DelMomentZanHttp : LXHttpModel

@property (nonatomic, strong) DelMomentZanPara *parameter;
@property (nonatomic, strong) DelMomentZan *resultModel;

- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
