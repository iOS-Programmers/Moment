//
//  MTStoreManager.h
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTStoreManager : NSObject

+ (instancetype)shareStoreManager;

/**
 *  配置<我的页面>cell里的内容
 *
 *  @return 包含图片和标题的数组
 */
- (NSMutableArray *)getMineConfigureArray;

/**
 *  配置<设置>cell内容
 *
 *  @return 包含标题的数组
 */
- (NSMutableArray *)getSettingConfigureArray;

@end
