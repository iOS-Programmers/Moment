//
//  OAuthLoginPara.h
//  Moment
//
//  Created by Jyh on 15/1/27.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "LXParameterModel.h"

@interface OAuthLoginPara : LXParameterModel

@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;

@end
