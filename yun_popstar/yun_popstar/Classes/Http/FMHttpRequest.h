//
//  FMHttpRequest.h
//  FMMarket
//
//  Created by dangfm on 15/8/11.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^requestSuccessBlock)(NSDictionary* dic);


/// <#Description#>
@interface FMHttpRequest : NSObject
#pragma mark - 网络状态
// 联网通知
+(void)checkInternetIsConnect;

//  从通知中心获取联网状态
+(AFNetworkReachabilityStatus)getNetStatusWithNotification:(NSNotification*)notification;

+(AFHTTPSessionManager*)requestManager;
#pragma mark - HTTP Request
//  检查是否更新搜索数据 
// +(void)isUpdateSearchStocks;

/// 公共POST请求
/// @param params 参数
/// @param apiUrl api接口
+(void)sendPostRequestWithParams:(NSDictionary*)params api:(NSString*)apiUrl start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success;


/// 保存广告记录
/// @param intro 描述
/// @param type 类型
/// @param ad 广告ID
/// @param start_time 开始时间
/// @param end_time 结束时间
+(void)sendApiUserAd:(NSString*)intro type:(int)type ad:(NSString*)ad start_time:(NSString*)start_time end_time:(NSString*)end_time requestid:(long)requestid;

// 保存金币流水
+(void)sendApiUserGold:(NSString*)intro type:(int)type gold:(int)gold;
// 保存红包流水
+(void)sendApiUserRedEnvelope:(NSString*)intro type:(int)type;
// 更新关卡回放gif图片
+(void)uploadLevelsGifWithImageFile:(NSString*)gifpath params:(NSDictionary*)params start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success;
#pragma mark -
#pragma mark 用户中心

/// 自动登录
+(void)autologinWithStart:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success;
/**
 *  发送短信验证码
 *
 *  @param tel        手机号
 *  @param startBlock 开始回调
 *  @param failBlock  失败回调
 *  @param success    成功回调
 */
+(void)sendSMSWithTel:(NSString*)tel start:(void(^)(void))startBlock failure:(void(^)(void))failBlock success:(requestSuccessBlock)success;

/**
 *  提交注册会员
 *
 *  @param tel        手机号码
 *  @param password   密码
 *  @param code       短信验证码
 *  @param startBlock 开始回调
 *  @param failBlock  失败回调
 *  @param success    成功回调
 */
+(void)sendUserRegisterWithTel:(NSString*)tel password:(NSString*)password code:(NSString*)code start:(void(^)(void))startBlock failure:(void(^)(void))failBlock success:(requestSuccessBlock)success;

/**
 *  用户登陆
 *
 *  @param tel        手机号码
 *  @param password   密码
 *  @param startBlock 开始回调
 *  @param failBlock  失败回调
 *  @param success    成功回调
 */
+(void)sendUserLoginWithTel:(NSString *)tel password:(NSString *)password start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success;

+(void)updateUserLoginWithTel:(NSString *)tel start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success;


/**
 *  忘记密码
 *
 *  @param tel        手机号
 *  @param password   重置密码
 *  @param code       短信验证码
 *  @param startBlock 开始回调
 *  @param failBlock  失败回调
 *  @param success    成功回调
 */
+(void)sendChangePasswordWithTel:(NSString *)tel password:(NSString *)password code:(NSString *)code start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success;


/**
 *  编辑昵称
 *
 *  @param nickName   新昵称
 */
+(void)updateNickName:(NSString *)nickName start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success;

/**
 *  上传头像
 */
+(void)uploadUserFaceWithImage:(UIImage*)image start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success;



/**
 *  绑定用户手机号
 *
 *  @param tel        手机号码
 *  @param password   密码
 *  @param code       验证码
 */
+(void)sendJoinMobileWithTel:(NSString*)tel password:(NSString*)password code:(NSString*)code Start:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success;

/**
 *  获取用户资料
 *
 */
+(void)getUserInfoWithStart:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success;


#pragma mark -
#pragma mark 首页幻灯片快捷按钮

/**
 *  请求快捷按钮
 */
+(void)getShortcutWithStart:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success;

#pragma mark -
#pragma mark 远程配置
+(void)getServerConfigWithStart:(void (^)(void))startBlock failure:(void (^)(void))failBlock success:(requestSuccessBlock)success;

@end
