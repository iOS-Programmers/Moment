//
//  LXDataModel.m
//  Chemayi
//
//  Created by Bird on 14-3-19.
//  Copyright (c) 2014年 Chemayi. All rights reserved.
//

#import "LXDataModel.h"
#import <objc/runtime.h>

static NSMutableDictionary *keyNames = nil; // key names for all subclass of ModelObject

@implementation LXDataModel
#pragma mark - init

// Before this class is first accessed, we'll need to build up our associated metadata, basically
// just a list of all our property names so we can quickly enumerate through them for various methods.
+ (void)initialize {
    
	if (nil == keyNames) {
        keyNames = [NSMutableDictionary new];
    }
    
	NSMutableArray *names = [NSMutableArray new];
    
    //保存从ModelObject往下的所有父子关系中keys
    //比如News继承至ModelObject，VideoNews继承至News，则VideoNews中必须保存News中的所有keys
	for (Class cls = self; cls!= [LXDataModel class]; cls = [cls superclass])
    {
		unsigned int varCount;
		Ivar *vars = class_copyIvarList(cls, &varCount);
		
		for (unsigned int i = 0; i < varCount; i++)
        {
			Ivar var = vars[i];
			NSString *name = [[NSString alloc] initWithUTF8String:ivar_getName(var)];
			[names addObject:[name substringFromIndex:1]];
			[name release];
		}
		free(vars);
	}
	[keyNames setObject:names forKey:NSStringFromClass([self class])];
	[names release];
}

- (NSMutableDictionary *)convertToDictionary
{
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:nil] autorelease];
    for (NSString *key in [self allKeys])
    {
        if (![key isEqualToString:@"objMapDic"])
        {
            id value = [self valueForKey:key];
            if (nil != value && [NSNull null] != value)
            {
                if ([value isKindOfClass:[NSString class]])
                {
                    [dic setObject:(NSString *)value forKey:key];
                }
                else if ([value isKindOfClass:[NSNumber class]])
                {
                    [dic setObject:[value stringValue] forKey:key];
                }
                else if([value isKindOfClass:[NSArray class]])
                {
                    for (id subValue in (NSArray *)value)
                    {
                        NSMutableArray *array = [[[NSMutableArray alloc] initWithObjects:nil] autorelease];
                        if ([subValue isKindOfClass:[LXDataModel class]])
                        {
                            NSDictionary *subDic =[subValue convertToDictionary];
                            [array addObject:subDic];
                        }
                        [dic setObject:array forKey:key];
                    }
                }
                else
                {
                    YHLog(@"Check value type:key=%@!!",key);
                }
            }
        }
    }
    return  dic;
}

- (NSArray*)allKeys
{
	return [keyNames objectForKey:NSStringFromClass([self class])];
}

- (NSString *)capitalizedString:(NSString *)string
{
    if (!FBIsEmpty(string))
    {
        return [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[string substringToIndex:1] uppercaseString]];
    }
    return nil;
}

- (LXDataModel *)createObjectFromKey:(NSString *)key
{
    if (nil != key && [NSNull null] != (NSNull*)key)
    {
        NSString* capitalizedClassName = [self capitalizedString:key];
        LXDataModel * object = (LXDataModel *)[[[NSClassFromString(capitalizedClassName) alloc] init] autorelease];
        NSAssert(object != nil, @"create object failed");
        return object;
    } else {
        return nil;
    }
}

- (void)skipNilValue
{
	for (NSString *name in [self allKeys])
    {
		id object = [self valueForKey:name];
        if (FBIsEmpty(object))
        {
            [self setValue:@"nil" forKey:name];
        }
    }
}

#pragma mark - NSCoder

// NSCoder implementation, for unarchiving
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
		for (NSString *name in [self allKeys])
			[self setValue:[aDecoder decodeObjectForKey:name] forKey:name];
	}
	return self;
}

// NSCoder implementation, for archiving
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
	for (NSString *name in [self allKeys]) {
        id object = [self valueForKey:name];
        if ([object conformsToProtocol:@protocol(NSCoding)]) {
            [aCoder encodeObject:[self valueForKey:name] forKey:name];
        }
    }
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark - copy

// NSCopying implementation
- (id)copyWithZone:(NSZone *)zone {
	
	id copied = [[[self class] alloc] init];
	
	for (NSString *name in [self allKeys])
		[copied setValue:[self valueForKey:name] forKey:name];
	
	return copied;
}

#pragma mark - fast enumeration

// We implement the NSFastEnumeration protocol to behave like an NSDictionary - the enumerated values are our property (key) names.
// https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjectiveC/Chapters/ocFastEnumeration.html#//apple_ref/doc/uid/TP30001163-CH18
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
	return [[self allKeys] countByEnumeratingWithState:state objects:stackbuf count:len];
}

#pragma mark - equal

// Override isEqual to compare model objects by value instead of just by pointer.
- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
	if ([other isKindOfClass:[self class]]) {
		for (NSString *name in [self allKeys]) {
			id a = [self valueForKey:name];
			id b = [other valueForKey:name];
			
			// extra check so a == b == nil is considered equal
            // 否则的话a==nil的情况下，无论b是否nil，[a isEqual:b] == nil
			if ((a || b) && ![a isEqual:b]) {
                return NO;
            }
		}
		return YES;
	} else {
        return NO;
    }
}

// Must override hash as well, this is taken directly from RMModelObject, basically
// classes with the same layout return the same number.
- (NSUInteger)hash {
	return (NSUInteger)[self allKeys];
    
}

#pragma mark - description

- (void)writeLineBreakToString:(NSMutableString *)string withTabs:(NSUInteger)tabCount {
	[string appendString:@"\n"];
	for (int i=0;i<tabCount;i++) [string appendString:@"\t"];
}

// Prints description in a nicely-formatted and indented manner.
- (void)writeToDescription:(NSMutableString *)description withIndent:(NSUInteger)indent {
	
	[description appendFormat:@"<%@ %p", NSStringFromClass([self class]), self];
	
	for (NSString *name in [self allKeys]) {
		
		[self writeLineBreakToString:description withTabs:indent];
		
		id object = [self valueForKey:name];
		
		if ([object isKindOfClass:[LXDataModel class]]) {
			[object writeToDescription:description withIndent:indent+1];
		}
		else if ([object isKindOfClass:[NSArray class]]) {
			
			[description appendFormat:@"%@ =", name];
			
			for (id child in object) {
				[self writeLineBreakToString:description withTabs:indent+1];
				
				if ([child isKindOfClass:[LXDataModel class]])
					[child writeToDescription:description withIndent:indent+2];
				else
					[description appendString:[child description]];
			}
		}
		else if ([object isKindOfClass:[NSDictionary class]]) {
			
			[description appendFormat:@"%@ =", name];
			
			for (id key in object) {
				[self writeLineBreakToString:description withTabs:indent];
                [description appendFormat:@"\t%@ = ",key];
                
				id child = [object objectForKey:key];
				
				if ([child isKindOfClass:[LXDataModel class]])
					[child writeToDescription:description withIndent:indent+2];
				else
					[description appendString:[child description]];
			}
		}
		else {
			[description appendFormat:@"%@ = %@", name, object];
		}
	}
    
	[description appendString:@">"];
}

// Override description for helpful debugging.
- (NSString*)description {
	NSMutableString *description = [NSMutableString string];
	[self writeToDescription:description withIndent:1];
    
	return description;
}
@end
