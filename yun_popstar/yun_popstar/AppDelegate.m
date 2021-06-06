//
//  AppDelegate.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/3.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "AppDelegate.h"
#import "YunStartViewViewController.h"

@interface AppDelegate ()<BUSplashAdDelegate,UNUserNotificationCenterDelegate,BUNativeExpressSplashViewDelegate>

@end

@implementation AppDelegate

// 跟上面的方法实现有一点不同
+ (AppDelegate*)sharedSingleton {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    //[SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    // 配置初始化
    [YunConfig defaultValue];
    
    // 巨量初始化
    [self juliangInit];
    
    // 穿山甲初始化
    [BUAdSDKManager setAppID:kChuanshanjia_AppId];
    [BUAdSDKManager setIsPaidApp:NO];
    //[BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
    // 友盟初始化
    [UMConfigure initWithAppkey:kUmeng_AppKey channel:@"App Store"];
    [UMConfigure setLogEnabled:YES];
    // U-Share 平台设置
    [self confitUShareSettings];
    [self configUSharePlatforms];
    // 友盟推送
    [self umentpush:launchOptions];
    
    //[UMConfigure setLogEnabled:YES];
    NSLog(@"umid:%@",[UMConfigure umidString]);
    // 远程配置
    [self getServerConfig];
    // 自动登录
    [self userAutoLogin];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = [[UINavigationController alloc] init];
    [nav addChildViewController:[[YunStartViewViewController alloc] init]];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    if ([YunConfig isAgreePrivacy]) {
        YunConfig *config = [YunConfig getConfig];
        if (config) {
            if([config.open_ads indexOf:kCsj_sloteid_887373369]!=NSNotFound){
                // 开屏广告
                [self showOpenAd];
            }
        }else{
            [self showOpenAd];
        }
    }
    
    
    return YES;
}

// 巨量
-(void)juliangInit{
    /* 初始化开始 */
//    BDAutoTrackConfig *config = [BDAutoTrackConfig new];
//
//    /* 域名默认国内: BDAutoTrackServiceVendorCN,
//       新加坡: BDAutoTrackServiceVendorSG,
//       美东:BDAutoTrackServiceVendorVA,
//       注意：国内外不同vendor服务注册的did不一样。由CN切换到SG或者VA，会发生变化，切回来也会发生变化。因此vendor的切换一定要慎重，随意切换导致用户新增和统计的问题，需要自行评估。*/
//    config.serviceVendor = BDAutoTrackServiceVendorCN;
//
//    config.appID = @"198112"; // 广告后台申请，工具-转化跟踪-跟踪应用-使用sdk
//    config.appName = @"fangyun_popstar01"; // 与您申请app ID时的app_name一致
//    config.channel = @"App Store"; // iOS一般默认App Store
//
//    config.showDebugLog = YES; // 是否在控制台输出日志，仅调试使用。release版本请设置为 NO
//    config.logNeedEncrypt = YES; // 是否加密日志，默认加密。release版本请设置为 YES
//    // 游戏模式，YES会开始 playSession 上报，每隔一分钟上报心跳日志
//    config.gameModeEnable = YES;
//
//    [BDAutoTrack startTrackWithConfig:config];
    /* 初始化结束 */

    /* 自定义 “用户公共属性”（可选，初始化后调用, key相同会覆盖）
      关于自定义 “用户公共属性” 请注意：1. 上报机制是随着每一次日志发送进行提交，默认的日志发送频率是1分钟，所以如果在一分钟内连续修改自定义用户公共属性，，按照日志发送前的最后一次修改为准， 2. 不推荐高频次修改，如每秒修改一次 */
//    [BDAutoTrack setCustomHeaderBlock:^NSDictionary<NSString *,id> * _Nonnull{
//      return @{@"gender":@"female"};
//    }];
}

- (void)confitUShareSettings
{
    
    [[UMSocialManager defaultManager] openLog:YES];

    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    //配置微信平台的Universal Links
    //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):@"https://app.api.popstar100.com/app/",
                                                        @(UMSocialPlatformType_WechatTimeLine):@"https:///app.api.popstar100.com/app/"
                                                        };

}
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWechat_AppId appSecret:kWechat_AppSecret redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:kWechat_AppId appSecret:kWechat_AppSecret redirectURL:nil];
  
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        //return YES;
    }
    return result;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
         // 其他如支付等SDK的回调
    }
    return result;
}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    
    if (![[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil]) {
        // 其他SDK的回调
    }
    return YES;
}

-(void)showOpenAd{
    [MobClick beginEvent:@"App_Start_Ad"];
    // 无模版模式
    CGRect frame = [UIScreen mainScreen].bounds;
    BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:kCsj_sloteid_887373369 frame:frame];
    splashView.delegate = self;
    UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
    [splashView loadAdData];
    [keyWindow.rootViewController.view addSubview:splashView];
    splashView.rootViewController = keyWindow.rootViewController;
    // 模版渲染模式
//    CGSize size = CGSizeMake(UIScreenWidth, UIScreenHeight-100);
//    UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
//    BUNativeExpressSplashView *splashView = [[BUNativeExpressSplashView alloc] initWithSlotID:kCsj_sloteid_887373369 adSize:size rootViewController:keyWindow.rootViewController];
//    splashView.delegate = self;
//    [splashView loadAdData];
//    [keyWindow.rootViewController.view addSubview:splashView];
}
// 开屏广告关闭
- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    [MobClick endEvent:@"App_Start_Ad"];
    [splashAd removeFromSuperview];
}
// 点击开屏广告
-(void)splashAdDidClick:(BUSplashAdView *)splashAd{
   
}
// 开屏广告模版渲染代理
- (void)nativeExpressSplashView:(nonnull BUNativeExpressSplashView *)splashAdView didFailWithError:(NSError * _Nullable)error {
    [splashAdView removeSplashView];//记得在remove广告视图前调用remove方法，否则可能出现倒计时有问题或者视频播放有问题
    [splashAdView removeFromSuperview];
    NSLog(@"%s",__func__);
}

- (void)nativeExpressSplashViewRenderFail:(nonnull BUNativeExpressSplashView *)splashAdView error:(NSError * _Nullable)error {
    [splashAdView removeSplashView];//记得在remove广告视图前调用remove方法，否则可能出现倒计时有问题或者视频播放有问题
    [splashAdView removeFromSuperview];
    NSLog(@"%s",__func__);
}

- (void)nativeExpressSplashViewDidClose:(nonnull BUNativeExpressSplashView *)splashAdView {
    [splashAdView removeSplashView];//记得在remove广告视图前调用remove方法，否则可能出现倒计时有问题或者视频播放有问题
    [splashAdView removeFromSuperview];
    NSLog(@"%s",__func__);
}


// 远程配置
-(void)getServerConfig{
    
    WEAKSELF
    [http getServerConfigWithStart:^{
        
    } failure:^{
        // 获取配置失败
        [fn sleepSeconds:3 finishBlock:^{
            [__weakSelf getServerConfig];
        }];
    } success:^(NSDictionary *dic) {
        YunConfig *config = [YunConfig getConfig];
        if (config) {
            // 红包开关
            NSArray *r = [config.is_open_redenvelope mj_JSONObject];
            NSString *version = [fn getVersion];
            for (NSString *v in r) {
                if ([v isEqualToString:version]) {
                    [YunConfig setUserIsOpenRedEnvelope:YES];
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GetConfigSuccess object:nil];
            
        }
        
        // 继续获取配置
        [fn sleepSeconds:60 finishBlock:^{
            [__weakSelf getServerConfig];
        }];
    }];
}
// 自动登录
-(void)userAutoLogin{
    self.isDownloadUserInfo = NO;
    WEAKSELF
    [http autologinWithStart:^{
        
    } failure:^{
        
        // 自动登录失败继续
        [fn sleepSeconds:3 finishBlock:^{
            [__weakSelf userAutoLogin];
        }];
        
    } success:^(NSDictionary *dic) {
        int code = [dic[@"code"] intValue];
        NSDictionary *data = dic[@"data"];
        if (code==200 && data) {
            __weakSelf.isDownloadUserInfo = YES;
            NSDictionary *user = data[@"user"];
            NSString *token = data[@"token"];
            [YunConfig setUserId:[NSString stringWithFormat:@"%@",user[@"id"]]];
            [YunConfig setUserToken:token];
            if (user) {
                user = [fn checkNullWithDictionary:user];
                NSLog(@"%@",user);
                [YunConfig setUserInfoWithData:user];
            }
            // 内置事件: “注册” ， 属性：注册方式，是否成功，属性值为：wechat ，YES
            //[BDAutoTrack registerEventByMethod:@"autologin" isSuccess:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_UserLoginSuccess object:nil];
        }else{
            FMHttpShowError(dic)
        }
    }];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 暂停背景音乐
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_applicationDidEnterBackground object:nil];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 暂停背景音乐
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_applicationWillEnterForeground object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// 友盟推送
-(void)umentpush:(NSDictionary *)launchOptions{
   [UMessage openDebugMode:YES];
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
    
        }else{
        }
    }];
    
    
//    //添加开屏消息
//    +(void)addLaunchMessage;
//    //添加插屏消息
//    +(void)addCardMessageWithLabel:(NSString* __nonnull)label;
//    //添加自定义插屏消息
//    +(void)addCustomCardMessageWithPortraitSize:(CGSize )portraitsize LandscapeSize:(CGSize )landscapesize CloseBtn:(UIButton *_Nullable)button  Label:(NSString *_Nonnull)label umCustomCloseButtonDisplayMode:(BOOL )displaymode;
//    //添加文本插屏消息
//    +(void)addPlainTextCardMessageWithTitleFont:(UIFont *_Nullable)titlefont ContentFont:(UIFont *_Nullable)contentfont buttonFont:(UIFont *_Nullable)buttonfont Label:(NSString*_Nonnull)label;
//    //设置插屏消息的模式
//    +(void)openDebugMode:(BOOL)debugmode;
//    //设置插屏消息点击跳转的url
//    +(void)setWebViewController:(UIViewController *_Nonnull)webViewController;
    
    //[UMessage addCardMessageWithLabel:@"首页插屏"];
    //[UMessage addPlainTextCardMessageWithTitleFont:kFontBold(18) ContentFont:kFont(14) buttonFont:kFont(14) Label:@"首页自定义文本插屏"];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (!deviceToken || ![deviceToken isKindOfClass:[NSData class]] || deviceToken.length==0) {
        return;
    }
    NSString *(^getDeviceToken)(void) = ^() {
        if (@available(iOS 13.0, *)) {
            const unsigned char *dataBuffer = (const unsigned char *)deviceToken.bytes;
            NSMutableString *myToken  = [NSMutableString stringWithCapacity:(deviceToken.length * 2)];
            for (int i = 0; i < deviceToken.length; i++) {
                [myToken appendFormat:@"%02x", dataBuffer[i]];
            }
            return (NSString *)[myToken copy];
        } else {
            NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
            NSString *myToken = [[deviceToken description] stringByTrimmingCharactersInSet:characterSet];
            return [myToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    };
    NSString *myToken = getDeviceToken();
    [YunConfig seting:kConfig_DeviceToken value:myToken];
    NSLog(@"%@", myToken);
}

//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    
    //过滤掉Push的撤销功能，因为PushSDK内部已经调用的completionHandler(UIBackgroundFetchResultNewData)，
    //防止两次调用completionHandler引起崩溃
    if(![userInfo valueForKeyPath:@"aps.recall"])
    {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
    NSLog(@"%@",userInfo);
    [self parsingPushUserInfo:userInfo];
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于后台时的本地推送接受
    }
    [self parsingPushUserInfo:userInfo];
    NSLog(@"%@",userInfo);
}
// 解析推送的内容
-(void)parsingPushUserInfo:(NSDictionary*)userInfo{
    if (userInfo) {
        NSString *content_type = userInfo[@"content_type"];
        NSDictionary *aps = userInfo[@"aps"];
        if (content_type && aps) {
            aps = [fn checkNullWithDictionary:aps];
            NSDictionary *alert = aps[@"alert"];
            NSString *title = alert[@"title"];
            NSString *body = alert[@"body"];
            NSString *subtitle = alert[@"subtitle"];
            if ([content_type isEqualToString:@"blackboard"]) {
                // 小黑板内容
                [YunConfig seting:kConfig_User_BlackBoard_Content value:[NSString stringWithFormat:@"%@|%@\n\n%@",subtitle,title,body]];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_PushSuccess object:content_type];
        }
    }
}
@end
