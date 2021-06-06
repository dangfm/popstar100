//
//  YunPopstarChallengeHeaderView.h
//  yun_popstar
//
//  Created by dangfm on 2020/10/4.
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
#import "YunChallengeReadyGo.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunPopstarChallengeHeaderView : UIView
@property (assign,nonatomic) int totalNumber;
@property (assign,nonatomic) int currentNumber;
@property (retain,nonatomic) YunPopstarNumberView *numberView;
@property (retain,nonatomic) YunPopstarPlayView *playView;

@property (nonatomic, strong) YunPopstarSay *say;
@property (assign,nonatomic) BOOL gameOver;   // 是否结束
@property (assign,nonatomic) BOOL isPass;   // 是否过关
@property (nonatomic, assign) BOOL isChallenge;  // 是否挑战赛
@property (nonatomic, retain) NSDictionary *challenger;  // 被挑战者

@property (nonatomic,retain) UIImageView *face;
@property (nonatomic,retain) UILabel *titleLb;
@property (nonatomic,retain) UILabel *statusLb;
@property (nonatomic,retain) UILabel *metitleLb;
@property (nonatomic,retain) UIImageView *meface;
@property (nonatomic,retain) UILabel *mestatusLb;


@property (retain,nonatomic) UIButton *refreshBt;
@property (retain,nonatomic) UIButton *bombBt;
@property (retain,nonatomic) UIButton *magicBt;
@property (retain,nonatomic) UIImageView *refresh_num;
@property (retain,nonatomic) UIImageView *bomb_num;
@property (retain,nonatomic) UIImageView *magic_num;
@property (assign,nonatomic) int totalBomb;
@property (assign,nonatomic) int totalRefresh;
@property (assign,nonatomic) int totalMagic;
// 消灭星星进程
@property (retain,nonatomic) LDProgressView *redenvelope_time;
@property (retain,nonatomic) UILabel *redenvelope_time_lb;
@property (assign,nonatomic) int redenvelope_num;
@property (assign,nonatomic) int countdown; // 倒计时
@property (retain,nonatomic) UILabel *countdownLb;

@property (retain,nonatomic) YunLabel *remarkLb;
@property (nonatomic, strong) CAEmitterLayer * explosionLayer;

@property(nonatomic,copy) void(^redenvelopeTimeBlock)(BOOL show);
-(void)free;
// 红包提示，消灭一颗星星减少一个
-(void)updateRedenvelope_time:(int)num;
-(instancetype)initWithFrame:(CGRect)frame isChallenge:(BOOL)isChallenge challenger:(NSDictionary*)challenger;
@end

NS_ASSUME_NONNULL_END
