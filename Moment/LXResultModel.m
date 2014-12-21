 //
//  LXResultModel.m
//  Chemayiforshops
//
//  Created by Bird on 14-6-12.
//  Copyright (c) 2014年 LianXian. All rights reserved.
//

// 设置为 0\1 关闭\打开  详细数据解析结果
#ifndef LXPARSE_LOG_STATUS
#define LXPARSE_LOG_STATUS 0
#endif

#import "LXResultModel.h"

@implementation LXResultModel

- (id)init
{
    self = [super init];
    if (nil != self){
        _objMapDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
    }
    return self;
}

-(void)dealloc
{
    [_objMapDic release],_objMapDic = nil;
    [super dealloc];
}


- (LXResultModel *)createObjectFromObjName:(NSString *)key
{
    if (nil != key && [NSNull null] != (NSNull*)key)
    {
        NSString* capitalizedClassName = [self capitalizedString:key];
        LXResultModel * object = (LXResultModel *)[[[NSClassFromString(capitalizedClassName) alloc] init] autorelease];
        NSAssert(object != nil, @"Create object failed");
        return object;
    } else {
        return nil;
    }
}

- (void)setModelFromValue:(id)dataStr
{
#if LXPARSE_LOG_STATUS
    YHLog(@"---------Start Structure:%@---------",[self class])
#endif
    if ([dataStr isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dataDic= (NSDictionary *)dataStr;
        for (NSString *key in [dataDic allKeys])
        {
            if ([self.allKeys containsObject:key])
            {
                id value = [dataDic objectForKey:key];
                
                //----dataDic value 是数组
                if ([value isKindOfClass:[NSArray class]])
                {
                    [self setModelFromArray:(NSArray *)value withKey:key];
                }
                
                //----dataDic value 是 字典
                else if ([value isKindOfClass:[NSDictionary class]])
                {

                        //FIXME: 这里需要补充或修改  查看这里内存是否需要释放？
                        LXResultModel *object = [self valueForKeyPath:[NSString stringWithFormat:@"self.%@",key]];
                        [object setModelFromValue:(NSDictionary *)value];
#if LXPARSE_LOG_STATUS
                        YHLog(@"Setobj:%@forkey:%@",(NSString *)value,key);
#endif
                }
                
                //----dataDic value 是 字符串、数字或其他
                else
                {
                    if (value != nil && value != [NSNull null])
                    {
                        if ([value isKindOfClass:[NSString class]])
                        {
#if LXPARSE_LOG_STATUS
                                YHLog(@"Setvalue:%@forkey:%@",(NSString *)value,key);
#endif
                                [self setValue:(NSString *)value forKey:key];
                        }
                        else if ([value isKindOfClass:[NSNumber class]])
                        {
#if LXPARSE_LOG_STATUS
                                YHLog(@"Setvalue:%@forkey:%@",[value stringValue],key);
#endif
                                [self setValue:[value stringValue] forKey:key];
                        }
                        else
                        {
                            YHLog(@"!!Value contains invalidate string");
                        }
                    }
                    else
                    {
                        if ([[self valueForKey:key] isKindOfClass:[NSArray class]])
                        {
                            NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
                            [self setValue:array forKey:key];
                            [array release];
                        }
                        else if([[self valueForKey:key] isKindOfClass:[NSString class]])
                        {
                            [self setValue:@"null" forKey:key];
                        }
                    }
                }
            }
            else
            {
                YHLog(@"!!%@-Model doesn't contain key:%@",[self class],key);
            }
        }
    }
    else if([dataStr isKindOfClass:[NSArray class]])
    {
        [self setModelFromArray:(NSArray *)dataStr withKey:@"dataArray"];
    }
    else
    {
        YHLog(@"!!Data contains invalude string");
    }
#if LXPARSE_LOG_STATUS
    YHLog(@"---------%@ Structure End---------",[self class])
#endif
}

- (void)setModelFromArray:(NSArray *)dataArray withKey:(NSString *)key
{
    if ([dataArray count] > 0)
    {
        id subValue = [dataArray objectAtIndex:0];
        
        //不允许数组嵌套数组
        if ([subValue isKindOfClass:[NSArray class]])
        {
            NSAssert(FALSE, @"!!You can't insert array into array");
        }
        
        //如果数组元素是Dictionary就生成相应的obj数组
        else if ([subValue isKindOfClass:[NSDictionary class]])
        {
            if ([self.allKeys containsObject:key])
            {
                NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:nil];
                NSString *objName = [self.objMapDic objectForKey:key];
                for (NSDictionary *subDict in dataArray)
                {
                    if (objName!=nil)
                    {
                        LXResultModel *object =[self createObjectFromObjName:objName];
                        [object setModelFromValue:subDict];
                        [array addObject:object];
                    }
                }
                [self setValue:array forKey:key];
                [array release];
#if LXPARSE_LOG_STATUS
                YHLog(@"SetObj:%@ ArrayForkey:%@",objName,key);
#endif
            }
            else
            {
                YHLog(@"!!Model doesn't contain ObjArrykey:%@",key);
            }
        }
        
        //如果数组元素是字符则直接生成数字或字符数组
        else
        {
            if ([self.allKeys containsObject:key])
            {
#if LXPARSE_LOG_STATUS
                YHLog(@"SetStrArrayForkey:%@",key);
#endif
                [self setValue:dataArray forKey:key];
            }
            else
            {
                YHLog(@"!!Model doesn't contain Arrykey:%@",key);
            }
        }
    }
    else
    {
        YHLog(@"!!Model contain nil arry:%@",key);
        if ([[self allKeys] containsObject:key])
        {
            NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:nil];
            [self setValue:array forKey:key];
            [array release];
        }
    }
}

@end
