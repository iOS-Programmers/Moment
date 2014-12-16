//
//  LXUtils.h
//  Chemayi
//
//  Created by Bird on 14-3-17.
//  Copyright (c) 2014年 Chemayi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LXUtils : NSObject

/** check if object is empty
 if an object is nil, NSNull, or length == 0, return True
 */
static inline BOOL FBIsEmpty(id thing)
{
    return thing == nil ||
    ([thing isEqual:[NSNull null]]) ||
    ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
    ([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
}

/*
 * 获得屏幕的分辨率
 */
+ (int)GetScreeWidth;
+ (int)GetScreeHeight;

/**
 *  去掉状态栏，导航栏的高度
 */
+ (int)getContentViewHeight;

/**
 * @brief   iOS 系统版本
 */
+ (NSString *)systemVersion;

/**
 * @brief   APP version
 */
+ (NSString *)appVersion;

/**
 * @brief   获得设备型号
 */
+ (NSString*)devicePlatform;

/**
 * @brief   设备是否连接到网络
 */
+ (BOOL)networkDetect;

/**
 * @brief   设备是否越狱
 */
+ (BOOL)isJailbroken;

/*
 *  Name    : colorWithHexString
 *  Param   : NSString
 *  Note    : html颜色值转化UIColor  如#FF9900,0XFF9900
 */
+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;

//检查密码，手机号码，邮箱,车牌号
+ (BOOL)checkPasswordRule:(NSString *)candidate;
+ (BOOL)checkPhoneNumberRule:(NSString *)candidate;
+ (BOOL)checkValidateEmail:(NSString *)candidate;
+ (BOOL)validateCarNo:(NSString *) carNo;
+ (BOOL)checkDrivingYears:(NSString *)years;

//自定义头像的处理
+ (UIImage*)rotateImage:(UIImage *)image;
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;



#pragma mark - 时间处理
/**
 *  把秒转成  yyyy-MM-dd HH:mm 格式
 *
 *  @param dateStr 秒的字符串
 *
 *  @return  yyyy-MM-dd HH:mm
 */
+ (NSString *)secondChangToDateString:(NSString *)dateStr;

/**
 *  把秒转成  yyyy-MM-dd 格式
 *
 */
+ (NSString *)secondChangToDate:(NSString *)dateStr;

/**
 *  把秒转成 yyyy-MM 格式
 *
 */
+ (NSString *)secondChangToYearMonth:(NSString *)dateStr;

+ (NSDate *)secondChangToNSDate:(NSString *)dateStr;

+ (NSString *)secondChangToMonth:(NSString *)dateStr;

+ (NSString *)dateToSecondChang:(NSString *)dateStr;
////查询areaid   查询城市id
//+ (int)searchForAreaID:(NSString *)area cityID:(int)cityid;
//+ (int)searchForCityID:(NSString *)city;
//
//+ (NSMutableArray *)searchAreaTableInDB:(NSString *)sql;




@end
