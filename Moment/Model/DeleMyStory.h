//
//  DeleMyStory.h
//  Moment
//
//  Created by Jyh on 14/12/22.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "LXResultModel.h"

@interface DeleMyStory : LXResultModel

/**
 *  1为成功，非1为失败
 */
@property (nonatomic, copy) NSString *status;

@end
