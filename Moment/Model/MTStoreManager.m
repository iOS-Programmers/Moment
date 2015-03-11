//
//  MTStoreManager.m
//  Moment
//
//  Created by Jyh on 14/12/9.
//  Copyright (c) 2014年 YH. All rights reserved.
//

#import "MTStoreManager.h"

@implementation MTStoreManager

+ (instancetype)shareStoreManager
{
    static MTStoreManager *storeManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storeManager = [[MTStoreManager alloc] init];
    });
    return storeManager;
}

- (NSMutableArray *)getMineConfigureArray
{
    NSMutableArray *mineConfigureArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSDictionary *myTicketDic = @{@"title": @"",@"image": @"username"};
    [mineConfigureArray addObject:@[myTicketDic]];
    
    NSDictionary *myScoreDic = @{@"title": @"我的故事",@"image": @"story"};
    NSDictionary *myBonusDic = @{@"title": @"系统消息",@"image": @"notice"};
    NSDictionary *myRedPacketDic = @{@"title": @"评论",@"image": @"info"};
    [mineConfigureArray addObject:@[myScoreDic,myBonusDic,myRedPacketDic]];



    NSDictionary *inviteDic = @{@"title": @"邀请好友",@"image": @"friend"};
    [mineConfigureArray addObject:@[inviteDic]];
    
    return mineConfigureArray;
}

- (NSMutableArray *)getSettingConfigureArray
{
    NSMutableArray *settingConfigureArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSDictionary *myDic = @{@"title": @"我的账号"};
    [settingConfigureArray addObject:@[myDic]];
    
    NSDictionary *noticeDic = @{@"title": @"新消息提醒"};
    NSDictionary *saveDic = @{@"title": @"拍照自动保存到手机相册"};
    [settingConfigureArray addObject:@[noticeDic,saveDic]];
    
    NSDictionary *aboutDic = @{@"title": @"关于瞬间"};
//    NSDictionary *newVersionDic = @{@"title": @"检测最新版本"};
    [settingConfigureArray addObject:@[aboutDic]];
    
    NSDictionary *clearCacheDic = @{@"title": @"清除图片缓存"};
    [settingConfigureArray addObject:@[clearCacheDic]];
    
    return settingConfigureArray;
}

@end
