//
//  LXHttpModel.m
//  CMY_iPhone
//
//  Created by Bird on 13-12-9.
//  Copyright (c) 2013年 Iceland. All rights reserved.
//

// 设置为 0\1 关闭\打开  请求头与请求结果输出
#ifndef LXREQUEST_LOG_STATUS
#define LXREQUEST_LOG_STATUS 1
#endif

#import "LXHttpModel.h"

@interface LXHttpModel ()<ASIHTTPRequestDelegate>

@property (nonatomic, copy) HttpModelCompletionBlock completionBlock;
@property (nonatomic, copy) HttpModelFailedBlock failedBlock;
@property (nonatomic, retain)NSDate *time;

@end


@implementation LXHttpModel

- (id)init
{
    self = [super init];
    if (self)
    {
        self.method = @"GET";
        self.dataDic = [[[NSMutableDictionary alloc] init] autorelease];
    }
    return self;
}

-(void)dealloc
{
    [_request clearDelegatesAndCancel];
    [_apiFuncName release], _apiFuncName = nil;
    [_path release],_path = nil;
    [_method release],_method = nil;
    [_resultModel release],_resultModel = nil;

    [_token release],_token = nil;
    if (!FBIsEmpty(self.request)) {
        [_request release],_request = nil;
    }
    [_dataDic release],_dataDic = nil;
    
    [_time release],_time = nil;
    [_erorMessage release],_erorMessage = nil;
    
    [super dealloc];
}

- (void)getDataWithCompletionBlock:(HttpModelCompletionBlock)completionBlock
                       failedBlock:(HttpModelFailedBlock)failedBlock
{
    YHLog(@"sub class not implete getDataWithCompletionBlock:failedBlock!");
}

- (NSMutableDictionary *)convertParameters:(LXParameterModel *)params
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *keys = [params allKeys];
    for (NSUInteger i = 0; i < [keys count]; i++)
    {
        NSString *key = [keys objectAtIndex:i];
        NSString *value = [params valueForKey:key];
        if (nil != value)
        {
            [dictionary setObject:value forKey:key];
        }
    }
    return dictionary;
}

- (void)getDataWithParameters:(LXParameterModel *)params
              completionBlock:(HttpModelCompletionBlock)completionBlock
                  failedBlock:(HttpModelFailedBlock)failedBlock
{
//    [[self request] setDelegate:nil];
//    [[self request] cancel];
    
    NSMutableDictionary *dic = [self convertParameters:params];
//    self.path =[NSString stringWithFormat:@"http://%@/service.php?",HOST_NAME];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"hostName"]) {
        [[NSUserDefaults standardUserDefaults] setObject:HOST_NAME forKey:@"hostName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.path =[NSString stringWithFormat:@"%@/index.php/Index/",[[NSUserDefaults standardUserDefaults] objectForKey:@"hostName"]];
    
    if ([self.apiFuncName isEqualToString:@"getValidateCode"]||[self.apiFuncName isEqualToString:@"userRegister"]||[self.apiFuncName isEqualToString:@"userLogin"]||[self.apiFuncName isEqualToString:@"resetPassword"])
    {
        self.path = [NSString stringWithFormat:@"%@%@?",self.path,self.apiFuncName];
    }
    else
    {
        self.path = [NSString stringWithFormat:@"%@%@?token=%@",self.path,self.apiFuncName,[MTUserInfo Token]];
    }
    
    for (int i=0; i<[[dic allKeys] count]; i++)
    {
        NSString *keyStr = [[dic allKeys] objectAtIndex:i];
        NSString *valueStr = [dic objectForKey:keyStr];
        self.path = [NSString stringWithFormat:@"%@&%@=%@",self.path,keyStr,valueStr];
    }
    NSString *urlStr = [self.path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.request = [[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlStr]] autorelease];
    self.request.delegate = self;
    self.request.shouldAttemptPersistentConnection = NO;
    [self.request setTimeOutSeconds:20];
    [self.request setNumberOfTimesToRetryOnTimeout:1];
    [self.request setCompletionBlock:completionBlock];
    [self.request setFailedBlock:failedBlock];
    [self.request startAsynchronous];
}

- (void)uploadDataWithParameters:(LXParameterModel *)params
                 completionBlock:(HttpModelCompletionBlock)completionBlock
                     failedBlock:(HttpModelFailedBlock)failedBlock
{
    NSMutableDictionary *dic = [self convertParameters:params];
    self.path =[NSString stringWithFormat:@"%@/index.php/Index/",HOST_NAME];
    self.path = [NSString stringWithFormat:@"%@%@?token=%@&confirm=%@",self.path,self.apiFuncName,[MTUserInfo Token],params.confirm];
    NSString *urlStr = [self.path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIFormDataRequest *uploadRequest = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];

    UIImage *img = [dic objectForKey:@"image"];
    NSData *image = UIImageJPEGRepresentation(img, 1.0);
//  添加请求内容
    [uploadRequest setData:image withFileName:[NSString stringWithFormat:@"%d.jpg",arc4random()] andContentType:@"binary/octet-stream" forKey:@"file"];
//这里的value值 需与服务器端 一致
    [uploadRequest addRequestHeader:@"Content-Type" value:@"binary/octet-stream"];
    [uploadRequest setRequestMethod:@"POST"];
    [uploadRequest setCompletionBlock:completionBlock];
    [uploadRequest setFailedBlock:failedBlock];
    [uploadRequest buildPostBody];
    [uploadRequest setDelegate:self];
    [uploadRequest startAsynchronous];
    [uploadRequest release];
}

#pragma mark-
#pragma mark- ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    self.time = [NSDate date];
    YHLog(@"StartRequest!\nurl=%@,requestMethod=%@",request.url,request.requestMethod);
    if (request.retryCount!=0)
    {
        YHLog(@"Request retry! Count=%d",request.retryCount);
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
#if LXREQUEST_LOG_STATUS
    YHLog(@"DidReceiveResponseHeaders:\n%@",responseHeaders);
#endif
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    YHLog(@"RequestWillRedirectToURL:\n%@",newURL);
    [request redirectToURL:newURL];
}

- (void)requestRedirected:(ASIHTTPRequest *)request;
{
    YHLog(@"\n--------RequestRedirected--------");
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    YHLog(@"RequestFinished!");
    NSString *responseString = [request responseString];
//    //去除掉首尾的空白字符和换行字符
//    responseString = [responseString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    responseString = [responseString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (request.responseStatusCode==200)
    {
        if (!FBIsEmpty(responseString))
        {
#if LXREQUEST_LOG_STATUS
            YHLog(@"Get responseString!\nLength=%d responseString:\n%@",(int)[responseString length],responseString);
#endif
            self.dataDic = [responseString objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
            self.erorMessage = [_dataDic objectForKey:@"error_info"];
            self.erorCode = (int)[[_dataDic objectForKey:@"error_no"] integerValue];
            if (self.erorCode == 0)
            {
                self.isValid = YES;
#if LXREQUEST_LOG_STATUS
            YHLog(@"RequestSuccess!\npath=%@\nGet dataDic:\n%@\n",self.path,self.dataDic);
#endif
                if (!FBIsEmpty(self.dataDic))
                {
                    [self.resultModel setModelFromValue:[self.dataDic objectForKey:@"data"]];
                }
            }
            else
            {
                self.isValid = NO;
                
                //联线服务器返回错误代码
                if(self.erorCode == -1)
                {
                    YHLog(@"RequestConfirmError!!\npath=%@\nGet dataDic:%@\n",self.path,self.dataDic);
//                    if ([MTUserInfo defaultUserInfoAD].isLogin)
//                    {
//                        [[MTUserInfo defaultUserInfoAD] showAccountAlert];
//                    }
                }
                else
                {
                    YHLog(@"RequestError!!\npath=%@\nErrorCode=%d errorMessage == %@\ndataDic:\n%@\n",self.path,self.erorCode,self.erorMessage,self.dataDic);
                }
            }
            if ([[_dataDic allKeys] containsObject:@"token"])
            {
                self.token = [_dataDic objectForKey:@"token"];
                [MTUserInfo saveToken:self.token];
            }
        }
        else
        {
            YHLog(@"ResponseString=NULL!!");
        }
    }
    else
    {   //HTTP请求错误
        YHLog(@"HTTP ERROR!!\nError code=%d Error code=%@\n",request.responseStatusCode,request.responseStatusMessage);
        YHLog(@"\nGet responseString:%@\n",responseString);
        if (request.responseStatusCode==404)
        {
            [[[[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无数据!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease] show];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if ([LXUtils networkDetect])
    {
        YHLog(@"ASI请求失败!!requestID=%@",request.requestID);
        YHLog(@"\nrequest.url=%@\nrequest.originalURL=%@\n",request.url,request.originalURL);
        YHLog(@"RetryCount=%d request.error =\n%@",request.retryCount,request.error);
        YHLog(@"HTTP Error code=%d Error Message=%@\n",request.responseStatusCode,request.responseStatusMessage);
        if (request.retryCount==1)
        {
            //[_request cancel];
            //调用[request cancel];就可以进行取消正在进行的请求，取消时会触发请求失败的回调方法。如果在取消过程中不想触发该回调，可以将实例进行设置。如下：
            
            [request clearDelegatesAndCancel];
        }
        else
        {
            YHLog(@"测试fail retryCount");
        }
        
        //[self.request startAsynchronous];
        //UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:@"数据请求失败，是否重新请求？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil] autorelease];
        //[alert show];
    }
    else
    {
        [[[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络不太给力哦,请检查网络!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease] show];
    }
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //self.request.delegate =self;
        //[self.request startAsynchronous];
    }
    else
    {
        //FIXME: 这里需要补充或修改
    }
}
@end
