//
//  AllCommentListViewController.h
//  Moment
//
//  Created by Jyh on 14/12/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHBaseTableViewController.h"

@interface AllCommentListViewController : YHBaseTableViewController

/**
 *  上级页面传入的故事ID
 */
@property (copy, nonatomic) NSString *tid;

/**
 *  上级页面传入的故事分类ID
 */
@property (copy, nonatomic) NSString *fid;

@end
