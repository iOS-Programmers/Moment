//
//  MTAppDelegate.h
//  Moment
//
//  Created by Jyh on 14/12/2.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>

//微信
#import "WXApi.h"

//腾讯


@interface MTAppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>
{
    enum WXScene _scene;
}
@property (strong, nonatomic) UIWindow *window;

+ (MTAppDelegate *)shareappdelegate;

- (void)initMainView;

@end
