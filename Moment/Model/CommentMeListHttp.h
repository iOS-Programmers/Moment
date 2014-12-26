//
//  CommentMeListHttp.h
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "CommentMeList.h"
#import "CommentMeListPara.h"

@interface CommentMeListHttp : LXHttpModel

@property (nonatomic, strong) CommentMeListPara *parameter;
@property (nonatomic, strong) CommentMeList *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
