//
//  LXHttpModel.h
//  CMY_iPhone
//
//  Created by Bird on 13-12-9.
//  Copyright (c) 2013年 Iceland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "LXResultModel.h"
#import "LXParameterModel.h"

typedef void (^HttpModelCompletionBlock) ();
typedef void (^HttpModelFailedBlock) ();

@interface LXHttpModel : NSObject

/**
 * path for http api
 */
@property (nonatomic, copy) NSString* path;

/**
 * method for this api
 *
 * 必须大写， GET POST PUT DELETE
 *
 * default method id 'GET'
 */
@property (nonatomic, copy) NSString *method;


/**
 * http client name
 *
 * default is 'nil'
 */
@property (nonatomic, copy) NSString *apiFuncName;

/**
 *
 * ASIHttpRequest
 *
 */
@property (nonatomic, retain) ASIHTTPRequest *request;

/**
 *
 * 返回结果model
 *
 */
@property (nonatomic, retain) LXResultModel *resultModel;


/**
 *
 * 返回结果字典
 *
 */
@property (nonatomic, retain) NSMutableDictionary *dataDic;

/**
 *
 * token
 *
 */
@property (nonatomic, copy) NSString *token;

/**
 *
 * 错误代码
 *
 */
@property (nonatomic, assign) int erorCode;

/**
 *
 * 请求失败的错误信息
 *
 */
@property (nonatomic, copy) NSString *erorMessage;

/**
 *
 * 请求是否成功的标示
 *
 */
@property (nonatomic, assign) BOOL isValid;

/**
 * cache response data
 *
 * default is NO
 */
@property(nonatomic, assign) BOOL useCache;

/**
 * use cache when get data from server failed
 *
 * default is YES, if useCache is NO
 */
@property(nonatomic, assign) BOOL useCacheAfterGetFailed;

- (void)getDataWithParameters:(LXParameterModel *)params
              completionBlock:(HttpModelCompletionBlock)completionBlock
                  failedBlock:(HttpModelFailedBlock)failedBlock;

- (void)uploadDataWithParameters:(LXParameterModel *)params
                 completionBlock:(HttpModelCompletionBlock)completionBlock
                     failedBlock:(HttpModelFailedBlock)failedBlock;

@end
