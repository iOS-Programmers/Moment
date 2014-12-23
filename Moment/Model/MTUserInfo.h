//
//  MTUserInfo.h
//  Moment
//
//  Created by Jyh on 14/12/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTUserInfo : NSObject

/**
 *  判断是否登录
 */
@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *regtime;
@property (nonatomic, copy) NSString *mobile;
/**
 *  单例类初始化
 *
 *  @return
 */
+ (MTUserInfo *)defaultUserInfo;

/**
 *  接口所需token的存取方法
 *
 *  @param str token
 */
+ (void)saveToken:(NSString *)str;
+ (NSString *)Token;

/**
 *  用户ID的存取方法
 *
 *  @param str userId
 */
+ (void)saveUserID:(NSString *)str;
+ (NSString *)userID;

/**
 *  退出登录，清空用户数据
 *
 */
+(void)clearAllUserInfo;


@end
