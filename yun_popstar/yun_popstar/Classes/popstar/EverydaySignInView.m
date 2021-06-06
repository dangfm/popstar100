//
//  EverydaySignInView.m
//  yun_popstar
//
//  Created by dangfm on 2020/8/24.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "EverydaySignInView.h"

@implementation EverydaySignInView

// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static EverydaySignInView *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _sharedSingleton = [[self alloc] init];
        [_sharedSingleton initViews];
    });
    return _sharedSingleton;
}

-(void)initSay{
    self.say = [YunPopstarSay new];
}

-(void)show{
    _otherBt.enabled = YES;
    _closeBt.enabled = YES;
    _signBt.enabled = YES;
    _signBt2.enabled = YES;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    
    [self startOtherButtons];
    
    [self loadFeedAds];
    
    if ([[YunConfig getConfig].is_open_ad intValue]<=0) {
        _signBt2.hidden = YES;
    }else{
        _signBt2.hidden = NO;
    }
    
    [self getHttpSignList];
}
-(void)initViews{
    [self initSay];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [[AppDelegate sharedSingleton].window addSubview:self];
    
    float w = UIScreenWidth-60;
    float h = UIScreenWidth + 30;
    float x = 30;
    float y = kNavigationHeight;
    float corner = 30;
    float padding = 20;
    if (iPhone4 || iPhone5 || iPhone6) {
        h = UIScreenWidth-10;
        y = 30;
    }
    if ([[YunConfig getConfig].open_ads indexOf: kCsj_sloteid_945470606]==NSNotFound) {
        y = (UIScreenHeight-h)/2;
        if (iPhone4 || iPhone5 || iPhone6) {
            h = UIScreenWidth;
        }
    }
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.8;
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickButton:)];
    //[self.maskView addGestureRecognizer:tap];
    //[self.maskView setUserInteractionEnabled:YES];
    [self addSubview:self.maskView];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.mainView.backgroundColor = [[UIColor colorWithPatternImage:FMDefaultBackgroundImage] colorWithAlphaComponent:1];
    self.mainView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    self.mainView.layer.borderWidth = 3;
    self.mainView.layer.cornerRadius = corner;
    //self.mainView.userInteractionEnabled = NO;
    [self addSubview:self.mainView];
    
    FBGlowLabel *titleLb = [[FBGlowLabel alloc] initWithFrame:CGRectMake(0, 0, w, 70)];
    titleLb.text = @"每日签到";
    titleLb.font = kFontBold(35);
    if (iPhone4 || iPhone5 || iPhone6) {
        titleLb.font = kFontBold(25);
    }
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor whiteColor];
    titleLb.glowSize = 20;
    titleLb.innerGlowSize = 4;
    titleLb.textColor = UIColor.whiteColor;
    titleLb.glowColor = UIColorFromRGB(0x5832b9);
    titleLb.innerGlowColor = UIColorFromRGB(0xc44c4e);

    [self.mainView addSubview:titleLb];
    
    [self createEveryDayView];
    
    // 关闭按钮
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake(w-30-20, 20, 30, 30)];
    [closeBt setImage:[UIImage imageNamed:@"lz_close_bt"] forState:UIControlStateNormal];
    closeBt.tag = 2;
    [closeBt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:closeBt];
    _closeBt = closeBt;
    

    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    w = 170;
    h = bg.size.height/bg.size.width * w;
    x = (self.mainView.frame.size.width - w) / 2;
    y = self.mainView.frame.size.height - 2*(h + padding)+25;
    
    UIButton *bt = [UIButton createAdButton:@"领取双倍" frame:CGRectMake(x, y, w, h)];
    [self startButtonAnimation:bt];
    [bt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    bt.tag = 0;
    [self.mainView addSubview:bt];
    _signBt2 = bt;
    bt = nil;
    // 领取双倍
    w = 140;
    h = bg.size.height/bg.size.width * w;
    x = (self.mainView.frame.size.width - w) / 2;
//    y += 5;
    UIButton *bt2 = [UIButton createDefaultButton:@"签到" frame:CGRectMake(x, y+padding+h, w, h)];
    //[self startButtonAnimation:bt2];
    [bt2 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    bt2.tag = 1;
    [self.mainView addSubview:bt2];
    _signBt = bt2;
    bt2 = nil;

    
    //self.transform = CGAffineTransformScale(self.transform, 0, 0);
}


-(void)startButtonAnimation:(UIButton*)bt{
        //[[self.startButton layer] removeAllAnimations];
        //放大效果，并回到原位
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //速度控制函数，控制动画运行的节奏
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration=0.5;      //执行时间
        animation.repeatCount=4;      //执行次数
        animation.autoreverses=YES;    //完成动画后会回到执行动画之前的状态
        animation.fromValue= [NSNumber numberWithFloat:1.0];  //初始伸缩倍数
        animation.toValue= [NSNumber numberWithFloat:1.1];    //结束伸缩倍数
        [[bt layer] addAnimation:animation forKey:nil];
        
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [__weakSelf startButtonAnimation:bt];
        });
 
    
}

// 每日签到
-(void)createEveryDayView{
    YunConfig *config = [YunConfig getConfig];
    _signButtons = [NSMutableArray new];
    // 工具按钮
    float padding = 10;
    float x = 30;
    float y = 70;
    
    
    if (iPhone4 || iPhone5 || iPhone6) {
        y = 60;
        padding = 5;
    }
    float w = (self.mainView.frame.size.width-2*x-3*padding) / 4;
    float h = w * 14/10;
    NSArray *golds = [config.everyday_sign_gold mj_JSONObject];
    int day = 1;
    for (NSString *num in golds) {
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        bt.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
        bt.layer.borderWidth = 2;
        bt.layer.cornerRadius = 10;
        bt.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
        bt.tag = day;
        
        // 第几天
        YunLabel *l = [[YunLabel alloc] initWithFrame:CGRectMake(0, 0, w, 30) borderWidth:3 borderColor:UIColorFromRGB(0x6f3c9f)];
        l.text = [NSString stringWithFormat:@"第%d天",day];
        l.font = kFontBold(16);
        l.textColor = [UIColor whiteColor];
        l.adjustsFontSizeToFitWidth = YES;
        l.textAlignment = NSTextAlignmentCenter;
        [bt addSubview:l];
        
        // 图标
        UIImage *image = [UIImage imageNamed:@"more_gold_icon"];
        float iw = w - 30;
        image = [UIImage scaleToSize:image size:CGSizeMake(iw, iw*image.size.height/image.size.width)];
        [bt setImage:image forState:UIControlStateNormal];
        
        // 打勾
        UIImage *gou = [UIImage imageNamed:@"sign_tick_icon"];
        float ih = h/2;
        iw = ih*gou.size.width/gou.size.height;
        gou = [UIImage scaleToSize:gou size:CGSizeMake(iw, ih)];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(bt.frame.size.width-iw+10, bt.frame.size.height-ih+10, iw, ih)];
        iv.image = gou;
        iv.tag = 101;
        iv.alpha = 0.8;
        [bt addSubview:iv];
        iv.hidden = YES;
        
        // 数量
        YunLabel *d = [[YunLabel alloc] initWithFrame:CGRectMake(0, h-30, w, 30) borderWidth:3 borderColor:UIColorFromRGB(0x6f3c9f)];
        d.text = [NSString stringWithFormat:@"x %@",num];
        d.font = kFontBold(14);
        d.textColor = [UIColor whiteColor];
        d.adjustsFontSizeToFitWidth = YES;
        d.textAlignment = NSTextAlignmentCenter;
        [bt addSubview:d];
        
        [self.mainView addSubview:bt];
        [_signButtons addObject:bt];
        day ++;
        x += w + padding;
        if (day%5==0) {
            y += h + 20;
            x = 30 + w / 2 + padding/2;
        }
    }
    
    // 已签到数据
    NSMutableArray *signeds = [YunConfig getUserEverydaySign];
    if (signeds) {
        [self setSignInButtonsWithDay:(int)signeds.count];
    }
    
    

}

// 设置已签到的按钮勾选状态
-(void)setSignInButtonsWithDay:(int)day{
    for (UIButton*bt in _signButtons) {
        UIImageView * gou = [bt viewWithTag:101];
        if (bt.tag<=day) {
            if (gou) {
                gou.hidden = NO;
            }
        }else{
            if (gou) {
                gou.hidden = YES;
            }
        }
        
    }
}
// 签到动画
-(void)signAnimation:(UIButton*)bt{
    YunConfig *config = [YunConfig getConfig];
    NSArray *everydaysigngolds = [config.everyday_sign_gold mj_JSONObject];
    int tag = (int)bt.tag-1;
    if (tag>=0 && tag<everydaysigngolds.count) {
        // 签到奖励的金币数量
        int gold = [everydaysigngolds[tag] intValue];
        
        // 签到按钮放大效果
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //速度控制函数，控制动画运行的节奏
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration=0.5;      //执行时间
        animation.repeatCount=1;      //执行次数
        animation.autoreverses=YES;    //完成动画后会回到执行动画之前的状态
        animation.fromValue= [NSNumber numberWithFloat:1.0];  //初始伸缩倍数
        animation.toValue= [NSNumber numberWithFloat:1.2];    //结束伸缩倍数
        [[bt layer] addAnimation:animation forKey:nil];
        
        [self.say peng];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MobClick beginEvent:@"home_signin_gold"];
            // 奖励金币
            [[YunGetGoldView sharedSingleton] show:gold intro:@"签到奖励金币" type:1];
            [YunGetGoldView sharedSingleton].hideBlock = ^{
               [MobClick endEvent:@"home_signin_gold"];
            };
        });
    }
    
    
    
    
}


-(void)hide{
    self.hidden = YES;
}

// 关闭按钮和不用谢谢按钮，慢慢显示
-(void)startOtherButtons{
    _closeBt.alpha = 0;
    _otherBt.alpha = 0;
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            __weakSelf.closeBt.alpha = 1;
            __weakSelf.otherBt.alpha = 1;
        }];
    });
    
}

-(void)clickButton:(UIButton*)button{
    if (button) {
        button.enabled = NO;
        if ([[button class] isEqual:[UIButton class]]) {
            [self.say touchButton];
            if (button.tag==1) {
                // 点击签到
                [self signAction:1];
            }
            if (button.tag==0) {
                // 点击领取双倍
                [self openAd];
                
            }
            
            if (button.tag==2) {
                // 关闭按钮
                if (self.clickButtonBlock) {
                    self.clickButtonBlock(button);
                }
                
                [self hide];
            }
        }
       
        
    }
    
}

-(void)openAd{
    // 领取奖励看广告
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = [YunConfig getUserId];;
    self.rewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:kCsj_sloteid_945464448 rewardedVideoModel:model];
    //self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:@"945438638" adloadSeq:1 primeRit:@"945438638" rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
    [MobClick beginEvent:@"everydaysign_video_ad"];
    self.ad_start_time = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    self.requestid = [fn getTimestamp];
    [http sendApiUserAd:@"双倍签到的激励视频广告" type:0 ad:kCsj_sloteid_945464448 start_time:self.ad_start_time end_time:@"" requestid:self.requestid];
}

-(void)signAction:(int)num{
    YunConfig *config = [YunConfig getConfig];
    NSArray *everydaysigngolds = [config.everyday_sign_gold mj_JSONObject];
    NSMutableArray *signeds = [YunConfig getUserEverydaySign];
    // 签到奖励的金币数量
    int i = (int)signeds.count - 1;
    if (i<=0) {
        i = 0;
    }
    int gold = [everydaysigngolds[i] intValue];
    NSDictionary *params = @{
        @"day":@(signeds.count+1).stringValue,
        @"gold":@(gold).stringValue,
        @"levels":@([YunConfig getUserPassNumber]).stringValue,
        @"intro":@"首页签到",
        @"num":@(num).stringValue,
        @"requestid":@([fn getTimestamp]).stringValue
    };
    WEAKSELF
    [http sendPostRequestWithParams:params api:kAPI_Users_AddEverydaySign start:^{
        [SVProgressHUD show];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"签到失败，网络不给力"];
    } success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        int code = [dic[@"code"] intValue];
        if (code==200) {
            // 已签到数据
            [YunConfig setUserEverydaySign:[NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd"]];
            NSMutableArray *signeds = [YunConfig getUserEverydaySign];
            int samount = (int)signeds.count-1;
            if (samount<=0) {
                samount = 0;
            }
            [__weakSelf setSignInButtonsWithDay:(int)signeds.count];
            // 签到动画
            [__weakSelf signAnimation:__weakSelf.signButtons[samount]];

            [__weakSelf performSelector:@selector(hide) withObject:nil afterDelay:1.5];
        }else{
            if ([[YunConfig getConfig].is_open_ad intValue]<=0) {
                [SVProgressHUD showErrorWithStatus:@"已签到"];
            }else{
                FMHttpShowError(dic)
            }
            //[__weakSelf hide];
        }
        
    }];
}

-(void)getHttpSignList{
    WEAKSELF
    [http sendPostRequestWithParams:nil api:kAPI_Users_SignList start:^{
        [SVProgressHUD show];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"签到历史获取失败，网络不给力"];
    } success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        int code = [dic[@"code"] intValue];
        if (code==200) {
            // 已签到数据
            NSArray *list = dic[@"data"];
            NSMutableArray *dates = [NSMutableArray new];
            for (NSDictionary*item in list) {
                NSString *created_at = item[@"created_at"];
                created_at = [created_at substringToIndex:10];
                if ([dates indexOfObject:created_at]==NSNotFound) {
                    [dates addObject:created_at];
                }
                
            }
//            if (dates.count>=7) {
//                [dates removeAllObjects];
//            }
            [YunConfig seting:kConfig_User_EverydaySign value:[dates mj_JSONString]];
            // 已签到数据
            NSMutableArray *signeds = [YunConfig getUserEverydaySign];
            if (signeds) {
                [__weakSelf setSignInButtonsWithDay:(int)signeds.count];
            }
        }else{
            FMHttpShowError(dic)
            //[__weakSelf hide];
        }
    }];
}


// 信息流广告
- (void)loadFeedAds {
    YunConfig *config = [YunConfig getConfig];
    if (config) {
        if([config.open_ads indexOf:kCsj_sloteid_945470606]!=NSNotFound && [config.is_open_ad intValue]>0){
            if (!_expressViewBox) {
                float x = self.mainView.frame.origin.x;
                float w = self.mainView.frame.size.width;
                float y = self.mainView.frame.origin.y+self.mainView.frame.size.height+10;
                float h = UIScreenHeight - y;
                _expressViewBox = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
                [self addSubview:_expressViewBox];
            }
            self.expressAdViews = [NSMutableArray new];
            BUAdSlot *slot1 = [[BUAdSlot alloc] init];
            slot1.ID = kCsj_sloteid_945470606;
            slot1.AdType = BUAdSlotAdTypeFeed;
            BUSize *imgSize = [BUSize sizeBy:BUProposalSize_Banner690_388];
            slot1.imgSize = imgSize;
            slot1.position = BUAdSlotPositionFeed;
            slot1.isSupportDeepLink = YES;
            
            float w = self.mainView.frame.size.width;
            float h = self.expressViewBox.frame.size.height-10;
            if (h>self.expressViewBox.frame.size.height) {
                h = self.expressViewBox.frame.size.height;
                w = 600.0/260.0 * h;
            }
            self.nativeExpressAdManager = [[BUNativeExpressAdManager alloc] initWithSlot:slot1 adSize:CGSizeMake(w, h)];
            self.nativeExpressAdManager.delegate = self;
            [self.nativeExpressAdManager loadAd:1];
        }
        
    }
    

}
- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAd views:(NSArray<__kindof BUNativeExpressAdView *> *)views {
    [self.expressAdViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.expressAdViews removeAllObjects];//【重要】不能保存太多view，需要在合适的时机手动释放不用的，否则内存会过大
    if (views.count) {
        [self.expressViewBox.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.expressAdViews addObjectsFromArray:views];
        WEAKSELF
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BUNativeExpressAdView *expressView = (BUNativeExpressAdView *)obj;
            expressView.rootViewController = [AppDelegate sharedSingleton].window.rootViewController;
            [expressView render];
            [__weakSelf.expressViewBox addSubview:expressView];
        }];
    }
    NSLog(@"【BytedanceUnion】个性化模板拉取广告成功回调");
}

-(void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView{
    // 点击
    if (iPhone4 || iPhone6 || iPhone5) {
        [[AppDelegate sharedSingleton].window sendSubviewToBack:self];
    }
    
    
}
- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAd error:(NSError *)error {

}

- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView {
    
}

- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords{
    //【重要】需要在点击叉以后 在这个回调中移除视图，否则，会出现用户点击叉无效的情况
    [self.expressAdViews removeObject:nativeExpressAdView];

}

// 广告回调

#pragma mark - BUNativeExpressRewardedVideoAdDelegate
//加载广告的时候，delegate 传的是self，广告事件发生后会自动回调回来，我们只需要重新实现这些方法即可
- (void)nativeExpressRewardedVideoAdDidLoad:
(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
    NSLog(@"展示奖励视频广告");
    if(self.rewardedVideoAd.isAdValid){
        [[AppDelegate sharedSingleton].window sendSubviewToBack:self];
        UINavigationController *n = (UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController;
        [self.rewardedVideoAd showAdFromRootViewController:n];
        
    }
}

- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    NSLog(@"%s",__func__);
    NSLog(@"error code : %ld , error message : %@",(long)error.code,error.description);
}

- (void)nativeExpressRewardedVideoAdCallback:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd withType:(BUNativeExpressRewardedVideoAdType)nativeExpressVideoType{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdViewRenderSuccess:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {
    NSLog(@"%s",__func__);
    NSLog(@"视频广告渲染错误");
  
}

- (void)nativeExpressRewardedVideoAdWillVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdWillClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
    NSLog(@"看完广告返回 发放奖励");
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    [MobClick endEvent:@"everydaysign_video_ad"];
    // 看视频后双倍奖励
    [http sendApiUserAd:@"双倍签到的激励视频广告" type:0 ad:kCsj_sloteid_945464448 start_time:self.ad_start_time end_time:[NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"] requestid:self.requestid];
    
    
    [self signAction:2];
}

- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
    NSLog(@"加载激励视频错误");
    
}

- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdDidCloseOtherController:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd interactionType:(BUInteractionType)interactionType {
    NSString *str = nil;
    if (interactionType == BUInteractionTypePage) {
        str = @"ladingpage";
    } else if (interactionType == BUInteractionTypeVideoAdDetail) {
        str = @"videoDetail";
    } else {
        str = @"appstoreInApp";
    }
    NSLog(@"%s __ %@",__func__,str);
}

@end
