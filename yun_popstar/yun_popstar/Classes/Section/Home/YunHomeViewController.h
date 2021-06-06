//
//  YunHomeViewController.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/3.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunPopstarView.h"
#import "YunPopstarBackgroundImageView.h"
#import "WHWeatherView.h"
#import "YunShowFirstGoldView.h"
#import "YunPopstarChallengeHeaderView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunHomeViewController : UIViewController

@property (nonatomic, strong) WHWeatherView *weatherView;
@property (retain,nonatomic) YunPopstarHeaderView *headerView;
@property (retain,nonatomic) YunPopstarChallengeHeaderView *challengeHeaderView;
@property (retain,nonatomic) YunPopstarView *starView;
@property (retain,nonatomic) YunPopstarBackgroundImageView *backgroundView;
@property (nonatomic ,strong)CAEmitterLayer *emitterLayer;
@property (nonatomic, strong) CAEmitterLayer * fireworksLayer;
@property (nonatomic, strong) YunPopstarSay *say;
@property (nonatomic, assign) BOOL isChallenge;  // 是否挑战赛
@property (nonatomic, retain) NSDictionary *challenger;  // 被挑战者
-(instancetype)initWityChallenge:(BOOL)challenge challenger:(NSDictionary*)challenger;
@end

NS_ASSUME_NONNULL_END
