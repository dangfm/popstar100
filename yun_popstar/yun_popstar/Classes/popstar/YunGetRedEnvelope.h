//
//  YunGetRedEnvelope.h
//  yun_popstar
//
//  Created by dangfm on 2020/8/22.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunGetRedEnvelope : UIView<BUNativeExpressRewardedVideoAdDelegate>
@property(nonatomic,retain) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (retain,nonatomic) NSString *ad_start_time;
@property (assign,nonatomic) long requestid;

@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) UIButton *closeBt;
@property(nonatomic,retain) UIButton *bottomCloseBt;
@property(nonatomic,retain) UIButton *otherBt;
@property(nonatomic,retain) UIButton *submitBt;
@property(nonatomic,retain) UILabel *balanceLb;
@property(nonatomic,retain) UILabel *balanceTipLb;
@property (retain,nonatomic) NSString *redenvelope_id;// 领取双倍需要传
@property (nonatomic, strong) YunPopstarSay *say;
@property (nonatomic, strong) CAEmitterLayer * explosionLayer;
@property(nonatomic,retain) UIButton *openBt;
@property(nonatomic,retain) UIImageView *noOpenBg;
@property (assign,nonatomic) int type;
@property(nonatomic,copy) void(^magicBlock)(UIButton *button,int index);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show;
-(void)showWithType:(int)type;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
