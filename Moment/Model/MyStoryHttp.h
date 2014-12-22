//
//  MyStoryHttp.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "MyStoryList.h"
#import "MyStoryPara.h"
@interface MyStoryHttp : LXHttpModel

@property (nonatomic, strong) MyStoryPara *parameter;
@property (nonatomic, strong) MyStoryList *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
