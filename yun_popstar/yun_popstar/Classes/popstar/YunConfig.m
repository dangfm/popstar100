//
//  YunConfig.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/12.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunConfig.h"
#import <AdSupport/AdSupport.h>
#import <Security/Security.h>

@implementation YunConfig

+(void)seting:(NSString*)key value:(NSString*)value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString*)get:(NSString*)key{
    NSString *obj = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return obj;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}
+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}
+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

+(NSString *)getDeviceIDInKeychain {
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *getUDIDInKeychain = (NSString *)[self load:bundleId];
    //NSLog(@"从keychain中获取到的 UDID_INSTEAD %@",getUDIDInKeychain);
    if (!getUDIDInKeychain ||[getUDIDInKeychain isEqualToString:@""]||[getUDIDInKeychain isKindOfClass:[NSNull class]]) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        //NSLog(@"\n \n \n _____重新存储 UUID _____\n \n \n  %@",result);
        [self save:bundleId data:result];
        getUDIDInKeychain = (NSString *)[self load:bundleId];
    }
    //NSLog(@"最终 ———— UDID_INSTEAD %@",getUDIDInKeychain);
    return getUDIDInKeychain;
}

+(NSString*)uuid{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return uuid;
}

+(NSString*)idfa{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return adId;
}

+(void)logout{
    [YunConfig setUserToken:@""];
}

+(void)defaultValue{
    // 每次启动化红包关掉
    [YunConfig setUserIsOpenRedEnvelope:NO];
    if (![YunConfig get:kConfig_init]) {
        [YunConfig setUserToken:@""];
        [YunConfig setGameSoundIsOpen:YES];
        [YunConfig setGameVoiceIsOpen:YES];
        [YunConfig seting:kConfig_init value:@"1"];
        // 首次广告弹出关卡
        [YunConfig seting:kConfig_User_clearance_show_ad_lasttime value:@([YunConfig getUserPassNumber]).stringValue];
        [YunConfig seting:kConfig_User_redenvelope_show_ad_lasttime value:@(0).stringValue];
    }
    
}

+(void)setUserInfoWithData:(NSDictionary*)user{
    // 金币
    int gold_balance = [user[@"gold_balance"] intValue];
    // 总分数
    int coin_balance = [user[@"coin_balance"] intValue];
    // 最高分
    int coin_max_value = [user[@"coin_max_value"] intValue];
    // 当前关卡
    int clearance_number = [user[@"clearance_number"] intValue]+1;
    // 刷新道具数量
    int tool_refresh_num = [user[@"tool_refresh_num"] intValue];
    // 爆破道具数量
    int tool_bomb_num = [user[@"tool_bomb_num"] intValue];
    // 魔术笔道具数量
    int tool_magic_num = [user[@"tool_magic_num"] intValue];
    // 红包领取次数,每隔多少次强制打开广告
    int redenvelope_times = [user[@"redenvelope_times"] intValue];
    // 红包总的金额
    float redenvelope_amount = [user[@"redenvelope_amount"] floatValue];
    
    [YunConfig setUserNickName:user[@"nick_name"]];
    [YunConfig setUserFace:user[@"face"]];
    [YunConfig setUserWXOpenID:user[@"wx_openid"]];
    [YunConfig setUserCreatedAt:user[@"created_at"]];
    [YunConfig setUserGold:gold_balance];
    [YunConfig setUserCoin:coin_balance];
    [YunConfig setUserPassNumber:clearance_number];
    [YunConfig setUserTargetCoin:[YunConfig passNumberDefaultTargetNumber:clearance_number]];
    [YunConfig setUserCoinMax:coin_max_value];
    [YunConfig setUserRefreshAmount:tool_refresh_num];
    [YunConfig setUserBombAmount:tool_bomb_num];
    [YunConfig setUserMagicAmount:tool_magic_num];
    [YunConfig setUserRedEnvelope:redenvelope_amount];
    [YunConfig seting:kConfig_User_redenvelope_show_ad_lasttime value:@(redenvelope_times).stringValue];
    
    if ([YunConfig getUserFirstGold]<=0 && gold_balance>0) {
        [YunConfig setUserFirstGold:gold_balance];
    }
}

+(YunConfig*)getConfig{
    YunConfig *config = nil;
    NSString*data = [self get:kConfig_ServerDatas];
    if (data) {
        config = [YunConfig mj_objectWithKeyValues:[data mj_JSONObject]];
        if (config) {
            NSArray *is_open_ads = [config.is_open_ads mj_JSONObject];
            if (is_open_ads) {
                if ([is_open_ads indexOfObject:[fn getVersion]]!=NSNotFound) {
                    config.is_open_ad = @"1";
                }else{
                    config.is_open_ad = @"0";
                }
            }
            
        }
    }
    return config;
}

+(void)setAgreePrivacy:(BOOL)agree{
    [self seting:kConfig_AgreePrivacy value:@(agree?1:0).stringValue];
}
+(BOOL)isAgreePrivacy{
    NSString *agree = [self get:kConfig_AgreePrivacy];
    if (!agree) {
        agree = @"0";
    }
    return [agree boolValue];
}

+(void)setUserId:(NSString*)userid{
    [self seting:kConfig_UserId value:userid];
}
+(NSString*)getUserId{
    NSString *userid = [self get:kConfig_UserId];
    if (!userid) {
        userid = @"";
    }
    return userid;
}
+(void)setUserToken:(NSString*)token{
    [self seting:kConfig_UserToken value:token];
}
+(NSString*)getUserToken{
    NSString *token = [self get:kConfig_UserToken];
    token = token?token:@"";
    return token;
}

+(void)setUserNickName:(NSString*)nickName{
    [self seting:kConfig_UserNickName value:nickName];
}
+(NSString*)getUserNickName{
    NSString *nickName = [self get:kConfig_UserNickName];
    return nickName;
}
+(void)setUserFace:(NSString *)face{
    [self seting:kConfig_UserFace value:face];
}
+(NSString*)getUserFace{
    NSString *face = [self get:kConfig_UserFace];
    if (!face) {
        face = @"";
    }
    return face;
}
+(void)setUserWXOpenID:(NSString *)openid{
    [self seting:kConfig_UserWxOpenID value:openid];
}
+(NSString*)getUserWXOpenID{
    NSString *openid = [self get:kConfig_UserWxOpenID];
    if (!openid) {
        openid = @"";
    }
    return openid;
}
+(void)setUserCreatedAt:(NSString *)created_at{
    [self seting:kConfig_UserCreatedAt value:created_at];
}
+(NSString*)getUserCreatedAt{
    NSString *created_at = [self get:kConfig_UserCreatedAt];
    if (!created_at) {
        created_at = @"";
    }
    return created_at;
}

+(void)setUserFirstGold:(int)gold{
    [self seting:kConfig_User_FirstGold value:[NSString stringWithFormat:@"%d",gold]];
}
+(int)getUserFirstGold{
    int c = 0;
    NSString *gold = [self get:kConfig_User_FirstGold];
    if(gold){
        c = [gold intValue];
    }
    return c;
}

+(void)setUserCoin:(int)coin{
    [self seting:kConfig_User_Coin value:[NSString stringWithFormat:@"%d",coin]];
}
+(int)getUserCoin{
    int c = 0;
    NSString *coin = [self get:kConfig_User_Coin];
    if(coin){
        c = [coin intValue];
    }
    return c;
}

+(void)setUserCoinSingle:(int)coin{
    [self seting:kConfig_User_Coin_Single value:[NSString stringWithFormat:@"%d",coin]];
}
+(int)getUserCoinSingle{
    int c = 0;
    NSString *coin = [self get:kConfig_User_Coin_Single];
    if(coin){
        c = [coin intValue];
    }
    return c;
}

+(void)setUserCoinMax:(int)coin{
    [self seting:kConfig_User_Coin_Max value:[NSString stringWithFormat:@"%d",coin]];
}
+(int)getUserCoinMax{
    int c = 0;
    NSString *coin = [self get:kConfig_User_Coin_Max];
    if(coin){
        c = [coin intValue];
    }
    return c;
}

+(void)setUserPassNumber:(int)number{
    [self seting:kConfig_User_Pass_Number value:[NSString stringWithFormat:@"%d",number]];
}
+(int)getUserPassNumber{
    int c = 0;
    NSString *number = [self get:kConfig_User_Pass_Number];
    if(number){
        c = [number intValue];
    }
    if (c<=0) {
        c = 1; // 默认第一关
        
    }
    return c;
}

+(void)setUserTargetCoin:(int)number{
    [self seting:kConfig_User_Target_Coin value:[NSString stringWithFormat:@"%d",number]];
}
+(int)getUserTargetCoin{
    int c = 0;
    NSString *number = [self get:kConfig_User_Target_Coin];
    if(number){
        c = [number intValue];
    }
    if (c<=0) {
        // 默认关卡难度分数
        c = [self passNumberDefaultTargetNumber:0];
    }
    return c;
}

+(void)setUserGold:(int)number{
    [self seting:kConfig_User_Gold value:[NSString stringWithFormat:@"%d",number]];
}
+(int)getUserGold{
    int c = 0;
    NSString *number = [self get:kConfig_User_Gold];
    if(number){
        c = [number intValue];
    }
    return c;
}

/// 通关对应的目标分数
/// 800
/// 1650
/// 2550
/// 3500
/// 4500
///
/// @param number 关卡
+(int)passNumberDefaultTargetNumber:(int)number{
    YunConfig *config = [self getConfig];
    int num = number<=0?1:number;
    int yz = kPass_step;
    // 使用远程配置
    if (config) {
        yz = [config.pass_step intValue];
    }
    // 上一关的分数
    int last = 0;
    if (num>1) {
        last = [YunConfig passNumberDefaultTargetNumber:(num-1)];
    }
    if (num<=1) {
        if (config) {
            return [config.pass_init_coin intValue];
        }
        return kPass_initCoin;
    }
    // 增长
    long zhengzhang = kPass_grow+yz*num;
    if (config) {
        zhengzhang = [config.pass_grow intValue]+yz*num;
    }
    //zhengzhang = ceil(floorf(zhengzhang) / 100) * 100;
    //NSLog(@"增长：%ld",zhengzhang);
    long coin = last + zhengzhang;
    //coin = (coin/100+1) * 100;
    return ceil(coin);
}


/// 分数对应的关卡
/// @param number 分数
+(int)targetNumberDefaultPassNumber:(int)number{
    int num = 1;
    while (true) {
        int coin = [self passNumberDefaultTargetNumber:num];
        if(number<coin){
            break;
        }
        num ++;
    }
    return num;
}

+(void)setUserIsUseBomb:(BOOL)use{
    [self seting:kConfig_User_Is_User_Bomb value:[NSString stringWithFormat:@"%d",use]];
}
+(BOOL)getUserIsUseBomb{
    BOOL c = NO;
    NSString *number = [self get:kConfig_User_Is_User_Bomb];
    if(number){
        c = [number boolValue];
        [self setUserIsUseBomb:NO];
    }
    return c;
}

+(void)setUserBombAmount:(int)amount{
    [self seting:kConfig_User_Bomb_Amount value:[NSString stringWithFormat:@"%d",amount]];
}
+(int)getUserBombAmount{
    int c = 0;
    NSString *number = [self get:kConfig_User_Bomb_Amount];
    if(number){
        c = [number intValue];
    }
    return c;
}

+(void)setUserIsUseRefresh:(BOOL)use{
    [self seting:kConfig_User_Is_User_Refesh value:[NSString stringWithFormat:@"%d",use]];
}
+(BOOL)getUserIsUseRefresh{
    BOOL c = NO;
    NSString *number = [self get:kConfig_User_Is_User_Refesh];
    if(number){
        c = [number boolValue];
        [self setUserIsUseRefresh:NO];
    }
    return c;
}

+(void)setUserRefreshAmount:(int)amount{
    [self seting:kConfig_User_Refresh_Amount value:[NSString stringWithFormat:@"%d",amount]];
}
+(int)getUserRefreshAmount{
    int c = 0;
    NSString *number = [self get:kConfig_User_Refresh_Amount];
    if(number){
        c = [number intValue];
    }
    return c;
}

+(void)setUserIsUseMagic:(BOOL)use{
    [self seting:kConfig_User_Is_User_Magic value:[NSString stringWithFormat:@"%d",use]];
}
+(BOOL)getUserIsUseMagic{
    BOOL c = NO;
    NSString *number = [self get:kConfig_User_Is_User_Magic];
    if(number){
        c = [number boolValue];
        [self setUserIsUseMagic:NO];
    }
    return c;
}

+(void)setUserMagicAmount:(int)amount{
    [self seting:kConfig_User_Magic_Amount value:[NSString stringWithFormat:@"%d",amount]];
}
+(int)getUserMagicAmount{
    int c = 0;
    NSString *number = [self get:kConfig_User_Magic_Amount];
    if(number){
        c = [number intValue];
    }
    return c;
}


+(void)setUserBackgroundImageName:(NSString*)name{
    [self seting:kConfig_User_Background_Image_Name value:name];
}
+(NSString*)getUserBackgroundImageName{
    NSString *name = [self get:kConfig_User_Background_Image_Name];
    return name;
}

+(void)setGameSoundIsOpen:(BOOL)open{
    [self seting:kConfig_User_Game_Sound_Is_Open value:[NSString stringWithFormat:@"%d",open]];
}
+(BOOL)getGameSoundIsOpen{
    BOOL c = NO;
    NSString *number = [self get:kConfig_User_Game_Sound_Is_Open];
    if(number){
        c = [number boolValue];
    }
    return c;
}

+(void)setGameVoiceIsOpen:(BOOL)open{
    [self seting:kConfig_User_Game_Voice_Is_Open value:[NSString stringWithFormat:@"%d",open]];
}
+(BOOL)getGameVoiceIsOpen{
    BOOL c = NO;
    NSString *number = [self get:kConfig_User_Game_Voice_Is_Open];
    if(number){
        c = [number boolValue];
    }
    return c;
}

+(void)setUserRedEnvelope:(float)number{
    [self seting:kConfig_User_RedEnvelope value:[NSString stringWithFormat:@"%.2f",number]];
}
+(float)getUserRedEnvelope{
    float c = 0;
    NSString *number = [self get:kConfig_User_RedEnvelope];
    if(number){
        c = [number floatValue];
    }
    return c;
}

+(void)setUserIsOpenRedEnvelope:(BOOL)open{
    [self seting:kConfig_User_IsOpenRedEnvelope value:[NSString stringWithFormat:@"%d",open?1:0]];
}
+(BOOL)getUserIsOpenRedEnvelope{
    BOOL c = 0;
    NSString *number = [self get:kConfig_User_IsOpenRedEnvelope];
    if(number){
        c = [number boolValue];
    }
    return c;
}

+(void)setUserShieldRedEnvelope:(BOOL)open{
    [self seting:kConfig_User_ShieldRedenvelope value:[NSString stringWithFormat:@"%d",open?1:0]];
}
+(BOOL)getUserShieldRedEnvelope{
    BOOL c = 0;
    NSString *number = [self get:kConfig_User_ShieldRedenvelope];
    if(number){
        c = [number boolValue];
    }
    return c;
}

+(BOOL)setUserEverydaySign:(NSString*)date{
    BOOL success = false;
    NSMutableArray *array = [YunConfig getUserEverydaySign];
    if([array indexOfObject:date]==NSNotFound){
        if (array.count<7) {
            [array addObject:date];
            success = YES;
        }else{
            // 大于7天重新开始记录
            [array removeAllObjects];
            [array addObject:date];
            success = YES;
        }
    }
    [self seting:kConfig_User_EverydaySign value:[array mj_JSONString]];
    return success;
}
+(NSMutableArray*)getUserEverydaySign{
    NSString *s = [self get:kConfig_User_EverydaySign];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[s mj_JSONObject]];
    return array;
}

+(void)setUserClearanceIsShowAd:(BOOL)show{
    [self seting:kConfig_User_clearance_is_show_ad value:@(show?1:0).stringValue];
}
+(BOOL)getUserClearanceIsShowAd{
    BOOL s = [[self get:kConfig_User_clearance_is_show_ad] boolValue];
    return s;
}
@end
