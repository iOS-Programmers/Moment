//
//  OAuthLoginHttp.h
//  Moment
//
//  Created by Jyh on 15/1/27.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "LXHttpModel.h"
#import "OAuthLogin.h"
#import "OAuthLoginPara.h"

@interface OAuthLoginHttp : LXHttpModel

@property (nonatomic, strong) OAuthLoginPara *parameter;
@property (nonatomic, strong) OAuthLogin *resultModel;
- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock;

@end
