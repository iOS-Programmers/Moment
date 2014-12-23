//
//  DeleMyStoryHttp.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "DeleMyStory.h"
#import "DeleMyStoryPara.h"

@interface DeleMyStoryHttp : LXHttpModel

@property (nonatomic, strong) DeleMyStoryPara *parameter;
@property (nonatomic, strong) DeleMyStory *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
