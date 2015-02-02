//
//  MTAppDelegate.h
//  Moment
//
//  Created by Jyh on 14/12/2.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHBaseTabbarController.h"

//微信
#import "WXApi.h"

//腾讯

//微博
#import "WeiboSDK.h"

@interface MTAppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate,WeiboSDKDelegate>
{
    enum WXScene _scene;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) YHBaseTabbarController *rootTabBarController;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

+ (MTAppDelegate *)shareappdelegate;

- (void)initMainView;

@end
