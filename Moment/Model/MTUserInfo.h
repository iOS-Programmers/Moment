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

@end
