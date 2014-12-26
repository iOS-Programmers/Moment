//
//  SupportStoryHttp.h
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "SupportStory.h"
#import "SupportStoryPara.h"

@interface SupportStoryHttp : LXHttpModel

@property (nonatomic, strong) SupportStoryPara *parameter;
@property (nonatomic, strong) SupportStory *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
