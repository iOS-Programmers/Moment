//
//  MomentInfo.h
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXResultModel.h"

@interface MomentInfo : LXResultModel

//故事id
@property (nonatomic, copy) NSString *tid;
//故事类型
@property (nonatomic, copy) NSString *fid;
//标题
@property (nonatomic, copy) NSString *title;
//内容
@property (nonatomic, copy) NSString *content;

//图片数组
@property (nonatomic, strong) NSMutableArray *pictureurls;
@end
