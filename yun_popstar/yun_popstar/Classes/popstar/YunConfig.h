//
//  YunConfig.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/12.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define kConfig_init @"kConfig_Init"  // 初始化标识
#define kConfig_DeviceToken @"kConfig_DeviceToken"  // 设备推送标识
#define kConfig_AgreePrivacy @"kConfig_AgreePrivacy"  // 同意协议
#define kConfig_User_FirstGold @"kConfig_User_FirstGold"  // 新人奖励一次金币
#define kConfig_User_Coin @"kConfig_User_Coin"  // 保存用户得分
#define kConfig_User_Coin_Single @"kConfig_User_Coin_Single"  // 保存用户每一关得分
#define kConfig_User_Coin_Max @"kConfig_User_Coin_Max"  // 保存用户最高得分
#define kConfig_User_Pass_Number @"kConfig_User_Pass_Number"  // 关卡等级
#define kConfig_User_Target_Coin @"kConfig_User_Target_Coin"  // 目标分数
#define kConfig_User_Gold @"kConfig_User_Gold"  // 金币数量
#define kConfig_User_Is_User_Bomb @"kConfig_User_Is_User_Bomb"  // 是否使用炸弹
#define kConfig_User_Is_User_Refesh @"kConfig_User_Is_User_Refresh"  // 是否使用刷消息
#define kConfig_User_Is_User_Magic @"kConfig_User_Is_User_Magic"  // 是否使用魔术刷
#define kConfig_User_Bomb_Amount @"kConfig_User_Bomb_Amount"  // 炸弹数量
#define kConfig_User_Refresh_Amount @"kConfig_User_Refresh_Amount"  // 刷新数量
#define kConfig_User_Magic_Amount @"kConfig_User_Magic_Amount"  // 魔术刷数量
#define kConfig_User_Background_Image_Name @"kConfig_User_Background_Image_Name"  // 背景名称
#define kConfig_User_Game_Sound_Is_Open @"kConfig_User_Game_Sound_Is_Open"  // 是否开启背景音乐
#define kConfig_User_Game_Voice_Is_Open @"kConfig_User_Game_Voice_Is_Open"  // 是否开启游戏音效
#define kConfig_User_RedEnvelope @"kConfig_User_RedEnvelope"  // 红包
#define kConfig_User_IsOpenRedEnvelope @"kConfig_User_IsOpenRedEnvelope"  // 是否打开红包
#define kConfig_User_EverydaySign @"kConfig_User_EverydaySign"  // 保存每日签到数据，每次签到保存一次日期 格式 ['2020-08-12','2020-09-20']
#define kConfig_User_clearance_is_show_ad @"kConfig_User_clearance_is_show_ad"  // 用户通过是否显示激励广告按钮，
#define kConfig_User_last_show_ad_time @"kConfig_User_last_show_ad_time"  // 首页激励视频每隔十分钟才能看一次
#define kConfig_User_clearance_show_ad_lasttime @"kConfig_User_clearance_show_ad_lasttime"  // 上次通关打开广告的时间，用来强制弹出广告
#define kConfig_User_redenvelope_show_ad_lasttime @"kConfig_User_redenvelope_show_ad_lasttime"  // 打开红包的次数，用来强制弹出广告
#define kConfig_User_clearance_redenvelope_time @"kConfig_User_clearance_redenvelope_time"  // 红包激活倒计时
#define kConfig_User_BlackBoard_Content @"kConfig_User_BlackBoard_Content"  // 每日小黑板内容
#define kConfig_User_BlackBoard_LastShowDate @"kConfig_User_BlackBoard_LastShowDate"  // 小黑板最后弹出日期
#define kConfig_User_LevelsSameTime @"kConfig_User_LevelsSameTime"  // 同一个关卡的次数
#define kConfig_User_ShieldRedenvelope @"kConfig_User_ShieldRedenvelope"  // 手动屏蔽红包
#define kConfig_User_Challenged_UserLevelsIds @"kConfig_User_Challenged_UserLevelsIds"  // 已挑战成功的IDs
#define kConfig_UserId @"kConfig_UserId"  // 用户ID
#define kConfig_UserToken @"kConfig_UserToken"  // 用户登录状态token
#define kConfig_UserFace @"kConfig_UserFace"  // 用户头像
#define kConfig_UserWxOpenID @"kConfig_UserWxOpenID"  // 用户微信oppenid
#define kConfig_UserNickName @"kConfig_UserNickName"  // 用户昵称
#define kConfig_UserCreatedAt @"kConfig_UserCreatedAt"  // 用户注册时间
#define kConfig_ServerDatas @"kConfig_ServerDatas"  // 远程配置信息

@interface YunConfig : NSObject
@property (nonatomic,retain) NSString * pass_step;//关卡增长步长
@property (nonatomic,retain) NSString * pass_grow;//关卡增长常量
@property (nonatomic,retain) NSString * pass_init_coin;//第一关关卡分数目标
@property (nonatomic,retain) NSString * pass_star_coin_min;//每个星星的最小分数
@property (nonatomic,retain) NSString * pass_star_coin_max;//每个星星的最大分数
@property (nonatomic,retain) NSString * pass_star_coin_less; // 每个星星的得分率
@property (nonatomic,retain) NSString * link_star_coin; // 消灭N个星星送M个金币
@property (nonatomic,retain) NSString * is_open_redenvelope; //是否开启红包总开关
@property (nonatomic,retain) NSString * is_open_ad;//是否开启广告总开关
@property (nonatomic,retain) NSString * is_open_ads;//是否开启广告总开关 1.4版本起用这个
@property (nonatomic,retain) NSString * open_ad_longtime;//通关弹窗，每隔多少秒强制打开广告
@property (nonatomic,retain) NSString * pass_open_redenvelope;//每隔多少关激活红包
@property (nonatomic,retain) NSString * open_ad_redenvelope;// 每隔多少关开红包必须打开激励视频广告
@property (nonatomic,retain) NSString * home_vedio_ad_timeout;// 首页免费激励视频广告间隔时间 秒
@property (nonatomic,retain) NSString * enchashment_min;// 最小提现金额 元
@property (nonatomic,retain) NSString * open_ads; // 每个广告位的开关
@property (nonatomic,retain) NSString * send_gold_when_last_num_star; // 每关卡剩余多少星星才送金币
@property (nonatomic,retain) NSString * send_gold_amount; // 通关送多少金币
@property (nonatomic,retain) NSString * free_reward_max_everyday; // 免费奖励每天最大值
@property (nonatomic,retain) NSString * free_reward_amount; // 每次免费奖励金币数
@property (nonatomic,retain) NSString * bind_wechat_money; // 绑定微信加速多少元
@property (nonatomic,retain) NSString * redenvelope_activity_time; // 红包活动天数
@property (nonatomic,retain) NSString * everyday_sign_gold; // 每天签到送的金币数量
@property (nonatomic,retain) NSString * enchashment_money_list; // 提现金额列表
@property (nonatomic,retain) NSString * enchashment_intro; // 提现规则
@property (nonatomic,retain) NSString * redenvelope_money_list; // 红包提现金额列表
@property (nonatomic,retain) NSString * redenvelope_intro; // 红包提现规则
@property (nonatomic,retain) NSString * clear_star_golds; // 清空星星奖励金币
@property (nonatomic,retain) NSString * master_get_disciple_gold; //徒弟贡献提现金币的百分比金币给师傅
@property (nonatomic,retain) NSString * ios_app_version; // 版本更新
@property (nonatomic,retain) NSString * newmen_gold; // 新人奖励金币数量
@property (nonatomic,retain) NSString * levels_sametime_ad; // 连续通过失败强弹广告
@property (nonatomic,retain) NSString * levels_sametime_ad_gold; // 连续通过失败强弹广告奖励金币
@property (nonatomic,retain) NSString * challenge_golds; // 挑战大于多少秒奖励多少金币
@property (nonatomic,retain) NSString * community_challenge_is_open; // 是否开启社区挑战
+(YunConfig*)getConfig;

+(void)seting:(NSString*)key value:(NSString*)value;
+(NSString*)get:(NSString*)key;

/**
 本方法是得到 UUID 后存入系统中的 keychain 的方法
 不用添加 plist 文件
 程序删除后重装,仍可以得到相同的唯一标示
 但是当系统升级或者刷机后,系统中的钥匙串会被清空,此时本方法失效
 */
+(NSString *)getDeviceIDInKeychain;
+(NSString*)uuid;
+(NSString*)idfa;
// 初始化默认值
+(void)defaultValue;
+(void)setUserInfoWithData:(NSDictionary*)user;
+(void)logout;
+(void)setAgreePrivacy:(BOOL)agree;
+(BOOL)isAgreePrivacy;
+(void)setUserId:(NSString*)userid;
+(NSString*)getUserId;
+(void)setUserToken:(NSString*)token;
+(NSString*)getUserToken;
+(void)setUserNickName:(NSString*)nickName;
+(NSString*)getUserNickName;
+(void)setUserFace:(NSString*)face;
+(NSString*)getUserFace;
+(void)setUserWXOpenID:(NSString*)openid;
+(NSString*)getUserWXOpenID;
+(void)setUserCreatedAt:(NSString*)created_at;
+(NSString*)getUserCreatedAt;
// 新人奖励金币
+(void)setUserFirstGold:(int)gold;
+(int)getUserFirstGold;
// 用户总得分
+(void)setUserCoin:(int)coin;
+(int)getUserCoin;
// 用户当前关卡得分
+(void)setUserCoinSingle:(int)coin;
+(int)getUserCoinSingle;
// 用户得分最高值
+(void)setUserCoinMax:(int)coin;
+(int)getUserCoinMax;
// 关卡
+(void)setUserPassNumber:(int)number;
+(int)getUserPassNumber;
// 目标
+(void)setUserTargetCoin:(int)number;
+(int)getUserTargetCoin;
// 金币
+(void)setUserGold:(int)number;
+(int)getUserGold;
/// 通关对应的目标分数
/// @param number 关卡
+(int)passNumberDefaultTargetNumber:(int)number;
/// 分数对应的关卡
/// @param number 分数
+(int)targetNumberDefaultPassNumber:(int)number;
// 是否使用炸弹
+(void)setUserIsUseBomb:(BOOL)use;
+(BOOL)getUserIsUseBomb;
// 炸弹数量
+(void)setUserBombAmount:(int)amount;
+(int)getUserBombAmount;
// 是否使用刷新
+(void)setUserIsUseRefresh:(BOOL)use;
+(BOOL)getUserIsUseRefresh;
// 刷新数量
+(void)setUserRefreshAmount:(int)amount;
+(int)getUserRefreshAmount;
// 使用使用魔术棒
+(void)setUserIsUseMagic:(BOOL)use;
+(BOOL)getUserIsUseMagic;
// 魔术棒数量
+(void)setUserMagicAmount:(int)amount;
+(int)getUserMagicAmount;
// 背景
+(void)setUserBackgroundImageName:(NSString*)name;
+(NSString*)getUserBackgroundImageName;
// 游戏背景音乐
+(void)setGameSoundIsOpen:(BOOL)open;
+(BOOL)getGameSoundIsOpen;
// 游戏按键音效
+(void)setGameVoiceIsOpen:(BOOL)open;
+(BOOL)getGameVoiceIsOpen;
// 红包
+(void)setUserRedEnvelope:(float)number;
+(float)getUserRedEnvelope;
// 红包开关
+(void)setUserIsOpenRedEnvelope:(BOOL)open;
+(BOOL)getUserIsOpenRedEnvelope;
// 用户手动屏蔽红包
+(void)setUserShieldRedEnvelope:(BOOL)open;
+(BOOL)getUserShieldRedEnvelope;
// 签到数据保存
+(BOOL)setUserEverydaySign:(NSString*)date;
+(NSMutableArray*)getUserEverydaySign;
// 通关按钮是否显示激励视频按钮
+(void)setUserClearanceIsShowAd:(BOOL)show;
+(BOOL)getUserClearanceIsShowAd;
@end



NS_ASSUME_NONNULL_END
