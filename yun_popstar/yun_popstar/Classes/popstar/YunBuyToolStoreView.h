//
//  YunBuyToolStoreView.h
//  yun_popstar
//
//  Created by dangfm on 2020/8/27.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunPopstarSay.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunBuyToolStoreView : UIView<BUNativeExpressRewardedVideoAdDelegate>
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) UIImageView *light_bg;
@property(nonatomic,retain) UIImageView *light_bg_2;
@property(nonatomic,retain) NSMutableArray *listViews;
@property (nonatomic, strong) YunPopstarSay *say;
@property (retain,nonatomic) UILabel *userGold;
@property(nonatomic,retain) UIButton *closeBt;
@property(nonatomic,retain) UIButton *otherBt;
@property(nonatomic,retain) UIButton *selectBt;
@property(nonatomic,assign) int giftTag;
@property(nonatomic,assign) int giftTagNumber;
@property (retain,nonatomic) NSString *ad_start_time;
@property (assign,nonatomic) long requestid;

@property(nonatomic,retain) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property(nonatomic,copy) void(^magicBlock)(UIButton *button,int index);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show;
-(void)show:(int)num;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
