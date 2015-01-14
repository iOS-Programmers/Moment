//
//  MTEditTextViewController.h
//  Moment
//
//  Created by Jyh on 1/14/15.
//  Copyright (c) 2015 YH. All rights reserved.
//

#import "YHBaseViewController.h"

typedef void (^EditBackBlock) (NSString *str);

@interface MTEditTextViewController : YHBaseViewController
{
    EditBackBlock backBlock;
}

@property (nonatomic,copy)NSString *holderStr;//
@property (nonatomic,copy)NSString *titleStr;//
@property (nonatomic)NSInteger titleType;//键盘输入类型

- (void)setBackBlock:(EditBackBlock)block;
@end
