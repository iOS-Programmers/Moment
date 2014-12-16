//
//  NSString+LT.h
//  HuiTuTicket
//
//  Created by LiTong on 14-10-22.
//  Copyright (c) 2014年 HuiTuTicket. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LT)
//根据要显示的text计算label宽度
+ (CGFloat)contentCellWidhtWithText:(NSString*)text fontSize:(CGFloat)fontSize heigth:(CGFloat)height;
//根据要显示的text计算label宽高度
+ (CGFloat)contentCellHeightWithText:(NSString*)text fontSize:(CGFloat)fontSize width:(CGFloat)width;
//验证省份证号码
+ (BOOL)validateIDCardNumber:(NSString *)value;

/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateEmail:(NSString *)email;

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile;
@end
