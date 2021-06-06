//
//  YunCommunityViewController.h
//  yun_popstar
//
//  Created by dangfm on 2020/10/2.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunCommunityListCell.h"
#import "YunPlayStarViewBox.h"
#import "YunHomeViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunCommunityViewController : UIViewController
<BUNativeExpressRewardedVideoAdDelegate,BUNativeExpressAdViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (retain,nonatomic) NSString *ad_start_time;
@property (assign,nonatomic) long requestid;
@property (retain,nonatomic) BUNativeExpressAdManager *nativeExpressAdManager;
@property (retain,nonatomic) NSMutableArray *expressAdViews;
@property (retain,nonatomic) UIView *expressViewBox;

@property (retain,nonatomic) UIView *headerView;
@property (retain,nonatomic) YunPopstarBackgroundImageView *backgroundView;
@property (nonatomic, strong) YunPopstarSay *say;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableDictionary *initdatas;

@property (retain,nonatomic) UITableView *tableView;
@property (nonatomic, assign) int page;

@end

NS_ASSUME_NONNULL_END
