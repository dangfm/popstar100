//
//  FMHttpRequest.m
//  FMMarket
//
//  Created by dangfm on 15/8/11.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "FMHttpRequest.h"


@implementation FMHttpRequest

#pragma mark - 网络状态
// 联网通知
+(void)checkInternetIsConnect{
    NSURL *baseURL = [NSURL URLWithString:@"http://www.baidu.com/"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 发送联网改变通知
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kFMReachabilityChangedNotification object:[NSNumber numberWithInt:status]];
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
        // 设置网络状态
     
    }];
    
    [manager.reachabilityManager startMonitoring];
}
//  从通知中心获取联网状态
+(AFNetworkReachabilityStatus)getNetStatusWithNotification:(NSNotification*)notification{
    AFNetworkReachabilityStatus status = [[notification object] intValue];
    return status;
}
//  加密参数
+(NSDictionary*)hashWithParams:(NSDictionary*)params{
    NSString *time = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970] ];
    NSMutableDictionary *newParams = [NSMutableDictionary new];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString *deviceId = [YunConfig getDeviceIDInKeychain];
    // 测试
    //deviceId = @"test12345678";
    NSString *deviceToken = [YunConfig get:kConfig_DeviceToken];
    if (!deviceToken) {
        deviceToken = @"";
    }
    if (!deviceId) {
        deviceId = @"";
    }
    NSString *umid = [UMConfigure umidString];
    if (!umid) {
        umid = @"";
    }
    [newDic setObject:[NSString stringWithFormat:@"%@",[YunConfig getUserId]]forKey:@"user_id"];
    [newDic setObject:deviceToken forKey:@"device_token"];
    [newDic setObject:kDeviceType forKey:@"device_type"];
    [newDic setObject:deviceId forKey:@"device_id"];
    [newDic setObject:[YunConfig idfa] forKey:@"idfa"];
    [newDic setObject:[YunConfig uuid] forKey:@"uuid"];
    [newDic setObject:umid forKey:@"umid"];
    [newDic setObject:[YunConfig getUserToken] forKey:@"token"];
    [newDic setObject:[fn getVersion] forKey:@"v"];
    [newDic setObject:time forKey:@"timestamp"];
    NSArray *keys = newDic.allKeys;
    keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    
    NSString *hashStr = @"";
    NSString *paramStr = @"";
    for (NSString *key in keys) {
        id value = [newDic objectForKey:key];
        if (value && ![value isEqual:[NSNull null]]) {
            if ([value isEqualToString:@""]) {
                continue;
            }
            //hashStr = [hashStr stringByAppendingString:[NSString stringWithFormat:@"%@",value]];
            if ([paramStr isEqualToString:@""]) {
                paramStr = [NSString stringWithFormat:@"%@=%@",key,value];
            }else{
                paramStr = [NSString stringWithFormat:@"%@&%@=%@",paramStr,key,value];
            }
            [newParams setObject:value forKey:key];
        }
        
    }
    
    //    hashStr = [hashStr stringByAppendingString:[NSString stringWithFormat:@"%@",[fn getVersion]]];
    //    hashStr = [hashStr stringByAppendingString:[NSString stringWithFormat:@"%@",[FMUserDefault getUserId]]];
    //hashStr = [hashStr stringByAppendingString:[NSString stringWithFormat:@"%@",time]];
    hashStr = [paramStr stringByAppendingString:[NSString stringWithFormat:@"&key=%@",kAPI_Key]];
    
    
    // 加密
    NSString *auth = [fn md5:hashStr];
    auth = [auth uppercaseString];
    //NSLog(@"%@=%@",hashStr,auth);
    
    [newParams setObject:auth forKey:@"sign"];
    
    //paramStr = [NSString stringWithFormat:@"%@&%@=%@",paramStr,@"timestamp",time];
    paramStr = [NSString stringWithFormat:@"?%@&%@=%@",paramStr,@"sign",auth];
    //NSLog(@"%@",paramStr);
    [AppDelegate sharedSingleton].urlParams = paramStr;
    return newParams;
}

// 被迫下线
+(void)mustLogoutWithResult:(NSDictionary*)dic{
    if (![[YunConfig getUserToken] isEqualToString:@""]) {
        if ([[dic class]isSubclassOfClass:[NSDictionary class]]) {
            NSString *error = [NSString stringWithFormat:@"%@",dic[@"error"]];
            if ([[error class]isSubclassOfClass:[NSString class]]) {
                if ([error intValue]==kMustLogoutErrorCode) {
                    // 被迫退出登录
                    [YunConfig logout];
                    [fn showMessage:@"您已被下线" Title:@"温馨提示" timeout:3];
                }
            }
        }
    }
    
}

#pragma mark - HTTP Request

+(AFHTTPSessionManager*)request:(NSString*)url{
    NSURL *URL = [NSURL URLWithString:url];
    //NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPSessionManager *op = [[AFHTTPSessionManager alloc] initWithBaseURL:URL];
    op.responseSerializer = [AFHTTPResponseSerializer serializer];
    return op;
}
+(AFHTTPSessionManager*)requestManager{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain",nil];
//    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    manager.requestSerializer.stringEncoding = gbkEncoding;
    manager.requestSerializer.timeoutInterval = 30;
    
    
    return manager;
}

/// 公共POST请求
/// @param params 参数
/// @param apiUrl api接口
+(void)sendPostRequestWithParams:(NSDictionary*)params api:(NSString*)apiUrl start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success{
    AFHTTPSessionManager *manager = [self requestManager];
    // 开始请求
    startBlock();
    [manager POST:apiUrl
      parameters:[self hashWithParams:params]
         headers:nil
constructingBodyWithBlock:nil
         progress:nil
         success:^(NSURLSessionTask *operation,id responseObj){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             NSDictionary *dic = (NSDictionary*)responseObj;
             if ([[dic class] isSubclassOfClass:[NSDictionary class]]) {
                 // 回调数据
                 success(dic);
             }else{
                 failBlock();
             }
             [http mustLogoutWithResult:responseObj];
         }
         failure:^(NSURLSessionTask* operation,NSError *error){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             failBlock();
         }];
}

// 保存广告记录
+(void)sendApiUserAd:(NSString*)intro type:(int)type ad:(NSString*)ad start_time:(NSString*)start_time end_time:(NSString*)end_time requestid:(long)requestid{
    int passNumber = [YunConfig getUserPassNumber];
    NSDictionary *p = @{
        @"levels":@(passNumber).stringValue,
        @"type":@(type).stringValue,
        @"ad":ad,
        @"intro":intro,
        @"start_time":start_time,
        @"end_time":end_time,
        @"requestid":@(requestid).stringValue
    };
    WEAKSELF
    [http sendPostRequestWithParams:p api:kAPI_Users_AddAd start:^{
        
    } failure:^{
        NSLog(@"保存广告记录失败，网络不给力");
        [fn sleepSeconds:5 finishBlock:^{
            [__weakSelf sendApiUserAd:intro type:type ad:ad start_time:start_time end_time:end_time requestid:requestid];
        }];
    } success:^(NSDictionary *dic) {
        NSLog(@"保存广告记录 %@",dic);
    }];
}
// 保存金币流水
+(void)sendApiUserGold:(NSString*)intro type:(int)type gold:(int)gold{
    int passNumber = [YunConfig getUserPassNumber];
    long requestid = [fn getTimestamp];
    NSDictionary *p = @{
        @"levels":@(passNumber).stringValue,
        @"type":@(type).stringValue,
        @"gold":@(gold).stringValue,
        @"intro":intro,
        @"total_gold":@([YunConfig getUserGold]).stringValue,
        @"requestid":@(requestid).stringValue
    };
    WEAKSELF
    [http sendPostRequestWithParams:p api:kAPI_Users_AddGold start:^{
        
    } failure:^{
        NSLog(@"保存金币流水失败，网络不给力");
        [fn sleepSeconds:5 finishBlock:^{
            [__weakSelf sendApiUserGold:intro type:type gold:gold];
        }];
    } success:^(NSDictionary *dic) {
        NSLog(@"保存金币流水 %@",dic);
    }];
}

// 保存红包流水
+(void)sendApiUserRedEnvelope:(NSString*)intro type:(int)type{
    int passNumber = [YunConfig getUserPassNumber];
    long requestid = [fn getTimestamp];
    NSDictionary *p = @{
        @"levels":@(passNumber).stringValue,
        @"type":@(type).stringValue,
        @"intro":intro,
        @"requestid":@(requestid).stringValue
    };
    WEAKSELF
    [http sendPostRequestWithParams:p api:kAPI_Users_AddGold start:^{
        
    } failure:^{
        NSLog(@"保存红包流水失败，网络不给力");
        [fn sleepSeconds:5 finishBlock:^{
            [__weakSelf sendApiUserRedEnvelope:intro type:type];
        }];
    } success:^(NSDictionary *dic) {
        NSLog(@"保存红包流水 %@",dic);
    }];
}
// 更新关卡回放的gif图片
+(void)uploadLevelsGifWithImageFile:(NSString*)gifpath params:(NSDictionary*)params start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success{
    AFHTTPSessionManager *manager = [self requestManager];
    manager.requestSerializer.timeoutInterval = 60;
    // 开始请求
    startBlock();
    [manager POST:kAPI_Users_LevelsGif parameters:[self hashWithParams:params] headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSError *error;
        
        NSString *fileName = [NSString stringWithFormat:@"%.f.gif",[fn getTimestamp]];
        NSData *data = [NSData dataWithContentsOfFile:gifpath];
//        data = [UIImage zipGIFWithData:data duration:0.6 per:0.5];
        NSLog(@"%@",[fn transformedValue:data]);
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/gif"];
        //[formData appendPartWithFileURL:[NSURL URLWithString:gifpath] name:@"file" fileName:fileName mimeType:@"image/gif" error:&error];
        
        NSLog(@"%@",error);
    }
    progress:nil
         success:^(NSURLSessionTask *operation,id responseObj){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
            NSDictionary *dic = (NSDictionary*)responseObj;
            if ([[dic class] isSubclassOfClass:[NSDictionary class]]) {
                // 回调数据
                success(dic);
            }else{
                failBlock();
            }
            [http mustLogoutWithResult:responseObj];
    }
    failure:^(NSURLSessionTask* operation,NSError *error){
        failBlock();
    }];
}

#pragma mark -
#pragma mark 用户中心
+(void)autologinWithStart:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success{
    AFHTTPSessionManager *manager = [self requestManager];
    // 开始请求
    startBlock();
    [manager POST:kAPI_Users_UserAutoLogin
      parameters:[self hashWithParams:nil]
         headers:nil
constructingBodyWithBlock:nil
         progress:nil
         success:^(NSURLSessionTask *operation,id responseObj){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             NSDictionary *dic = (NSDictionary*)responseObj;
             if ([[dic class] isSubclassOfClass:[NSDictionary class]]) {
                 // 回调数据
                 success(dic);
             }else{
                 failBlock();
             }
             [http mustLogoutWithResult:responseObj];
         }
         failure:^(NSURLSessionTask* operation,NSError *error){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             failBlock();
         }];
}
+(void)sendSMSWithTel:(NSString *)tel start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success{
    AFHTTPSessionManager *manager = [self requestManager];
    // 开始请求
    startBlock();
    [manager POST:kAPI_Users_UserSendSMS
      parameters:[self hashWithParams:@{@"tel":tel}]
         headers:nil
constructingBodyWithBlock:nil
         progress:nil
         success:^(NSURLSessionTask *operation,id responseObj){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             NSDictionary *dic = (NSDictionary*)responseObj;
             if ([[dic class] isSubclassOfClass:[NSDictionary class]]) {
                 // 回调数据
                 success(dic);
             }else{
                 failBlock();
             }
             [http mustLogoutWithResult:responseObj];
         }
         failure:^(NSURLSessionTask* operation,NSError *error){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             failBlock();
         }];
}

+(void)sendUserRegisterWithTel:(NSString *)tel password:(NSString *)password code:(NSString *)code start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success{
    AFHTTPSessionManager *manager = [self requestManager];
    // 开始请求
    startBlock();
    [manager POST:kAPI_Users_UserRegister
      parameters:[self hashWithParams:@{
                                        @"tel":tel,
                                        @"password":password,
                                        @"code":code,
                                        }]
     headers:nil
     constructingBodyWithBlock:nil
         progress:nil
         success:^(NSURLSessionTask *operation,id responseObj){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             NSDictionary *dic = (NSDictionary*)responseObj;
             if ([[dic class] isSubclassOfClass:[NSDictionary class]]) {
                 // 回调数据
                 success(dic);
             }else{
                 failBlock();
             }
             [http mustLogoutWithResult:responseObj];
         }
         failure:^(NSURLSessionTask* operation,NSError *error){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             failBlock();
         }];
}

+(void)sendUserLoginWithTel:(NSString *)tel password:(NSString *)password start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success{
    AFHTTPSessionManager *manager = [self requestManager];
    // 开始请求
    startBlock();
    [manager POST:kAPI_Users_UserLogin
       parameters:[self hashWithParams:@{
                                         @"tel":tel,
                                         @"password":password,
                                         }]
     headers:nil
     constructingBodyWithBlock:nil
          progress:nil
         success:^(NSURLSessionTask *operation,id responseObj){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
              NSDictionary *dic = (NSDictionary*)responseObj;
              if ([[dic class] isSubclassOfClass:[NSDictionary class]]) {
                  // 回调数据
                  success(dic);
              }else{
                  failBlock();
              }
              [http mustLogoutWithResult:responseObj];
          }
          failure:^(NSURLSessionTask* operation,NSError *error){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
              failBlock();
          }];
}



+(void)updateUserLoginWithTel:(NSString *)tel start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success{
    AFHTTPSessionManager *manager = [self requestManager];
    // 开始请求
    startBlock();
    [manager POST:kAPI_Users_UserLogin
       parameters:[self hashWithParams:@{
                                         @"tel":tel
                                         }]
     headers:nil
     constructingBodyWithBlock:nil
          progress:nil
         success:^(NSURLSessionTask *operation,id responseObj){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
              NSDictionary *dic = (NSDictionary*)responseObj;
              if ([[dic class] isSubclassOfClass:[NSDictionary class]]) {
                  // 回调数据
                  success(dic);
              }else{
                  failBlock();
              }
              [http mustLogoutWithResult:responseObj];
          }
          failure:^(NSURLSessionTask* operation,NSError *error){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
              failBlock();
          }];
}



+(void)updateNickName:(NSString *)nickName start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success{
    AFHTTPSessionManager *manager = [self requestManager];
    // 开始请求
    startBlock();
    [manager POST:kAPI_Users_UserNickName
       parameters:[self hashWithParams:@{
                                         @"nickName":nickName
                                         }]
     headers:nil
     constructingBodyWithBlock:nil
          progress:nil
         success:^(NSURLSessionTask *operation,id responseObj){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
              NSDictionary *dic = (NSDictionary*)responseObj;
              if ([[dic class] isSubclassOfClass:[NSDictionary class]]) {
                  // 回调数据
                  success(dic);
              }else{
                  failBlock();
              }
              [http mustLogoutWithResult:responseObj];
          }
          failure:^(NSURLSessionTask* operation,NSError *error){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
              failBlock();
          }];
}


+(void)uploadUserFaceWithImage:(UIImage*)image start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success{
    AFHTTPSessionManager *manager = [self requestManager];
    // 开始请求
    startBlock();
    [manager POST:kAPI_Users_UserUploadFace parameters:[self hashWithParams:nil] headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(image, 0.8f);
        NSString *fileName = [NSString stringWithFormat:@"%f.jpg",[fn getTimestamp]];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        data = nil;
        fileName = nil;
        
    }
    progress:nil
         success:^(NSURLSessionTask *operation,id responseObj){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
        NSDictionary *dic = (NSDictionary*)responseObj;
        if ([[dic class] isSubclassOfClass:[NSDictionary class]]) {
            // 回调数据
            success(dic);
        }else{
            failBlock();
        }
        [http mustLogoutWithResult:responseObj];
    }
    failure:^(NSURLSessionTask* operation,NSError *error){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
        failBlock();
    }];
}



+(void)getUserInfoWithStart:(void (^__strong)(void))startBlock failure:(void (^__strong)(void))failBlock success:(requestSuccessBlock)success{
    AFHTTPSessionManager *manager = [self requestManager];
    // 开始请求
    startBlock();
    [manager GET:kAPI_Users_UserInfo
      parameters:[self hashWithParams:nil]
     headers:nil
    
         progress:nil
         success:^(NSURLSessionTask *operation,id responseObj){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             NSDictionary *data = (NSDictionary*)responseObj;
             if ([[NSDictionary class] isSubclassOfClass:[NSDictionary class]]) {
                 // 回调数据
                 success(data);
             }else{
                 failBlock();
             }
             [http mustLogoutWithResult:responseObj];
         }
         failure:^(NSURLSessionTask* operation,NSError *error){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             failBlock();
         }];
}





#pragma mark - 首页快捷按钮

+(void)getShortcutWithStart:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success{
    AFHTTPSessionManager *manager = [self requestManager];
    // 开始请求
    startBlock();
    [manager GET:kAPI_Shortcut
      parameters:[self hashWithParams:nil]
     headers:nil
    
         progress:nil
         success:^(NSURLSessionTask *operation,id responseObj){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             NSDictionary *data = (NSDictionary*)responseObj;
             if (data && ![data isEqual:[NSNull null]]) {
                 // 回调数据
                 success(data);
             }else{
                 failBlock();
             }
             [http mustLogoutWithResult:responseObj];
         }
         failure:^(NSURLSessionTask* operation,NSError *error){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             failBlock();
         }];
}


#pragma mark -
#pragma mark 远程配置
+(void)getServerConfigWithStart:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success{
    AFHTTPSessionManager *manager = [self requestManager];
    [manager.operationQueue waitUntilAllOperationsAreFinished];
    [manager POST:kAPI_Config
      parameters:[self hashWithParams:nil]
          headers:nil
         progress:nil
         success:^(NSURLSessionTask *operation,id responseObj){
            NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             NSDictionary *data = (NSDictionary*)responseObj;
             if (data && ![data isEqual:[NSNull null]]) {
                 data = data[@"data"];
                 if ([[data class] isSubclassOfClass:[NSDictionary class]]) {
                     [YunConfig seting:kConfig_ServerDatas value:[data mj_JSONString]];
                     success(data);
                     return ;
                 }
             }
            failBlock();
            [http mustLogoutWithResult:responseObj];
         }
         failure:^(NSURLSessionTask* operation,NSError *error){
             NSLog(@"%@%@",operation.currentRequest.URL,[AppDelegate sharedSingleton].urlParams);
             failBlock();
         }];
}



@end
