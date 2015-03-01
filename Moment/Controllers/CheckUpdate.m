//
//  CheckUpdate.m
//  Solcoo
//
//  Created by Jiang Yinghui on 13-8-8.
//  Copyright (c) 2013年 John. All rights reserved.
//

#import "CheckUpdate.h"

@implementation CheckUpdate


+ (CheckUpdate *)shareInstance {

    static CheckUpdate *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CheckUpdate alloc]init];
    });

    return instance;
}

- (BOOL)checkUp {

    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    /**
     *  CFBundleShortVersionString  是取得版本号
     *  CFBundleVersion             是取的Build号
     *  不可混用，切记切记
     */
    NSString *currentVersion = infoDict[@"CFBundleShortVersionString"];
    NSString *version = @"";
    
    NSURL *url = [NSURL URLWithString:AppStoreDownloadUrl];
    
    ASIFormDataRequest *versionRequest = [ASIFormDataRequest requestWithURL:url];
    [versionRequest setRequestMethod:@"GET"];
    [versionRequest setDelegate:self];
    [versionRequest setTimeOutSeconds:15];
    [versionRequest startSynchronous];
    
    NSString* jsonResponseString = [versionRequest responseString];
    
    NSDictionary *loginAuthenticationResponse = [jsonResponseString objectFromJSONString];
    
    NSArray *configData = [loginAuthenticationResponse valueForKey:@"results"];
    
//    for (NSDictionary *key in configData)
//    {
//        describ = key[@"releaseNotes"];
//    }
    
    for (id config in configData)
    {
        version = [config valueForKey:@"version"];
        
    }
    //如果有版本更新则提示有更新
    if ([currentVersion compare:version ] == NSOrderedAscending)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HAS_NEW_VERSION];
        
        return YES;
    }
    //没有版本更新提示当前为最新版本
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:HAS_NEW_VERSION];
        return NO;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return NO;
}


@end
