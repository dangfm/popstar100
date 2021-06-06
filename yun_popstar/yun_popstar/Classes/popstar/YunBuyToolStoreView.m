//
//  YunBuyToolStoreView.m
//  yun_popstar
//
//  Created by dangfm on 2020/8/27.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunBuyToolStoreView.h"

#define kYunBuyToolStoreView_list @[@{@"n":@"+1",@"b":@"0"},@{@"n":@"+1",@"b":@"100"},@{@"n":@"+5",@"b":@"400"},@{@"n":@"+9",@"b":@"700"}]
#define kYunBuyToolStoreView_iconnames @[@"lz_tool_refresh",@"lz_tool_bomb",@"lz_tool_magic",@"more_gold_icon.png"]
@implementation YunBuyToolStoreView

// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunBuyToolStoreView *_sharedSingleton = nil;
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

-(void)show:(int)num{
    _giftTag = num;
    [self show];
}

-(void)show{
    
    _maskView.alpha = 0.8;
    _mainView.alpha = 1;
    _mainView.hidden = NO;
    self.alpha = 1;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    [self createListView];
    [self startOtherButtons];
    [self showLastGold];
}
-(void)initViews{
    self.alpha = 1;
    [self initSay];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [[AppDelegate sharedSingleton].window addSubview:self];
    
    float w = UIScreenWidth-60;
    float h = w + 30;
    float x = 30;
    float y = (UIScreenHeight-h)/2;
    float corner = 30;
    
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.8;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//    [self.maskView addGestureRecognizer:tap];
//    [self.maskView setUserInteractionEnabled:YES];
    [self addSubview:self.maskView];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.mainView.backgroundColor = [[UIColor colorWithPatternImage:FMDefaultBackgroundImage] colorWithAlphaComponent:1];
    self.mainView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    self.mainView.layer.borderWidth = 3;
    self.mainView.layer.cornerRadius = corner;
    [self addSubview:self.mainView];
    
    // 金币总数
    [self createMyGoldView];
    
    
    // 关闭按钮
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake(w-30-20, 20, 30, 30)];
    [closeBt setImage:[UIImage imageNamed:@"lz_close_bt"] forState:UIControlStateNormal];
    closeBt.tag = 2;
    [closeBt addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:closeBt];
    _closeBt = closeBt;
    
    
    
    
    //self.transform = CGAffineTransformScale(self.transform, 0, 0);
}

-(void)createMyGoldView{
    float h = 35;
    float y = 30;
    float w = 150;

    float x = (self.mainView.frame.size.width - w) / 2;
    UIFont *font = kFontBold(14);
    float add_w = 30;
    UIButton *bt = [[UIButton alloc] init];
    bt.frame = CGRectMake(x, y, w, h);
    bt.layer.cornerRadius = h/2;
    bt.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
    bt.layer.borderWidth = 1;
    bt.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    //[bt setTitle:@"45" forState:UIControlStateNormal];
    //[bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bt.titleLabel.textAlignment = NSTextAlignmentCenter;

    bt.layer.shadowColor = UIColorFromRGB(0x5b331b).CGColor;//阴影颜色
    bt.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    bt.layer.shadowOpacity = 0.3;//不透明度
    bt.layer.shadowRadius = 3.0;//半径

    //bt.alpha = 0.8;
    [self.mainView addSubview:bt];
    
    UILabel *jb_title = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 40, h-4)];
    jb_title.text = @"金币";
    jb_title.textColor = UIColorFromRGB(0x5832b9);//[UIColor colorWithPatternImage:[UIImage imageNamed:[YunConfig getUserBackgroundImageName]]];
    jb_title.font = [UIFont systemFontOfSize:12 weight:200];;
    jb_title.textAlignment = NSTextAlignmentCenter;
    jb_title.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    jb_title.layer.cornerRadius = h/2-2;
    jb_title.layer.masksToBounds = YES;
    [bt addSubview:jb_title];

    
    UILabel *xx = [[UILabel alloc] initWithFrame:CGRectMake(jb_title.frame.size.width+5, 0, w-jb_title.frame.size.width-add_w-10, h)];
    xx.text = @"0";
    xx.textColor = [UIColor whiteColor];
    xx.font = font;
    xx.textAlignment = NSTextAlignmentCenter;
    xx.adjustsFontSizeToFitWidth = YES;
    //xx.alpha = 0.8;
    [bt addSubview:xx];
    _userGold = xx;
    
    UIImageView *xx_add = [[UIImageView alloc] init];
    xx_add.image = [UIImage imageNamed:@"lz_coin"];
    //xx_add.image = [xx_add.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //[xx_add setTintColor:[UIColor whiteColor]];
    xx_add.frame = CGRectMake(bt.frame.origin.x+bt.frame.size.width-add_w-2.5, y+2.5, add_w, add_w);
    [self.mainView addSubview:xx_add];
    
}

// 获得金币
-(void)showLastGold{
    _userGold.text = [NSString stringWithFormat:@"%d",[YunConfig getUserGold]];
}

-(void)createListView{
    if (!_listViews) {
        _listViews = [NSMutableArray new];
    }else{
        for (UIButton *v in _listViews) {
            [v removeFromSuperview];
        }
        [_listViews removeAllObjects];
    }
    NSArray *titles = kYunBuyToolStoreView_list;
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    float padding = 20;
    float w = (self.mainView.frame.size.width - 60) / 2;
    float h = bg.size.height/bg.size.width * w;
    float x = 30;
    float y = self.mainView.frame.size.height - titles.count*(h+padding) - padding;
    
    if (self.giftTag>3) {
        self.giftTag = 0;
    }
    NSArray *iconnames = kYunBuyToolStoreView_iconnames;
    NSString *iconname = iconnames[self.giftTag];
    
    YunConfig *config = [YunConfig getConfig];
    
    for (int i=0; i<titles.count; i++) {
        NSDictionary *item = titles[i];
        NSString *n = item[@"n"];
        NSString *b = item[@"b"];
        
        
        // 图标
        UIButton *iv = [self createGiftView:iconname];
        iv.frame = CGRectMake(x, y, iv.frame.size.width, iv.frame.size.height);
        [self.mainView addSubview:iv];
        // 数量
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(x + h +20, y, h, h)];
        l.text = n;
        l.font = kFontBold(22);
        l.textColor = [UIColor whiteColor];
        [self.mainView addSubview:l];
        
        UIButton *bt = [UIButton createGoldButton:b frame:CGRectMake(self.mainView.frame.size.width-30 - w, y, w, h)];
        if ([b intValue]==0) {
            bt = [UIButton createAdButton:@"免费领取" frame:CGRectMake(self.mainView.frame.size.width-30 - w, y, w, h)];
        }
        [bt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        bt.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        bt.tag = i;
        bt.alpha = 0.9;
        [self.mainView addSubview:bt];
        
        
        
        [bt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_listViews addObject:bt];
        if ([config.is_open_ad intValue]<=0 && [b intValue]==0) {
            l.hidden = YES;
            bt.hidden = YES;
            
        }else{
            y += h + padding;
        }
        
        bt = nil;
        
    }
}


-(UIButton*)createGiftView:(NSString*)iconname{
    
    // 工具按钮
    float w = 40;
    float x = 0;
    float ww = w-10;
    float xxx = (w-ww) / 2;
    float yyy = (w-ww) / 2;
    float y = 0;
    float h = w;
    
    UIButton *tool1_bg = [[UIButton alloc] init];
    tool1_bg.frame = CGRectMake(x, y, w, h);
    tool1_bg.layer.borderWidth = 5;
    tool1_bg.layer.cornerRadius = w/2;
    tool1_bg.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    tool1_bg.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    UIImageView *tool1_megic_bg = [[UIImageView alloc] initWithFrame:CGRectMake(-2, -2, tool1_bg.frame.size.width+4, tool1_bg.frame.size.height+4)];
    tool1_megic_bg.image = [UIImage imageNamed:@"megic_tool_bg"];
    [tool1_bg addSubview:tool1_megic_bg];
    
    
    UIImageView *tool1 = [[UIImageView alloc] init];
    tool1.image = [UIImage imageNamed:iconname];
    tool1.frame = CGRectMake(xxx, yyy, ww, tool1.image.size.height/tool1.image.size.width * ww);
    tool1.layer.shadowColor = UIColorFromRGB(0x5b331b).CGColor;//阴影颜色
    tool1.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    tool1.layer.shadowOpacity = 0.3;//不透明度
    tool1.layer.shadowRadius = 3.0;//半径
    [tool1_bg addSubview:tool1];
    
    return tool1_bg;
}

// 关闭按钮和不用谢谢按钮，慢慢显示
-(void)startOtherButtons{
    _closeBt.alpha = 1;
    _otherBt.alpha = 1;
//    WEAKSELF
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:3 animations:^{
//            __weakSelf.closeBt.alpha = 1;
//            __weakSelf.otherBt.alpha = 1;
//        }];
//    });
    
}

-(void)hide{
    self.hidden = YES;
}

// 点击购买按钮后，放大并把商品移动到中间，然后渐变消失
-(void)hideSelf:(void(^)(void))block{
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.mainView.hidden = YES;
    int tag = (int)_selectBt.tag;
    NSDictionary *item = kYunBuyToolStoreView_list[tag];
    int n = [item[@"n"] intValue]; // 数量
    //int b = [item[@"b"] intValue]; // 小计
    __block float tt = 0;
    
    // 发光
    if (!_light_bg) {
        float w = UIScreenWidth * 1.0;
        UIImageView *light = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenWidth-w)/2, (UIScreenHeight-w)/2, w, w)];
        light.image = [UIImage imageNamed:@"light_bg"];
        light.alpha = 0;
        [self addSubview:light];
        _light_bg = light;
        
        UIImageView *light2 = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenWidth-w)/2, (UIScreenHeight-w)/2, w, w)];
        light2.image = [UIImage imageNamed:@"light_bg"];
        light2.alpha = 0;
        [self addSubview:light2];
        _light_bg_2 = light2;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 2.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = NSNotFound;
    //在图片边缘添加一个像素的透明区域，去图片锯齿
//    CGRect imageRrect = CGRectMake(0, 0,_light_bg.frame.size.width, _light_bg.frame.size.height);
//    UIGraphicsBeginImageContext(imageRrect.size);
//    [_light_bg.image drawInRect:CGRectMake(1,1,_light_bg.frame.size.width-2,_light_bg.frame.size.height-2)];
//    _light_bg.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    [_light_bg.layer addAnimation:animation forKey:nil];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath: @"transform" ];
    animation2.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation2.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation( 1.0,0.0, 0.0,M_PI) ];
    animation2.duration = 2.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation2.cumulative = YES;
    animation2.repeatCount = NSNotFound;
    //在图片边缘添加一个像素的透明区域，去图片锯齿
//    CGRect imageRrect2 = CGRectMake(0, 0,_light_bg_2.frame.size.width, _light_bg_2.frame.size.height);
//    UIGraphicsBeginImageContext(imageRrect2.size);
//    [_light_bg_2.image drawInRect:CGRectMake(1,1,_light_bg_2.frame.size.width-2,_light_bg_2.frame.size.height-2)];
//    _light_bg_2.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    [_light_bg_2.layer addAnimation:animation2 forKey:nil];
    
    
    for (int i=0; i<n; i++) {
        NSArray *iconnames = kYunBuyToolStoreView_iconnames;
        NSString *iconname = iconnames[self.giftTag];
        UIButton *gift = [self createGiftView:iconname];
        gift.frame = CGRectMake((UIScreenWidth - gift.frame.size.width)/2, (UIScreenHeight-gift.frame.size.height)/2, gift.frame.size.width, gift.frame.size.height);
        [self addSubview:gift];
        gift.tag = i;
        gift.alpha = 0;
        gift.transform = CGAffineTransformMakeScale(0, 0);
        [self performSelector:@selector(animationForGift:) withObject:gift afterDelay:tt];
        tt+=0.1;
    }
    
    
}
-(void)animationForGift:(UIButton*)gift{
    WEAKSELF
    
    // 工具按钮
    float w = UIScreenWidth / 7;
    float padding = 15;
    float x = (UIScreenWidth - (3*w+2*padding))/2;
    float y = 22;
    float h = 30;
    if (iPhoneX || iPhoneXsMax || iPhoneXR) {
        y = 44;
    }
    y += 30;
    y += h+20+70;
    
    if (self.giftTag<3) {
        x += self.giftTag * (w+padding);
    }
    
    int tag = (int)_selectBt.tag;
    NSDictionary *item = kYunBuyToolStoreView_list[tag];
    int n = [item[@"n"] intValue]; // 数量
    
    [self.say lighting];
    
    [UIView animateWithDuration:(0.3) animations:^{
        gift.alpha = 1;
        gift.transform = CGAffineTransformMakeScale(2, 2);
        __weakSelf.light_bg.alpha = 1;
        __weakSelf.light_bg_2.alpha = 1;
    } completion:^(BOOL finished) {
        // 完成后飞到工具栏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.1 animations:^{
                gift.transform = CGAffineTransformMakeScale(1, 1);
                gift.frame = CGRectMake(x, y, w, w);
                gift.layer.cornerRadius = (w)/2;
                gift.alpha = 0.5;
                if (gift.tag==n-1) {
                    __weakSelf.maskView.alpha = 0;
                    __weakSelf.light_bg.alpha = 0;
                    __weakSelf.light_bg_2.alpha = 0;
                }
            } completion:^(BOOL finished) {
                [__weakSelf.say get_tool_success];
                if (gift.tag==n-1) {
                    __weakSelf.hidden = YES;
                    __weakSelf.light_bg.alpha = 0;
                    __weakSelf.light_bg_2.alpha = 0;
                }
                [gift removeFromSuperview];
                
            }];
        });
        
    }];
}

-(void)clickButton:(UIButton*)button{
    [self.say say:@"lz_touch_on.wav"];
    WEAKSELF
    int tag = (int)button.tag;
    NSDictionary *item = kYunBuyToolStoreView_list[tag];
    int n = [item[@"n"] intValue]; // 数量
    int b = [item[@"b"] intValue]; // 小计
    _selectBt = button;
    if (b>0) {
        // 购买
        float balance = [YunConfig getUserGold];
        if (balance<b) {
            [[YunShowMsg sharedSingleton] show:@"金币不足哦！"];
            return;
        }else{
            balance -= b;
            // 购买成功
            if (self.giftTag==0) {
                int amount = [YunConfig getUserRefreshAmount];
                amount += n;
                [YunConfig setUserRefreshAmount:amount];
                [YunConfig setUserGold:balance];
                // 购买道具
                [http sendApiUserGold:@"购买刷新道具" type:4 gold:-b];
            }
            if (self.giftTag==1) {
                int amount = [YunConfig getUserBombAmount];
                amount += n;
                [YunConfig setUserBombAmount:amount];
                [YunConfig setUserGold:balance];
                // 购买道具
                [http sendApiUserGold:@"购买爆破道具" type:4 gold:-b];
            }
            if (self.giftTag==2) {
                int amount = [YunConfig getUserMagicAmount];
                amount += n;
                [YunConfig setUserMagicAmount:amount];
                [YunConfig setUserGold:balance];
                // 购买道具
                [http sendApiUserGold:@"购买魔术笔道具" type:4 gold:-b];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GetCoin object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_ToolFinished object:nil];
            
            
            //[[YunShowMsg sharedSingleton] show:@"兑换成功！"];
            [self hideSelf:^{
                if (__weakSelf.magicBlock) {
                    __weakSelf.magicBlock(button,(int)button.tag);
                }
            }];
            return;
        }
    }else{
        // 看广告的工具
        ///
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
        model.userId = [YunConfig getUserId];;
        self.rewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:kCsj_sloteid_945438638 rewardedVideoModel:model];
        //self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:@"945438638" adloadSeq:1 primeRit:@"945438638" rewardedVideoModel:model];
        self.rewardedVideoAd.delegate = self;
        [self.rewardedVideoAd loadAdData];
        [MobClick beginEvent:@"buytool_video_ad"];
        //[self.rewardedVideoAd showAdFromRootViewController:n ritScene:BURitSceneType_game_gift_bonus ritSceneDescribe:@""];
        self.ad_start_time = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
        self.requestid = [fn getTimestamp];
        [http sendApiUserAd:@"点击购买道具的激励视频广告" type:0 ad:kCsj_sloteid_945438638 start_time:self.ad_start_time end_time:@"" requestid:self.requestid];
        
        return;
    }
    
    
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
        // 更新广告弹出时间
        //[YunConfig seting:kConfig_User_clearance_show_ad_lasttime value:@([fn getTimestamp]).stringValue];
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
    
    [MobClick endEvent:@"buytool_video_ad"];
    // 购买成功
    if (self.giftTag==0) {
      int amount = [YunConfig getUserRefreshAmount];
      amount += 1;
      [YunConfig setUserRefreshAmount:amount];
     
    }
    if (self.giftTag==1) {
      int amount = [YunConfig getUserBombAmount];
      amount += 1;
      [YunConfig setUserBombAmount:amount];

    }
    if (self.giftTag==2) {
      int amount = [YunConfig getUserMagicAmount];
      amount += 1;
      [YunConfig setUserMagicAmount:amount];

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GetCoin object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_ToolFinished object:nil];
    
    //[[YunShowMsg sharedSingleton] show:@"兑换成功！"];
    
    WEAKSELF
    [self hideSelf:^{
        if (__weakSelf.magicBlock) {
            __weakSelf.magicBlock(__weakSelf.selectBt,(int)__weakSelf.selectBt.tag);
        }
    }];
    
    [http sendApiUserAd:@"点击购买道具的激励视频广告" type:0 ad:kCsj_sloteid_945440304 start_time:self.ad_start_time end_time:[NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"] requestid:self.requestid];
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
