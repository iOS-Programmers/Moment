//
//  LXDataModel.h
//  Chemayi
//
//  Created by Bird on 14-3-19.
//  Copyright (c) 2014年 Chemayi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 该类来自SMModelObject
 */

/*
 继承CWDataModel的类拥有如下功能:
 1. 实现了NSCoding，可以直接序列化。
 2. 实现了NSCopying，可以直接copy。
 3. 实现了NSFastEnumeration, 可以直接使用for语法。
 4. 实现了isEqual和hash，可以直接比较
 5. 直接从json object赋值
 */

/*
 注意：
 1. 关于NSFastEnumeration, 可以像NSDictionary那样直接访问keys
 for (NSString* key in model) {
 }
 */

@interface LXDataModel : NSObject<NSCoding, NSCopying, NSFastEnumeration>


- (NSString *)capitalizedString:(NSString *)string;

/**
 * get all keys
 */
- (NSArray*)allKeys;

- (NSMutableDictionary *)convertToDictionary;

- (void)skipNilValue;
@end
