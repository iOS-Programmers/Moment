//
//  UIView+Utils.h
//  
//
//  Created by Jiang on 14-3-17.
//
//

#import <UIKit/UIKit.h>


@interface UIView (Utils)

- (void)frameSetSize:(CGSize)size;
- (void)frameSetHeight:(float)height;
- (void)frameSetWidth:(float)width;
- (void)frameSetY:(float)y;
- (void)frameSetYAdd:(float)y;
- (void)frameSetX:(float)x;
- (void)frameSetPoint:(CGPoint)point;
//删除所有子视图
- (void)removeAllSubview;
//设置背景
- (void)setBackgroundImage:(NSString *)imageName;

//添加子视图并释放子视图
- (void)addSubviewAndRelease:(UIView *)view;


- (UILabel *)makeLabel:(NSString *)text fontSize:(CGFloat)fontSize textColor:(NSString *)textColor rect:(CGRect)rect;

//给view设置边角圆度
- (void) setViewCornerRadius:(int)radius;
//设置头像图片的圆角度8
- (void) setAvatarViewCornerRadius;
- (void)setContentModeScaleAspectFill;

@end
