//
//  MomentDetail.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXResultModel.h"

@interface MomentDetail : LXResultModel

//故事id
@property (nonatomic, copy) NSString *tid;
//故事类型
@property (nonatomic, copy) NSString *fid;
//作者
@property (nonatomic, copy) NSString *author;
//作者ID
@property (nonatomic, copy) NSString *authorid;
//作者头像
@property (nonatomic, copy) NSString *avatar;
//标题
@property (nonatomic, copy) NSString *title;
//内容
@property (nonatomic, copy) NSString *content;
//支持数
@property (nonatomic, copy) NSString *recommend_add;
//展示图片
@property (nonatomic, copy) NSString *litpic;


@end
