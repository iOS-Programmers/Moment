//
//  Message.h
//  Moment
//
//  Created by Jyh on 12/26/14.
//  Copyright (c) 2014 YH. All rights reserved.
//

#import "LXResultModel.h"

@interface Message : LXResultModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *dateline;

@end
