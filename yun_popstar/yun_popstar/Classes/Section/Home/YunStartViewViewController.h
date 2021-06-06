//
//  YunStartViewViewController.h
//  yun_popstar
//
//  Created by dangfm on 2020/8/20.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunPopstarBackgroundImageView.h"
#import "YunLabel.h"
#import "EverydaySignInView.h"
#import "YunBuyToolStoreView.h"
#import "YunSetingView.h"
#import "YunWinerListView.h"
#import "YunTasksView.h"
#import "YunMyDiscipleView.h"
#import "YunCommunityViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunStartViewViewController : UIViewController<BUNativeExpressRewardedVideoAdDelegate>
@property (retain,nonatomic) YunPopstarBackgroundImageView *backgroundView;
@property (retain,nonatomic) UIView *headerView;
@property (retain,nonatomic) UIView *bgViews;
@property (retain,nonatomic) UIImageView *logoView;
@property (retain,nonatomic) UIImageView *lightingView;
@property (retain,nonatomic) UIImageView *lightingView_2;
@property (retain,nonatomic) UIButton *startButton;
@property (retain,nonatomic) UIButton *communityButton;
@property (retain,nonatomic) UIView *toolView;
@property (retain,nonatomic) UILabel *userGold;
@property (retain,nonatomic) UILabel *freeAdTime;
@property (retain,nonatomic) NSString *ad_start_time;
@property (retain,nonatomic) NSArray *datas;
@property (retain,nonatomic) UILabel *canGetRedenvelopeTip;
@property (retain,nonatomic) LDProgressView *redenvelope_progress;
@property (assign,nonatomic) long requestid;
@property(nonatomic,retain) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (nonatomic, strong) YunPopstarSay *say;
@property (retain,nonatomic) UIImageView *blackboardView;
@end

NS_ASSUME_NONNULL_END
