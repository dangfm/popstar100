//
//  YunPlayPopStarViewController.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/22.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunPlayCell.h"
#import "YunPlayStarViewBox.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunPlayPopStarViewController : UIViewController<BUNativeExpressRewardedVideoAdDelegate,BUNativeExpressAdViewDelegate>
@property(nonatomic,retain) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (retain,nonatomic) NSString *ad_start_time;
@property (assign,nonatomic) long requestid;
@property (retain,nonatomic) BUNativeExpressAdManager *nativeExpressAdManager;
@property (retain,nonatomic) NSMutableArray *expressAdViews;
@property (retain,nonatomic) UIView *expressViewBox;

@property (retain,nonatomic) UIView *headerView;
@property (retain,nonatomic) YunPopstarBackgroundImageView *backgroundView;
@property (nonatomic, strong) YunPopstarSay *say;
@property (retain,nonatomic) NSArray *cmds;
@property (nonatomic, strong) NSMutableArray *datas;
@property (retain,nonatomic) UITableView *tableView;
@property (nonatomic, assign) int page;
-(instancetype)initWityCmds:(NSArray*)cmds;
@end

NS_ASSUME_NONNULL_END
