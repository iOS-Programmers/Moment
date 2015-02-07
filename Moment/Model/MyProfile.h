//
//  MyProfile.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXResultModel.h"

@interface MyProfile : LXResultModel

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *regtime;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *member_id;

@end
