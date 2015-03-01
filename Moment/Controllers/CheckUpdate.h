//
//  CheckUpdate.h
//  Solcoo
//
//  Created by Jiang Yinghui on 13-8-8.
//  Copyright (c) 2013年 John. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckUpdate : NSObject

+ (CheckUpdate *)shareInstance;

//检查更新
- (BOOL)checkUp;

@end
