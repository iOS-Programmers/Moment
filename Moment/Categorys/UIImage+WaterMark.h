//
//  UIImage+WaterMark.h
//  Image+watermark
//
//  Created by zyq on 13-5-8.
//  Copyright (c) 2013年 zyq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WaterMark)

-(UIImage *)imageWithLogoText:(UIImage *)img text:(NSString *)text1;
-(UIImage *)imageWithLogoImage:(UIImage *)img logo:(UIImage *)logo;//图片水印
-(UIImage *)imageWithSourceImage:(UIImage *)img WaterMask:(UIImage*)mask inRect:(CGRect)rect;//图片水印，可控制显示位置
-(UIImage *)imageWithTransImage:(UIImage *)useImage addtransparentImage:(UIImage *)transparentimg;
@end
