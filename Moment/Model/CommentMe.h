//
//  CommentMe.h
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "LXResultModel.h"

@interface CommentMe : LXResultModel

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
//评论内容
@property (nonatomic, copy) NSString *message;

//展示图片
@property (nonatomic, copy) NSString *litpic;

//时间
@property (nonatomic, copy) NSString *dataline;

@end
