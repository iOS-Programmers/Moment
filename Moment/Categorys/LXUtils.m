//
//  LXUtils.m
//  Chemayi
//
//  Created by Bird on 14-3-17.
//  Copyright (c) 2014年 Chemayi. All rights reserved.
//

#import "LXUtils.h"
//#import "Reachability.h"
#import "sys/sysctl.h"
#import "Sqlite3.h"

@implementation LXUtils


+ (int)GetScreeWidth
{
    return [UIScreen mainScreen].applicationFrame.size.width;
}

+ (int)GetScreeHeight
{
    return [UIScreen mainScreen].applicationFrame.size.height;
}

/**
 *  去掉状态栏，导航栏的高度
 */
+ (int)getContentViewHeight
{
    return [UIScreen mainScreen].applicationFrame.size.height - 44;
}

//+ (BOOL)networkDetect
//{
//    BOOL isExistenceNetwork = YES;
//    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    switch ([r currentReachabilityStatus])
//    {
//        case NotReachable:
//            isExistenceNetwork = NO;
//            break;
//        case ReachableViaWWAN:
//            isExistenceNetwork = YES;
//            break;
//        case ReachableViaWiFi:
//            isExistenceNetwork = YES;
//            break;
//    }
//    return  isExistenceNetwork;
//    
//}

+ (BOOL)isJailbroken
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath])
    {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath])
    {
        jailbroken = YES;
    }
    return jailbroken;
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    CFShow(infoDictionary);
    /* // app名称
     NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
     // app build版本
     return [infoDictionary objectForKey:@"CFBundleVersion"];
     */
    // app版本
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString*)devicePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

//密码不可以全为数字或者字母 （正确实例 a123456）且密码大于6位小于12位
+ (BOOL)checkPasswordRule:(NSString *)candidate
{
    NSString *numberRegex = @"[0-9]+";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    if ([numberTest evaluateWithObject:candidate]) {
        return NO;
    }
    NSString *characterRegex = @"[A-Za-z]+";
    NSPredicate *characterTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", characterRegex];
    if ([characterTest evaluateWithObject:candidate]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkPhoneNumberRule:(NSString *)candidate
{
    NSString *numberRegex = @"[0-9]+";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    if (![numberTest evaluateWithObject:candidate]) {
        return NO;
    }
    else if ([candidate length] != 11) {
        return NO;
    }
    return YES;
}

+ (BOOL)checkValidateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:candidate]) {
        return NO;
    }
	
    return YES;
}


/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL)checkDrivingYears:(NSString *)years
{
    if ([years intValue]<80 && [years intValue]>0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (UIImage*)rotateImage:(UIImage *)image
{
    int kMaxResolution = 320; // Or whatever
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:         //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else
    {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - 时间处理

+ (NSString *)secondChangToDateString:(NSString *)dateStr {
    
    if (FBIsEmpty(dateStr)) {
        return @"";
    }
    
    long long time = [dateStr longLongValue];
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSString *timeString=[dateFormatter stringFromDate:date];
    return timeString;
}

+ (NSString *)secondChangToDate:(NSString *)dateStr {
    
    if (FBIsEmpty(dateStr)) {
        return @"";
    }
    
    long long time = [dateStr longLongValue];
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSString * timeString=[dateFormatter stringFromDate:date];
    
    return timeString;
}

+ (NSString *)secondChangToYearMonth:(NSString *)dateStr
{
    if (FBIsEmpty(dateStr)) {
        return @"";
    }
    
    long long time = [dateStr longLongValue];
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM";
    
    NSString * timeString=[dateFormatter stringFromDate:date];
    
    return timeString;
}

+ (NSDate *)secondChangToNSDate:(NSString *)dateStr
{
    long long time = [dateStr longLongValue];
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    return date;
}

+ (NSString *)dateToSecondChang:(NSString *)dateStr {
    
    if (FBIsEmpty(dateStr)) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[date timeIntervalSince1970]];
    return timeSp;
}

+ (NSString *)secondChangToMonth:(NSString *)dateStr
{    
    if (FBIsEmpty(dateStr)) {
        return @"";
    }
    
    long long time = [dateStr longLongValue];
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM";
    
    NSString * timeString=[dateFormatter stringFromDate:date];
    
    return timeString;
}


//+ (int)searchForAreaID:(NSString *)area cityID:(int)cityid
//{
//    int areaID = 0;
//    //获取数据库文件路径
//    NSString *path =  [[NSBundle mainBundle]pathForResource:@"cmydb" ofType:@"sqlite"];
//    //打开或创建数据库
//    sqlite3 *database;
//    if (sqlite3_open([path UTF8String] , &database) != SQLITE_OK)
//    {
//        sqlite3_close(database);
//        NSAssert(0, @"打开数据库失败");
//    }
//    else
//    {
//        //SELECT * FROM "cmy4_car_category" ORDER BY "first_word"
//        
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM cmy4_region WHERE pid = '%d' and  name = '%@';",cityid,area];
//        sqlite3_stmt *statement;
//        if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) != SQLITE_OK)
//        {
//            LXLog(@"Error: failed to prepare statement with message:get testValue.");
//        }
//        else
//        {
//            //依次读取数据库表格FIELDS中每行的内容
//            while (sqlite3_step(statement) == SQLITE_ROW)
//            {
//                areaID = sqlite3_column_int(statement,0);
//            }
//            sqlite3_finalize(statement);
//        }
//        //关闭数据库
//        sqlite3_close(database);
//    }
//    return areaID;
//}
//




@end
