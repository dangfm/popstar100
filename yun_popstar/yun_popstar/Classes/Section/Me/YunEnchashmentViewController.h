//
//  YunEnchashmentViewController.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/12.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunEnchashmentListViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunEnchashmentViewController : UIViewController<BUNativeExpressRewardedVideoAdDelegate,BUNativeExpressAdViewDelegate>
@property(nonatomic,retain) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (retain,nonatomic) NSString *ad_start_time;
@property (assign,nonatomic) long requestid;
@property (retain,nonatomic) BUNativeExpressAdManager *nativeExpressAdManager;
@property (retain,nonatomic) NSMutableArray *expressAdViews;
@property (retain,nonatomic) UIView *expressViewBox;


@property (retain,nonatomic) UIView *headerView;
@property (retain,nonatomic) UIScrollView *mainView;
@property (retain,nonatomic) YunPopstarBackgroundImageView *backgroundView;
@property (nonatomic, strong) YunPopstarSay *say;
@property (nonatomic,retain) UIView *enchashmentMoneyBts;

@property (retain,nonatomic) UILabel *mygold;
@property (retain,nonatomic) UIButton *wxface;
@property (retain,nonatomic) UILabel *nickname;
@property (retain,nonatomic) UILabel *detail;
@property (assign,nonatomic) int type;
@property (retain,nonatomic) NSString *money;


-(instancetype)initWithType:(int)type;
@end

NS_ASSUME_NONNULL_END
