//
//  AdMomentPara.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXParameterModel.h"

@interface AdMomentPara : LXParameterModel

/**
 *  故事分类ID
 */
@property (nonatomic, copy) NSString *fid;

/**
 *  故事标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  故事内容
 */
@property (nonatomic, copy) NSString *content;

/**
 *  图片路径   多个图片用逗号隔开
 */
@property (nonatomic, copy) NSString *pictureurls;

@end
