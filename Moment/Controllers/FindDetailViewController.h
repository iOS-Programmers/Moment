//
//  FindDetailViewController.h
//  Moment
//
//  Created by Jyh on 14/12/21.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "YHBaseViewController.h"
#import "YHBaseWebViewController.h"
#import "MomentInfo.h"

@interface FindDetailViewController : YHBaseWebViewController

/**
 *  上次传入，必传
 */
@property (strong ,nonatomic) MomentInfo *momentInfo;

@end
