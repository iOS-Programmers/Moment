//
//  LXElementCategory.m
//  CMY_iPhone
//
//  Created by Jiang on 14-3-17.
//  Copyright (c) 2014年 Iceland. All rights reserved.
//

#import "LXElementCategory.h"

@implementation LXElementCategory

@end

#pragma mark - UIImage

@implementation UIImage (ImageNoCache)

+ (UIImage *)imageNoCache:(NSString *)imageName {
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], imageName] ];
}

+ (UIImage *)imageNoCachePNG:(NSString *)imageName {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)imageNoCacheJPG:(NSString *)imageName {
    NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:@"jpg"];
    return [UIImage imageWithContentsOfFile:path];
}

@end

#pragma mark - UIColor

@implementation UIColor (Utils)

+ (UIColor*)colorToGRB:(NSString *)scolor {
    char color[8];
    uint len;
    [scolor getBytes:color maxLength:8 usedLength:&len encoding:NSUTF8StringEncoding options:NSStringEncodingConversionAllowLossy range:NSMakeRange(0, [scolor length]) remainingRange:nil];
	if (len != 6 && len != 7) {
    	return [UIColor colorWithRed:1 green:1 blue:1 alpha:1.0f];
	}
	float m = 255.0f,r=0.0f,g=0.0f,b=0.0f;
    int off = 0;
	if (len == 7) {
		off += 1;
	}
	char a[3];
    a[2] = 0;
    
	memcpy(a, color+off, 2);
	r = ((float)strtol(a, NULL, 16))/m;
	memcpy(a, color+off + 2, 2);
    g = ((float)strtol(a, NULL, 16))/m;
	memcpy(a, color+off + 4, 2);
	b = ((float)strtol(a, NULL, 16))/m;
	return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
    
}

@end


#pragma mark - UIButton

@implementation UIButton(Utils)

- (void)setImageN:(NSString *)imageN HightImg:(NSString *)imgeH
{
    [self setImage:[UIImage imageNoCachePNG:imageN] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNoCachePNG:imgeH] forState:UIControlStateHighlighted];
}
- (void)setImageNH:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
    
}

- (void)setImageNHNoCache:(NSString *)imageStr {
    [self setImage:[UIImage imageNoCachePNG:imageStr] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNoCachePNG:imageStr] forState:UIControlStateHighlighted];
}

- (void)setImageNH:(NSString *)image disabled:(NSString *)disabled {
    [self setImage:[UIImage imageNoCachePNG:image] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNoCachePNG:image] forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNoCachePNG:disabled] forState:UIControlStateDisabled];
}


- (void)setImageNH:(NSString *)image selected:(NSString *)selected {
    [self setImage:[UIImage imageNoCachePNG:image] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNoCachePNG:image] forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNoCachePNG:selected] forState:UIControlStateSelected];
}

- (void)setBackgroundImageNH:(UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
}

- (void)setTitleNH:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
}

- (void)setTitleColorNH:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
}
- (UIImage *)imageForNormal {
    return [self imageForState:UIControlStateNormal];
}

- (UIImage *)imageForHighLight {
    return [self imageForState:UIControlStateHighlighted];
}

- (UIImage *)backgroundImageForNormal {
    return [self backgroundImageForState:UIControlStateNormal];
}

@end