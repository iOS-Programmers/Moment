//
//  LoginViewController.h
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHBaseViewController.h"

typedef enum : NSUInteger {
    LoginTypeDefault,   //默认的不带返回按钮
    LoginTypeDismiss,   //带有返回按钮，并且以dissmiss方式返回
} LoginType;

@interface LoginViewController : YHBaseViewController

@property (nonatomic) LoginType loginType;

@end
