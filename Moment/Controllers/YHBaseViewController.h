//
//  HTBaseViewController.h
//  HuiTuTicket
//
//  Created by Chemayi on 14-7-16.
//  Copyright (c) 2014年 HT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HTBarButtonItemActionBlock)(void);

typedef NS_ENUM(NSInteger, HTBarbuttonItemStyle) {
    kHTBarbuttonItemSettingStyle = 0,
    kHTBarbuttonItemMoreStyle,
    kHTBarbuttonItemCameraStyle,
};

@interface YHBaseViewController : UIViewController

/**
 *  统一设置背景图片
 *
 *  @param backgroundImage 目标背景图片
 */
- (void)setupBackgroundImage:(UIImage *)backgroundImage;

/**
 *  push新的控制器到导航控制器
 *
 *  @param newViewController 目标新的控制器对象
 */
- (void)pushNewViewController:(UIViewController *)newViewController;

/**
 *  点击view的时候取消掉键盘第一响应
 */
- (void)clearKeyboard;
- (void)setControlView:(id)sender;



#pragma mark ViewController presentModal
/**
 *  直接push到某个类 在不需要传数据的情况下可以使用这种。(如果需要传数据还是使用传统的push方法)
 *
 *  @param className 类名
 *  @param animated  是否带动画
 */
- (void)lxPushViewController:(NSString *)className animated:(BOOL)animated;
- (void)pushViewController:(NSString *)className;
- (void)pushViewControllerNoAnimated:(NSString *)className;



/**
 *  显示加载的loading，没有文字的
 */
- (void)showLoading;
/**
 *  显示带有某个文本加载的loading
 *
 *  @param text 目标文本
 */
- (void)showLoadingWithText:(NSString *)text;

- (void)showLoadingWithText:(NSString *)text onView:(UIView *)view;

/**
 *  显示成功的HUD
 */
- (void)showSuccess;
/**
 *  显示错误的HUD
 */
- (void)showErrorWithText:(NSString *)errorText;

/**
 *  显示只带文字的HUD
 */
- (void)showWithText:(NSString *)text;

/**
 *  隐藏在该View上的所有HUD，不管有哪些，都会全部被隐藏
 */
- (void)hideLoading;

- (void)configureBarbuttonItemStyle:(HTBarbuttonItemStyle)style action:(HTBarButtonItemActionBlock)action;

@end
