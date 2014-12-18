//
//  MTAppDelegate.h
//  Moment
//
//  Created by Jyh on 14/12/2.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <UIKit/UIKit.h>
//微信
//#import "WXApi.h"

@interface MTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (MTAppDelegate *)shareappdelegate;

- (void)initMainView;
@end
