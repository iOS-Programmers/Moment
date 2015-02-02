//
//  UIImage+Category.h
//  Created by Dennis Deng on 12/05/04.
//

#import <UIKit/UIKit.h>

@interface UIImage (wiCategory)

// 裁剪图片
- (UIImage *) imageCroppedToRect:(CGRect)rect;
// 裁减正方形区域
- (UIImage *) squareImage;

// 画水印
// 图片水印
- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect;
// 文字水印
- (UIImage *) imageWithStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font;
- (UIImage *) imageWithStringWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font;


// 蒙板
- (void) drawInRect:(CGRect)rect withImageMask:(UIImage*)mask;
- (void) drawMaskedColorInRect:(CGRect)rect withColor:(UIColor*)color;

// 保存图像文件
- (BOOL) writeImageToFileAtPath:(NSString*)aPath;

@end

