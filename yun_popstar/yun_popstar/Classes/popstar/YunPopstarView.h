//
//  YunPopstarView.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/6.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunPopstarButton.h"
#import "YunPopstarScoreTip.h"
#import "YunPopstarSay.h"
#import "YunPopstarHeaderView.h"
#import "YunPopstarMagicView.h"
#import "YunLittleRedEnvelopeView.h"
#import "YunGetRedEnvelope.h"
#import "YunGetGoldView.h"
#import "YunStarCommand.h"
#import "YunPlayPopStarViewController.h"
#import "YunChallengePassView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunPopstarView : UIView
@property (retain,nonatomic) UIView *starButtonsView;

@property (retain,nonatomic) NSMutableArray *linkButtons;
@property (retain,nonatomic) NSMutableDictionary *buttonStatus;
@property (assign,nonatomic) BOOL isFinished;
@property (assign,nonatomic) BOOL gameOver;
@property (assign,nonatomic) BOOL isPass;   // 是否过关
@property (assign,nonatomic) BOOL isExit;   // 是否退出
@property (assign,nonatomic) BOOL isStartPlay; // 是否开始游戏，只要点击按钮将视为开始
@property (assign,nonatomic) BOOL isShowRedenvelope;   // 是否显示红包，需要红包激活后才能显示
@property (assign,nonatomic) int gameOverLastStarCount; // 每次游戏结束，剩余多少星星
@property (assign,nonatomic) int goldAmount; // 每关卡奖励的金币数量
@property (nonatomic, strong) YunPopstarSay *say;
@property (nonatomic, strong) NSMutableArray *downButtons;
@property (nonatomic, strong) CAEmitterLayer * fireworksLayer;
@property (nonatomic, strong) YunLittleRedEnvelopeView * littleRedEnvelope; // 小红包
@property (nonatomic, strong) YunGetGoldView * getGoldView; // 金币领取效果界面
@property (retain,nonatomic) NSString *start_time; // 游戏开始时间
@property (nonatomic, assign) BOOL isChallenge;  // 是否挑战赛
@property (nonatomic, retain) NSDictionary *challenger;  // 被挑战者
-(void)free;
-(void)clear;
- (void)resetStarView;
- (instancetype)initWithFrame:(CGRect)frame isChallenge:(BOOL)isChallenge challenger:(NSDictionary*)challenger;
@end

NS_ASSUME_NONNULL_END
