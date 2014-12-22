//
//  MyProfileHttp.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "MyProfile.h"
#import "MyProfilePara.h"

@interface MyProfileHttp : LXHttpModel

@property (nonatomic, strong) MyProfilePara *parameter;
@property (nonatomic, strong) MyProfile *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end

