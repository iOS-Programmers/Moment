//
//  UIView+Utils.h
//
//
//  Created by Jiang on 14-3-17.
//
//


#import "UIView+Utils.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIView (Utils)

#pragma mark frame
- (void)frameSetSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)frameSetHeight:(float)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)frameSetWidth:(float)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)frameSetY:(float)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)frameSetYAdd:(float)y {
    CGRect frame = self.frame;
    frame.origin.y += y;
    self.frame = frame;
}

- (void)frameSetX:(float)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)frameSetPoint:(CGPoint)point {
    [self frameSetX:point.x];
    [self frameSetY:point.y];
}

- (void)removeAllSubview {
    for (UIView *viewSub in [self subviews]) {
        [viewSub removeFromSuperview];
    }
}

- (void)setBackgroundImage:(NSString *)imageName {
    UIImageView *imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    CGRect rect = [self frame];
    rect.origin = CGPointMake(0.0f, 0.0f);
    [imgview setFrame:rect];
    [self addSubview:imgview];

}

- (void)addSubviewAndRelease:(UIView *)view {
    [self addSubview:view];

}


- (UILabel *)makeLabel:(NSString *)text fontSize:(CGFloat)fontSize textColor:(NSString *)textColor rect:(CGRect)rect {
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    if (fontSize > 0.0f) {
        [label setFont:[UIFont systemFontOfSize:fontSize]];
    }
    [label setText:text];
    if (nil != textColor) {
//        [label setTextColor:[UIColor colorToGRB:textColor]];
    }
    [self addSubview:label];
    return label;
}

- (void) setViewCornerRadius:(int)radius {
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:YES];
}

- (void) setAvatarViewCornerRadius {
    [self setViewCornerRadius:8];
}

- (void)setContentModeScaleAspectFill {
    [self setClipsToBounds:YES];
    [self setContentMode:UIViewContentModeScaleAspectFill];
}

@end

