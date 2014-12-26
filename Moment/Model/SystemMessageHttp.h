//
//  SystemMessageHttp.h
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "SystemMessage.h"
#import "SystemMessagePara.h"

@interface SystemMessageHttp : LXHttpModel

@property (nonatomic, strong) SystemMessagePara *parameter;
@property (nonatomic, strong) SystemMessage *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
