//
//  MyStory.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXResultModel.h"

@interface MyStory : LXResultModel

//故事id
@property (nonatomic, copy) NSString *tid;
//标题
@property (nonatomic, copy) NSString *title;
//故事内容
@property (nonatomic, copy) NSString *content;
//发布时间
@property (nonatomic, copy) NSString *dateline;

@end
