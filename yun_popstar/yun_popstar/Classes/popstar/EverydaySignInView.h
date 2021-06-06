//
//  EverydaySignInView.h
//  yun_popstar
//
//  Created by dangfm on 2020/8/24.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EverydaySignInView : UIView<BUNativeExpressRewardedVideoAdDelegate,BUNativeExpressAdViewDelegate>
@property(nonatomic,retain) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (retain,nonatomic) NSString *ad_start_time;
@property (assign,nonatomic) long requestid;
@property (retain,nonatomic) BUNativeExpressAdManager *nativeExpressAdManager;
@property (retain,nonatomic) NSMutableArray *expressAdViews;
@property (retain,nonatomic) UIView *expressViewBox;
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) UIImageView *giftImg;
@property(nonatomic,retain) UIButton *giftNumber;
@property(nonatomic,assign) int giftTag;
@property(nonatomic,assign) int giftTagNumber;
@property(nonatomic,retain) UIButton *closeBt;
@property(nonatomic,retain) UIButton *otherBt;
@property(nonatomic,retain) UIButton *signBt;
@property(nonatomic,retain) UIButton *signBt2;
@property(nonatomic,retain) NSMutableArray *signButtons;
@property (nonatomic, strong) YunPopstarSay *say;
@property(nonatomic,copy) void(^clickButtonBlock)(UIButton *button);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
