//
//  JLYHTTPSessionManager.m
//  JLYNetworking
//
//  Created by Allen on 2017/12/26.
//  Copyright © 2017年 jly. All rights reserved.
//

#import "JLYHTTPSessionManager.h"
#import "AFNetworking.h"

static const char *kRequestConcurrentQueue = "com.jly.requestConcurrentQueue";

@interface JLYHTTPSessionManager ()

@property (nonatomic, strong) AFHTTPSessionManager *afSessionManager;
@property (nonatomic, strong) dispatch_queue_t requestConcurrentQueue;

@end

@implementation JLYHTTPSessionManager

+ (instancetype)shareManager {
    static JLYHTTPSessionManager *_shareManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManger = [[JLYHTTPSessionManager alloc] init];
    });
    return _shareManger;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestConcurrentQueue = dispatch_queue_create(kRequestConcurrentQueue, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)sendGETRequestWithURLString:(NSString *)urlStr
                      parameters:(NSDictionary *)parameters
               completionHandler:(JLYRequestCompletionHandler)completion {
    [self sendRequestWithMethod:JLYRequestMethod_GET urlString:urlStr parameters:parameters completionHandler:completion];
}

- (void)sendPOSTRequestWithURLString:(NSString *)urlStr
                       parameters:(NSDictionary *)parameters
                completionHandler:(JLYRequestCompletionHandler)completion {
    [self sendRequestWithMethod:JLYRequestMethod_POST urlString:urlStr parameters:parameters completionHandler:completion];
}

- (void)sendBatchRequestWithTasks:(NSArray <JLYRequestTask *> *)tasks
                completionHandler:(JLYBatchRequestCompletionHandler)completion {

    dispatch_async(self.requestConcurrentQueue, ^{
        
    });
    [tasks enumerateObjectsUsingBlock:^(JLYRequestTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
}

- (void)sendRequestWithMethod:(JLYRequestMethod)method
                    urlString:(NSString *)urlStr
                   parameters:(NSDictionary *)parameters
            completionHandler:(JLYRequestCompletionHandler)completion {
    
    if (!urlStr.length) {
        return;
    }
    
    if (!completion) {
        return;
    }

    if (!method) {
        method = JLYRequestMethod_GET;
    }
    
    switch (method) {
        case JLYRequestMethod_GET:
            [self afSendGETRequestWithURL:urlStr parameters:parameters completionHandler:completion];
            break;
            
        case JLYRequestMethod_POST:
            [self afSendPOSTRequestWithURL:urlStr parameters:parameters completionHandler:completion];
            break;
            
        default:
            break;
    }
}

#pragma mark - afSendRequest
- (void)afSendGETRequestWithURL:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
              completionHandler:(JLYRequestCompletionHandler)completion {
    [self.afSessionManager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)afSendPOSTRequestWithURL:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
               completionHandler:(JLYRequestCompletionHandler)completion {
    [self.afSessionManager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

#pragma mark - getter
- (AFHTTPSessionManager *)afSessionManager {
    if (_afSessionManager == nil) {
        _afSessionManager = [[AFHTTPSessionManager alloc] init];
    }
    return _afSessionManager;
}

@end
