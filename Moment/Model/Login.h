//
//  Login.h
//  Chemayi
//
//  Created by Bird on 14-3-27.
//  Copyright (c) 2014年 Chemayi. All rights reserved.
//

#import "LXResultModel.h"

@interface Login : LXResultModel
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *checkin_lasttime;
@property (nonatomic, copy) NSString *checkin_days;

@end
