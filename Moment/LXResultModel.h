//
//  LXResultModel.h
//  Chemayiforshops
//
//  Created by Bird on 14-6-12.
//  Copyright (c) 2014年 LianXian. All rights reserved.
//

#import "LXDataModel.h"

@interface LXResultModel : LXDataModel


/**
 *
 * map to record obj name
 *
 */
@property (nonatomic, retain) NSMutableDictionary *objMapDic;


/**
 *
 * 核心解析类 负责 把网络请求得到的Json 解析为model
 *
 */
- (void)setModelFromValue:(id)dataStr;

- (LXResultModel *)createObjectFromObjName:(NSString *)key;


@end
