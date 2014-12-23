//
//  CommentInfo.h
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXResultModel.h"

@interface CommentInfo : LXResultModel

//评论id
@property (nonatomic, copy) NSString *pid;

//故事id
@property (nonatomic, copy) NSString *tid;

//故事类型
@property (nonatomic, copy) NSString *fid;

//发布者
@property (nonatomic, copy) NSString *author;

//发布者ID
@property (nonatomic, copy) NSString *authorid;

//作者头像
@property (nonatomic, copy) NSString *avatar;

//评论内容
@property (nonatomic, copy) NSString *message;

//回复时间
@property (nonatomic, copy) NSString *dataline;

//点赞数
@property (nonatomic, copy) NSString *support;

@end
