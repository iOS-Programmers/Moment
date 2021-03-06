//
//  MTUserInfo.m
//  Moment
//
//  Created by Jyh on 14/12/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MTUserInfo.h"

@implementation MTUserInfo

+ (MTUserInfo *)defaultUserInfo
{

    static MTUserInfo *userInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[MTUserInfo alloc] init];
        
    });
    
    return userInfo;
}

- (BOOL)isLogin
{
    return !FBIsEmpty([MTUserInfo userID]);
}

+ (void)saveUserInfo:(MTUserInfo *)info
{
    if (!FBIsEmpty(info.avatar)) {
        [MTUserInfo defaultUserInfo].avatar = info.avatar;
    }
    if (!FBIsEmpty(info.username)) {
        [MTUserInfo defaultUserInfo].username = info.username;
    }
    if (!FBIsEmpty(info.nickname)) {
        [MTUserInfo defaultUserInfo].nickname = info.nickname;
    }
    if (!FBIsEmpty(info.regtime)) {
        [MTUserInfo defaultUserInfo].regtime = info.regtime;
    }
    if (!FBIsEmpty(info.mobile)) {
        [MTUserInfo defaultUserInfo].mobile = info.mobile;
    }
}

/**
 *  接口所需token的存取方法
 *
 *  @param str token
 */
+ (void)saveToken:(NSString *)str
{
    if (!FBIsEmpty(str))
    {
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:MT_TOKEN];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (NSString *)Token
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:MT_TOKEN];
}

/**
 *  用户ID的存取方法
 *
 *  @param str userId
 */
+ (void)saveUserID:(NSString *)str
{
    if (!FBIsEmpty(str))
    {
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:MT_USERID];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)userID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:MT_USERID];
}


/**
 *  退出登录，清空用户数据
 *
 */
+(void)clearAllUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MT_USERID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MT_TOKEN];
}

@end
