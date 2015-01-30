//
//  SPMacro.h
//  Shaping
//
//  Created by Jyh on 14/12/3.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#ifndef Shaping_SPMacro_h
#define Shaping_SPMacro_h

// UIKit 框架宏定义
#import "UIKitMacro.h"

// Foundation 框架宏定义
#import "FoundationMacro.h"

//网络接口 宏定义
#import "HttpMacro.h"

//工具类
#import "LXUtils.h"

//UIView类别扩展
#import "UIView+Utils.h"

#import "MTAppDelegate.h"

#import "UIImageView+WebCache.h"

#import "MTStoreManager.h"

//用户数据类
#import "MTUserInfo.h"

#warning 这里需要更改地址，目前是微信的
//AppStore下载地址
#define AppStoreDownloadUrl @"https://itunes.apple.com/cn/app/wechat/id414478124?l=en&mt=8"

//友盟的AppKey
#define UM_APPKEY   @"54af8643fd98c5c56a000894"

//微信AppId
#define WX_APPID    @"wx743a4cb66b0192e3"

//微信App Secret
#define WX_APPSECRET @"bb7841c8ada15d3366dc02a35f22e3c3"

//QQ App Id
#define QQ_APPID  @"1103822133"

//QQ App Key
#define QQ_APPKey  @"IziMwhKAIcX6oSSt"

//微博 App Key
#define WeiBo_APPKey @"3126563299"

//微博 APP Secret
#define WeiBo_APPSecret @"7c3549eb40adc390896b83c2cf391b9d"

//微博 回调地址
#define Weibo_RedirectURI @"https://api.weibo.com/oauth2/default.html"


#pragma mark - Notifacation Name

#define MT_OAuthLogin @"oauthlogin"
#define MT_UpdatePersonalInfo @"updatepersonalInfo"


#pragma mark - NSUserDefaults Name

#define FirstLaunch  @"firstLaunch"

#endif
