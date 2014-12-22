//
//  AdMomentHttp.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "AdMoment.h"
#import "AdMomentPara.h"

@interface AdMomentHttp : LXHttpModel

@property (nonatomic, strong) AdMomentPara *parameter;
@property (nonatomic, strong) AdMoment *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;


@end
