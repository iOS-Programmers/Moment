//
//  MomentListPara.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXParameterModel.h"

@interface MomentListPara : LXParameterModel

/**
 *  故事类型 0全部1因为爱情2青春、梦想、那些年3那些故事4闪耀瞬间
 */
@property (nonatomic, copy) NSString *fid;

/**
 *  当前页
 */
@property (nonatomic, copy) NSString *page;

/**
 *  每页显示条数
 */
@property (nonatomic, copy) NSString *pagesize;

@end
