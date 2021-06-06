//
//  YunPopstarHeaderView.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/11.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunPopstarNumberView.h"
#import "YunPopstarSay.h"
#import "YunPopstarPlayView.h"
#import "YunRedEnvelopeView.h"
#import "YunMeViewController.h"
#import "YunBuyToolStoreView.h"
#import "YunEnchashmentViewController.h"
#import "YunPlayPopStarViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunPopstarHeaderView : UIView
@property (assign,nonatomic) int totalNumber;
@property (assign,nonatomic) int currentNumber;
@property (retain,nonatomic) YunPopstarNumberView *numberView;
@property (retain,nonatomic) YunPopstarPlayView *playView;
@property (retain,nonatomic) YunRedEnvelopeView *redEnvelopeView;
@property (retain,nonatomic) UILabel *passNumber;
@property (retain,nonatomic) UILabel *targetCoin;
@property (retain,nonatomic) UILabel *userGold;
@property (retain,nonatomic) UILabel *balanceLb;
@property (nonatomic, strong) YunPopstarSay *say;
@property (assign,nonatomic) BOOL isPass;   // 是否过关

@property (retain,nonatomic) UIButton *refreshBt;
@property (retain,nonatomic) UIButton *bombBt;
@property (retain,nonatomic) UIButton *magicBt;
@property (retain,nonatomic) UIImageView *refresh_num;
@property (retain,nonatomic) UIImageView *bomb_num;
@property (retain,nonatomic) UIImageView *magic_num;
// 红包出现倒计时，红包需要爆破多少个星星才能出现
@property (retain,nonatomic) LDProgressView *redenvelope_time;
@property (retain,nonatomic) UILabel *redenvelope_time_lb;
@property (assign,nonatomic) int redenvelope_num;

@property (retain,nonatomic) YunLabel *remarkLb;
@property (nonatomic, strong) CAEmitterLayer * explosionLayer;

@property(nonatomic,copy) void(^redenvelopeTimeBlock)(BOOL show);
-(void)free;
// 红包提示，消灭一颗星星减少一个
-(void)updateRedenvelope_time:(int)num;
@end

NS_ASSUME_NONNULL_END
