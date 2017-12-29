//
//  JLYHTTPSessionManager.h
//  JLYNetworking
//
//  Created by Allen on 2017/12/26.
//  Copyright © 2017年 jly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLYRequestTask.h"

typedef void(^JLYRequestCompletionHandler)(id responseObject, NSError *error);
typedef void(^JLYBatchRequestCompletionHandler)(NSArray <JLYRequestTask *> *tasks, NSError *error);

@interface JLYHTTPSessionManager : NSObject

+ (instancetype)shareManager;

- (void)sendGETRequestWithURLString:(NSString *)urlStr
                         parameters:(NSDictionary *)parameters
                  completionHandler:(JLYRequestCompletionHandler)completion;

- (void)sendPOSTRequestWithURLString:(NSString *)urlStr
                          parameters:(NSDictionary *)parameters
                   completionHandler:(JLYRequestCompletionHandler)completion;

@end
