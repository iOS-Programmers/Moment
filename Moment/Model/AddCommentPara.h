//
//  AddCommentPara.h
//  Moment
//
//  Created by Jyh on 14/12/23.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXParameterModel.h"

@interface AddCommentPara : LXParameterModel

//故事id
@property (nonatomic, copy) NSString *tid;

//分类id
@property (nonatomic, copy) NSString *fid;

//评论内容
@property (nonatomic, copy) NSString *message;

@end
