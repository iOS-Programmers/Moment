//
//  OAuthLogin.h
//  Moment
//
//  Created by Jyh on 15/1/27.
//  Copyright (c) 2015年 YH. All rights reserved.
//

#import "LXResultModel.h"

@interface OAuthLogin : LXResultModel

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *regtime;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *member_id;

@end
