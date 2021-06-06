//
//  FMGlobalDefines.h
//  FMMarket
//
//  Created by dangfm on 15/8/7.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#ifndef FMMarket_FMGlobalDefines_h
#define FMMarket_FMGlobalDefines_h

#define kAppStore_Id @"1529230932" // appstore id
// 关卡相关
// 增长步长
#define kPass_step 100
// 增长常量 表示最增长值
#define kPass_grow 1500
// 第一关分数
#define kPass_initCoin 1000
// 方块的分数起始值 每个方块都是根据这两个值进行随机计算，方块本身根据每关卡有个增量算法
#define kPass_starCoin_start 10
#define kPass_starCoin_end 30
// 友盟统计
#define kUmeng_AppKey @"5f47e15c636b2b112345678"
// 友盟推送
#define kUmeng_Push_AppKey @"5f47e15c636b2b13112345678"
#define kUmeng_Push_AppSecret @"pihev44fwcaqzhjul1xzjztztj123455678"
// 穿山甲
#define kChuanshanjia_AppId @"5101325"
// 恋上消消消_iphone_激励视频_金币兑换工具
#define kCsj_sloteid_945438638 @"945438638"
// 恋上消消消_iphone_开始界面_免费奖励_激励视频
#define kCsj_sloteid_945440297 @"945440297"
// 恋上消消消_iphone_激励视频_通过奖励
#define kCsj_sloteid_945440304 @"945440304"
// 恋上消消消_iphone_开屏
#define kCsj_sloteid_887373369 @"887373369"
// 恋上消消消_iphone_ios_红包开奖激励视频
#define kCsj_sloteid_945463813 @"945463813"
// 恋上消消消_iphone_ios_双倍签到激励视频
#define kCsj_sloteid_945464448 @"945464448"
// 恋上消消消_iphone_ios_每日签到信息流
#define kCsj_sloteid_945470606 @"945470606"
//恋上消消消_iphone_ios_通关信息流
#define kCsj_sloteid_945478871 @"945478871"
// 恋上消消消_iphone_ios_提现插屏
#define kCsj_sloteid_945512927 @"945512927"
// 恋上消消消_iphone_提现_Banner
#define kCsj_sloteid_945515067 @"945515067"
// 恋上消消消_iphone_回放列表_信息流
#define kCsj_sloteid_945515121 @"945515121"
// 恋上消消消_iphone_提现_信息流
#define kCsj_sloteid_945515431 @"945515431"
// 恋上消消消_iphone_社区挑战_头部信息流
#define kCsj_sloteid_945527434 @"945527434"


// 微信开发平台
#define kWechat_AppId @""
#define kWechat_AppSecret @""

// 设备类型 0=ios 1=android 2=winphone 3=other
#define kDeviceType @"ios"
// 登陆过期
#define kMustLogoutErrorCode 410
// 接口地址
// 主服务接口地址
#define kBaseURL @"https://app.api.popstar100.com" // 线上发布服务器的根地址
// 接口Token 签名用
#define kAPI_Key @"tRp4wKm43pI6JFNGuyErRneXgsqfDrhJ"

#define kURL(...) [kBaseURL stringByAppendingFormat:__VA_ARGS__]

#define http FMHttpRequest
#define fn FMHelper

#define IOS8            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define IOS13            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 13.0)
#define UIScreenWidth                              [UIScreen mainScreen].bounds.size.width
#define UIScreenHeight                             [UIScreen mainScreen].bounds.size.height
#define UISreenWidthScale   UIScreenWidth / 320
#define kNavigationHeight 44
#define kTabBarNavigationHeight ((iPhoneX||iPhoneXR||iPhoneXsMax)?83:49)
#define kTabBarNavigationHeight64 64
#define kStatusBarHeight ((iPhoneX||iPhoneXR||iPhoneXsMax)?44:20)


#define FMWhiteColor UIColorFromRGB(0xFFFFFF)
#define FMToolbarColor UIColorFromRGB(0xefefef)
#define FMGoldenColor UIColorFromRGB(0xc9a974)
#define FMNavTitleColor UIColorFromRGB(0x323232)
#define FMNavColor UIColorFromRGB(0xFFFFFF)
#define FMNavBottomLineColor UIColorFromRGB(0xDDDDDD)
#define FMOrangeColor UIColorFromRGB(0xD2691E)
#define FMRedColor UIColorFromRGB(0xe5251a)
#define FMGreenColor UIColorFromRGB(0x18c062)
#define FMGreyColor UIColorFromRGB(0x999999)
#define FMBlueColor UIColorFromRGB(0x2e6bdd)
#define FMYellowColor UIColorFromRGB(0xffcc00)
#define FMLowGreenColor UIColorFromRGB(0x61da9d)
#define FMTabbarColor UIColorFromRGB(0xa5a5a5)
#define FMTabbarBgColor UIColorFromRGB(0xFFFFFF)
#define FMTabbarSelectedColor UIColorFromRGB(0xe5251a)
#define FMZeroColor UIColorFromRGB(0x000000)
#define FMBlackColor UIColorFromRGB(0x333333)
#define FMBgGreyColor UIColorFromRGB(0xf3f3f3)
#define FMBottomLineColor UIColorFromRGB(0xefefef)
#define FMNoPhotoBgColor UIColorFromRGB(0xf0f4fa)
#define FMNavTitleBgColor UIColorFromRGB(0xFFFFFF)
#define FMKlineBgColor UIColorFromRGB(0xFFFFFF)

#define FMDefaultBackgroundImage [UIImage gradientColorImageFromColors:@[UIColorFromRGB(0x5832b9),UIColorFromRGB(0xc44c4e)] gradientType:GradientTypeUpleftToLowright imgSize:CGSizeMake(UIScreenWidth, UIScreenHeight)]

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#pragma mark - UIColor宏定义
#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

/*
 release的时候会关掉
 */
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

#define FMDealloc NSLog(@"%@ dealloc",NSStringFromClass([self class]));

// 请求返回错误通用处理
#define FMHttpShowError(dic) NSString *errorInfo = dic[@"msg"];if ([errorInfo isEqual:[NSNull null]]) {errorInfo = @"服务器有误";}[SVProgressHUD showErrorWithStatus:errorInfo];
#define FMHttpShowFailure [SVProgressHUD showErrorWithStatus:@"网络异常,请重试"];

#define WEAKSELF __weak typeof(self) __weakSelf = self;
//字体
// HelveticaNeue，HelveticaNeue-Bold
#define kFontSize 14.0
#define kFontName @"Helvetica"
#define kFontBoldName @"Helvetica-Bold"
#define kFontNumberName @"Helvetica"
#define kFontNumberBoldName @"Helvetica-Bold"
#define kFont(fontSize) [UIFont fontWithName:kFontName size:fontSize]
#define kFontBold(fontSize) [UIFont fontWithName:kFontBoldName size:fontSize]
#define kFontNumber(fontSize) [UIFont fontWithName:kFontNumberName size:fontSize]
#define kFontNumberBold(fontSize) [UIFont fontWithName:kFontNumberBoldName size:fontSize]
#define kDefaultFont kFont(kFontSize)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960),[[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334),[[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208),[[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436),[[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792),[[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneXsMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688),[[UIScreen mainScreen] currentMode].size) : NO)





// 网络状态通知
#define kFMReachabilityChangedNotification @"kFMReachabilityChangedNotification"
// 回到后台
#define kNSNotificationName_applicationDidEnterBackground @"kNSNotificationName_applicationDidEnterBackground"
// 回到前台
#define kNSNotificationName_applicationWillEnterForeground @"kNSNotificationName_applicationWillEnterForeground"
// 用户登录成功通知
#define kNSNotificationName_UserLoginSuccess @"kNSNotificationName_UserLoginSuccess"
// 读取配置信息成功
#define kNSNotificationName_GetConfigSuccess @"kNSNotificationName_GetConfigSuccess"
// 得分通知
#define kNSNotificationName_AddScroe @"kNSNotificationName_AddScroe"
// 新游戏通知
#define kNSNotificationName_NewGame @"kNSNotificationName_NewGame"
// 游戏开始通知
#define kNSNotificationName_GameStart @"kNSNotificationName_GameStart"
// 游戏结束通知
#define kNSNotificationName_GameOver @"kNSNotificationName_GameOver"
// 通关失败通知
#define kNSNotificationName_PassFail @"kNSNotificationName_PassFail"
// 回到首页
#define kNSNotificationName_GoToGameStartHome @"kNSNotificationName_GoToGameStartHome"
// 改变星星颜色
#define kNSNotificationName_GameChangeAllButtonColor @"kNSNotificationName_GameChangeAllButtonColor"
// 声音停止
#define kNSNotificationName_SoundStop @"kNSNotificationName_SoundStop"
// 声音开始
#define kNSNotificationName_SoundStart @"kNSNotificationName_SoundStart"
// 金币通知
#define kNSNotificationName_GetCoin @"kNSNotificationName_GetCoin"
// 红包通知
#define kNSNotificationName_GetRedEnvelope @"kNSNotificationName_GetRedEnvelope"
// 红包已激活通知
#define kNSNotificationName_RedEnvelope_Active @"kNSNotificationName_RedEnvelope_Active"
// 红包关闭通知
#define kNSNotificationName_RedEnvelope_Close @"kNSNotificationName_RedEnvelope_Close"
// 工具完成通知
#define kNSNotificationName_ToolFinished @"kNSNotificationName_ToolFinished"
// 推送成功通知
#define kNSNotificationName_PushSuccess @"kNSNotificationName_PushSuccess"
// 回放播放通知
#define kNSNotificationName_LevesStartBackPlay @"kNSNotificationName_LevesStartBackPlay"
// 挑战开始通知
#define kNSNotificationName_ChallengeStartPlay @"kNSNotificationName_ChallengeStartPlay"
// 挑战结束通知
#define kNSNotificationName_ChallengeEndPlay @"kNSNotificationName_ChallengeEndPlay"



// 接口
// 远程配置
#define kAPI_Config kURL(@"/config")
// 排行榜列表
#define kAPI_LeaderList kURL(@"/leaderlist")
// 快捷按钮
#define kAPI_Shortcut kURL(@"/shortcut")
// 任务列表
#define kAPI_Tasks kURL(@"/tasks")
// 句子列表
#define kAPI_Sentences kURL(@"/sentenceslist")

// 关于我们
#define kAPI_AboutUs kURL(@"/wap/singlepage?articleId=76031")
// 隐私条款
#define kAPI_ProcyTip @"https://www.popstar100.com/privacy-policy.html"//kURL(@"/wap/singlepage?articleId=76032")
// 用户协议
#define kAPI_Xieyi @"https://www.popstar100.com/xieyi.html"//kURL(@"/wap/singlepage?articleId=76032")
// 红包规则
#define kAPI_RedenvelopeRule @"https://www.popstar100.com/redenveloperule.html"
// 收徒赚钱规则
#define kAPI_DiscipleRule @"https://www.popstar100.com/disciplerule.html"
// 挑战规则
#define kAPI_ChallengeRule @"https://www.popstar100.com/challengerule.html"
// User Center
#define kAPI_Users_UserRegister kURL(@"/user/register")
// 微信手机号登录
#define kAPI_Users_UserLogin kURL(@"/user/login")
// 自动登录
#define kAPI_Users_UserAutoLogin kURL(@"/user/autologin")
// 微信登录
#define kAPI_Users_WxLogin kURL(@"/user/wxlogin")
// 通过记录
#define kAPI_Users_AddLevels kURL(@"/user/addlevels")
// 通关历史列表
#define kAPI_Users_LevelsList kURL(@"/user/levelslist")
// 社区列表
#define kAPI_Users_CommunityList kURL(@"/user/communitylist")
// 通关回放gif图片
#define kAPI_Users_LevelsGif kURL(@"/user/levelsgif")
// 金币记录
#define kAPI_Users_AddGold kURL(@"/user/addgold")
// 广告记录
#define kAPI_Users_AddAd kURL(@"/user/addad")
// 添加签到记录
#define kAPI_Users_AddEverydaySign kURL(@"/user/addeverydaysign")
// 获取签到记录
#define kAPI_Users_SignList kURL(@"/user/getsignlist")
// 领红包
#define kAPI_Users_AddRedEnvelope kURL(@"/user/addredenvelope")
// 绑定手机号
#define kAPI_Users_JoinMobile kURL(@"/user/joinmobile")
// 发送短信验证码
#define kAPI_Users_UserSendSMS kURL(@"/user/sendsms")
// 编辑昵称
#define kAPI_Users_UserNickName kURL(@"/user/editnickname")
// 编辑头像
#define kAPI_Users_UserUploadFace kURL(@"/user/uploadface")
// 获取用户信息
#define kAPI_Users_UserInfo kURL(@"/user/userinfo")
// 用户提现接口
#define kAPI_Users_Enchashment kURL(@"/user/enchashment")
// 用户提现记录接口
#define kAPI_Users_EnchashmentList kURL(@"/user/enchashmentlist")
// 用户分享记录接口
#define kAPI_Users_Share kURL(@"/user/share")
// 用户好友列表
#define kAPI_Users_ShareFriends kURL(@"/user/sharefriends")
// 用户徒弟列表
#define kAPI_Users_Disciple kURL(@"/user/mydisciple")
// 徒弟拜师
#define kAPI_Users_DiscipleAsk kURL(@"/user/discipleask")
// 师傅收徒
#define kAPI_Users_DiscipleAccept kURL(@"/user/discipleaccept")
// 添加挑战记录
#define kAPI_Users_AddChallenge kURL(@"/user/addchallenge")

#endif
