//
//  LXElementCategory.h
//  CMY_iPhone
//
//  Created by Jiang on 14-3-17.
//  Copyright (c) 2014年 Iceland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXElementCategory : NSObject

@end




#pragma mark - UIImage 

@interface UIImage (ImageNoCache)

+ (UIImage *)imageNoCache:(NSString *)imageName;
+ (UIImage *)imageNoCachePNG:(NSString *)imageName;
+ (UIImage *)imageNoCacheJPG:(NSString *)imageName;

@end


#pragma mark - UIColor

@interface UIColor (Utils)

//颜色转换
+ (UIColor*)colorToGRB:(NSString *)acolor;

@end

#pragma mark - UIButton
@interface UIButton(Utils)

//设置normal和highlight的图片一样
- (void)setImageN:(NSString *)imageN HightImg:(NSString *)imgeH;
- (void)setImageNH:(UIImage *)image;
- (void)setImageNHNoCache:(NSString *)imageStr;
- (void)setImageNH:(NSString *)image disabled:(NSString *)disabled;
- (void)setImageNH:(NSString *)image selected:(NSString *)selected;
- (void)setBackgroundImageNH:(UIImage *)image;
- (void)setTitleNH:(NSString *)title;
- (void)setTitleColorNH:(UIColor *)color;

- (UIImage *)imageForNormal;
- (UIImage *)imageForHighLight;
- (UIImage *)backgroundImageForNormal;


@end
