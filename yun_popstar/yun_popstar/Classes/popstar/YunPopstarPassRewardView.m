//
//  YunPopstarPassRewardView.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/20.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPopstarPassRewardView.h"
#import "YunGetGoldView.h"
#import "YunPopstarScoreTip.h"
@interface YunPopstarPassRewardView()<CAAnimationDelegate,BUNativeExpressRewardedVideoAdDelegate,BUNativeExpressAdViewDelegate>
@property (nonatomic,retain) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (retain,nonatomic) NSString *ad_start_time;
@property (assign,nonatomic) long requestid;
@property (retain,nonatomic) BUNativeExpressAdManager *nativeExpressAdManager;
@property (retain,nonatomic) NSMutableArray *expressAdViews;
@property (retain,nonatomic) UIView *expressViewBox;

@end

@implementation YunPopstarPassRewardView


// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunPopstarPassRewardView *_sharedSingleton = nil;
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
    _sureBt.enabled=YES;
    _closeBt.enabled=YES;
    _otherBt.enabled=YES;
    _num = num;
    _ispass = YES;
    _titleLb.text = @"过关奖励";
    _light_bg.alpha = 0;
    YunLabel *l = [_sureBt viewWithTag:101];
    YunConfig *config = [YunConfig getConfig];
    l.text = @"领取双倍";
    if ([config.is_open_ad intValue]<=0) {
        l.text = @"领取";
    }
    self.mainView.hidden = NO;
    self.maskView.alpha = 0.8;
    self.mainView.backgroundColor = [[UIColor colorWithPatternImage:FMDefaultBackgroundImage] colorWithAlphaComponent:1];
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    
    // 剩余星星比较少才奖励金币
    self.giftTag = _last_giftTag;
    
    if (_num<=[config.send_gold_when_last_num_star intValue]) {
        self.giftTag  = 2;
    }
    
    [self showGiftView];
    
    [self rndShowAdButtonStyle];
    
    [self startOtherButtons];
    
    [self loadFeedAds];
    
}
// 过关失败
-(void)showfail{
    _sureBt.enabled=YES;
    _closeBt.enabled=YES;
    _otherBt.enabled=YES;
    _ispass = NO;
    _titleLb.text = @"通关失败";
    YunLabel *l = [_sureBt viewWithTag:101];
    l.text = @"得分鼓励";
    _light_bg.alpha = 0;
    self.mainView.hidden = NO;
    self.maskView.alpha = 0.8;
    self.mainView.backgroundColor = [[UIColor colorWithPatternImage:FMDefaultBackgroundImage] colorWithAlphaComponent:0.1];;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    
    self.giftTag  = 4;
    [self showGiftView];
    
    [self rndShowAdButtonStyle];
    
    [self startOtherButtons];
    
    [self loadFeedAds];
    
}
-(void)initViews{
    [self initSay];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [[AppDelegate sharedSingleton].window addSubview:self];
    
    float w = UIScreenWidth-60;
    float h = UIScreenWidth;
    float x = 30;
    float corner = 30;
    float padding = 20;
    
    float y = kNavigationHeight;
    if (iPhone4 || iPhone5 || iPhone6) {
        h = 300;
        y = 30;
    }
    if ([[YunConfig getConfig].open_ads indexOf: kCsj_sloteid_945478871]==NSNotFound) {
        h = UIScreenWidth;
        y = (UIScreenHeight-h)/2;
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
    
    FBGlowLabel *titleLb = [[FBGlowLabel alloc] initWithFrame:CGRectMake(0, 0, w, 100)];
    titleLb.text = @"过关奖励";
    titleLb.font = kFontBold(35);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor whiteColor];
    titleLb.glowSize = 20;
    titleLb.innerGlowSize = 4;
    titleLb.textColor = UIColor.whiteColor;
    titleLb.glowColor = UIColorFromRGB(0x5832b9);
    titleLb.innerGlowColor = UIColorFromRGB(0xc44c4e);
    [self.mainView addSubview:titleLb];
    _titleLb = titleLb;
    
    [self createGiftView];
    
    // 关闭按钮
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake(w-30-20, 20, 30, 30)];
    [closeBt setImage:[UIImage imageNamed:@"lz_close_bt"] forState:UIControlStateNormal];
    closeBt.tag = 2;
    [closeBt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:closeBt];
    _closeBt = closeBt;
    

    YunConfig *config = [YunConfig getConfig];
    NSArray *titles = @[@"领取双倍",@"不用，谢谢"];
    if ([config.is_open_ad intValue]<=0) {
        titles = @[@"领取",@"不用，谢谢"];
    }
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    w = 180;
    h = bg.size.height/bg.size.width * w;
    x = (self.mainView.frame.size.width - w) / 2;
    y = self.mainView.frame.size.height - titles.count*(h) - padding;
    
    for (int i=0; i<titles.count; i++) {
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        
        [bt setTitle:titles[i] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // 如果是免费领取，加一个AD视频广告图标
        if([bt.titleLabel.text isEqualToString:@"领取双倍"]){
            bt = [UIButton createAdButton:titles[i] frame:CGRectMake(x, y, w, h)];
            [self startButtonAnimation:bt];
            _sureBt = bt;
        }
        if([bt.titleLabel.text isEqualToString:@"领取"]){
            bt = [UIButton createDefaultButton:titles[i] frame:CGRectMake(x, y, w, h)];
            [self startButtonAnimation:bt];
            _sureBt = bt;
        }
        if ([bt.titleLabel.text isEqualToString:@"不用，谢谢"]) {
            _otherBt = bt;
            
        }
        [bt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = i;
        //bt.alpha = 0.9;
        [self.mainView addSubview:bt];
        y += h;
        bt = nil;
        
    }
    
}

// 随机显示广告视频按钮
-(void)rndShowAdButtonStyle{
//    UIImageView *icon = [_sureBt viewWithTag:102];
//    if (icon) {
//        icon.hidden = ![YunConfig getUserClearanceIsShowAd];
//        [YunConfig setUserClearanceIsShowAd:icon.hidden];
//    }
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


-(void)createGiftView{
    
    // 工具按钮
    float add_w = 30;
    float w = UIScreenWidth / 6;
    float x = (UIScreenWidth - w)/2;
    float ww = w-20;
    float xxx = (w-ww) / 2;
    float yyy = (w-ww) / 2;
    float y = self.mainView.frame.origin.y+(self.mainView.frame.size.height - add_w )/ 2 - 20;
    float h = w;
    
    UIButton *tool1_bg = [[UIButton alloc] init];
    tool1_bg.frame = CGRectMake(x, y, w, h);
//    tool1_bg.layer.borderWidth = 10;
    tool1_bg.layer.cornerRadius = w/2;
//    tool1_bg.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    tool1_bg.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [self addSubview:tool1_bg];
    
    UIImageView *tool1_megic_bg = [[UIImageView alloc] initWithFrame:CGRectMake(-2, -2, tool1_bg.frame.size.width+4, tool1_bg.frame.size.height+4)];
    tool1_megic_bg.image = [UIImage imageNamed:@"megic_tool_bg"];
    [tool1_bg addSubview:tool1_megic_bg];
    
    
    UIImageView *tool1 = [[UIImageView alloc] init];
    tool1.image = [UIImage imageNamed:@"lz_tool_refresh"];
    tool1.frame = CGRectMake(xxx, yyy, ww, tool1.image.size.height/tool1.image.size.width * ww);
    tool1.layer.shadowColor = UIColorFromRGB(0x5b331b).CGColor;//阴影颜色
    tool1.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    tool1.layer.shadowOpacity = 0.3;//不透明度
    tool1.layer.shadowRadius = 3.0;//半径
    [tool1_bg addSubview:tool1];
    _giftImg = tool1;
    UIButton *tool1_add = [[UIButton alloc] init];
    [tool1_add setTitle:@"0" forState:UIControlStateNormal];
    tool1_add.titleLabel.font = kFontBold(14);
    tool1_add.titleLabel.adjustsFontSizeToFitWidth = YES;
    tool1_add.layer.cornerRadius = add_w/2;
    tool1_add.layer.backgroundColor = UIColorFromRGB(0x78de73).CGColor;
    tool1_add.frame = CGRectMake(tool1_bg.frame.size.width-add_w/2-10, tool1_bg.frame.size.height-add_w/2-10, add_w, add_w);
    tool1_add.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    tool1_add.layer.borderWidth = 1;
    [tool1_bg addSubview:tool1_add];
    _giftNumber = tool1_add;
}
// 显示奖励规则
-(void)showGiftView{
    YunConfig *config = [YunConfig getConfig];
    // 随机奖励
    //int rnd = arc4random() % 4;
    //int rndNum = 1+arc4random() % 1;
    //rnd = 3;
    //self.giftTag  = 3;//测试
    
    self.giftTag ++; // 奖励工具
    if (self.giftTag>3) {
        self.giftTag = 0;
    }else{
        _last_giftTag = self.giftTag;
    }
    self.giftTagNumber = 1; // 奖励个数
    NSString *jiangli = @"+1";
    if(self.giftTag==3){
        jiangli = [NSString stringWithFormat:@"+%d",[config.send_gold_amount intValue]];
        self.giftTagNumber = [config.send_gold_amount intValue];
    }
    // 没通关就送分数
    if(!_ispass){
        self.giftTag = 4;
        jiangli = @"+1000";
        self.giftTagNumber = 1000;
    }
    NSArray *iconnames = @[@"lz_tool_refresh",@"lz_tool_bomb",@"lz_tool_magic",@"more_gold_icon.png",@"lz_star_score2"];
    
    _giftImg.image = [UIImage imageNamed:iconnames[self.giftTag]];
    UIView *toolv = _giftImg.superview;
    //float add_w = 30;
    float w = UIScreenWidth / 6;
    float x = (UIScreenWidth - w)/2;
    float y = self.mainView.frame.origin.y+(self.mainView.frame.size.height - toolv.frame.size.height )/ 2 - 20;
    float h = w;
    toolv.frame = CGRectMake(x, y, w, h);
    toolv.alpha = 1;
    [_giftNumber setTitle:jiangli forState:UIControlStateNormal];
    
}




-(void)hide{
    self.hidden = YES;
}

-(void)hideSelf:(void(^)(void))block{
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    // 让工具飞到 主页的工具栏
    UIView *toolv = _giftImg.superview;
    self.mainView.hidden = YES;
    
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
    
    // 发光
    if (!_light_bg) {
        float w = UIScreenWidth * 1.0;
        float ly = toolv.frame.origin.y+toolv.frame.size.height/2-w/2; // (UIScreenHeight-w)/2
        UIImageView *light = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenWidth-w)/2, ly, w, w)];
        light.image = [UIImage imageNamed:@"light_bg"];
        light.alpha = 0;
        [self addSubview:light];
        _light_bg = light;
        
        UIImageView *light2 = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenWidth-w)/2, ly, w, w)];
        light2.image = [UIImage imageNamed:@"light_bg"];
        light2.alpha = 0;
        [self addSubview:light2];
        _light_bg_2 = light2;
    }
    [self bringSubviewToFront:toolv];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 2.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = NSNotFound;
    
    [_light_bg.layer addAnimation:animation forKey:nil];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath: @"transform" ];
    animation2.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation2.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation( 1.0,0.0, 0.0,M_PI) ];
    animation2.duration = 2.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation2.cumulative = YES;
    animation2.repeatCount = NSNotFound;
    
    [_light_bg_2.layer addAnimation:animation2 forKey:nil];
    
    if (self.giftTag<3) {
        x += self.giftTag * (w+padding);
        [self.say lighting];
        WEAKSELF
        [UIView animateWithDuration:0.8 animations:^{
            __weakSelf.light_bg.alpha = 1;
            __weakSelf.light_bg_2.alpha = 1;
            // 先放大
            toolv.transform = CGAffineTransformMakeScale(2, 2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                toolv.transform = CGAffineTransformMakeScale(1, 1);
                toolv.frame = CGRectMake(x-3, y-3, w+6, w+6);
                toolv.alpha = 0.2;
                __weakSelf.maskView.alpha = 0;
                __weakSelf.light_bg.alpha = 0;
                __weakSelf.light_bg_2.alpha = 0;
            } completion:^(BOOL finished) {
                [__weakSelf.say get_tool_success];
                __weakSelf.hidden = YES;
                __weakSelf.light_bg.alpha = 0;
                __weakSelf.light_bg_2.alpha = 0;
                [fn sleepSeconds:0.5 finishBlock:^{
                    if (block) {
                        block();
                    }
                }];
                
            }];
        }];
    }else{
        _light_bg.alpha = 1;
        // 生成10个100的星星coin
        [[YunPopstarShowMsgView sharedSingleton] showMsg:[NSString stringWithFormat:@"+%d",self.giftTagNumber]];
        float t = 0.5;
        for (int i=1; i<=10; i++) {
            float fenshu = 100;
            // 生成一个分数的icon
            YunPopstarScoreTip *score = [[YunPopstarScoreTip alloc] initWithFrame:toolv.frame color:0 scroe:fenshu];
            score.frame = CGRectMake(0, 0, toolv.frame.size.width, toolv.frame.size.height);
            score.starBt.frame = CGRectMake(10, 10, score.frame.size.width-20, score.frame.size.height-20);
            [toolv addSubview:score];
            [score performSelector:@selector(hideself) withObject:nil afterDelay:t];
            [self.say performSelector:@selector(get_tool_success) withObject:nil afterDelay:t];
            t += 0.05;
        }
        
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 保存分数
            int amount = [YunConfig getUserCoin];
            amount += __weakSelf.giftTagNumber;
            [YunConfig setUserCoin:amount];
            [__weakSelf.say lighting];
            [UIView animateWithDuration:0.3 animations:^{
                // 先放大
                toolv.transform = CGAffineTransformMakeScale(2, 2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    toolv.transform = CGAffineTransformMakeScale(1, 1);
                    toolv.alpha = 0.2;
                    __weakSelf.maskView.alpha = 0;
                } completion:^(BOOL finished) {
                    [__weakSelf.say get_tool_success];
                    __weakSelf.hidden = YES;
                    [fn sleepSeconds:0.5 finishBlock:^{
                        if (block) {
                            block();
                        }
                    }];
                }];
            }];
        });
    }
    
    
    
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
    button.enabled = NO;
    // 当前关卡，每隔多少个关卡，强制弹出广告
    int lastLevels = [[YunConfig get:kConfig_User_clearance_show_ad_lasttime] intValue];
    long levels = [YunConfig getUserPassNumber];
    YunConfig *config = [YunConfig getConfig];
    if (button) {
        if ([[button class] isEqual:[UIButton class]]) {
            [self.say touchButton];
            if (button.tag==1) {
                
                // 直接免费领取
                if (config) {
                    if ([config.is_open_ad intValue]>0) {
                        if ((levels-lastLevels) >= [config.open_ad_longtime intValue]) {
                            // 强制显示广告
                            [self openAdGetGift];
                            return;
                        }
                    }
                    
                }
                
                // 点击不用谢谢
                if (!_ispass) {
                    [MobClick beginEvent:@"clearance_no_thanks"];
                    [self hide];
                    // 通关失败直接关闭，不送分数
                    if (self.clickButtonBlock) {
                        self.clickButtonBlock(button);
                    }
                    [MobClick endEvent:@"clearance_no_thanks"];
                    return;
                }
                if ([config.is_open_ad intValue]>0) {
                    [self getGift];
                }else{
                    [self hide];
                    if (self.clickButtonBlock) {
                        self.clickButtonBlock(button);
                    }
                }
            }
            if (button.tag==0) {
                [MobClick beginEvent:@"clearance_click_double"];
                if ([config.is_open_ad intValue]>0) {
                    [self openAdGetGift];
                }else{
                    [self getGift];
                }
                [MobClick endEvent:@"clearance_click_double"];
            }
            
            if (button.tag==2) {
                if (config) {
                    if ([config.is_open_ad intValue]>0) {
                        if ((levels-lastLevels) >= [config.open_ad_longtime intValue]) {
                            // 强制显示广告
                            [self openAdGetGift];
                            return;
                        }
                    }
                }
                
                // 点击关闭按钮
                if (!_ispass) {
                    [self hide];
                    // 通关失败直接关闭，不送分数
                    if (self.clickButtonBlock) {
                        self.clickButtonBlock(button);
                    }
                    return;
                }
                
                // 直接免费领取
                if ([config.is_open_ad intValue]>0) {
                    [self getGift];
                }else{
                    [self hide];
                    if (self.clickButtonBlock) {
                        self.clickButtonBlock(button);
                    }
                }
            }
        }
        
        
    }
    
}

-(void)openAdGetGift{
    // 领取奖励看广告
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = [YunConfig getUserId];;
    self.rewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:kCsj_sloteid_945440304 rewardedVideoModel:model];
    //self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:@"945438638" adloadSeq:1 primeRit:@"945438638" rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
    [MobClick beginEvent:@"clearrance_video_ad"];
    self.ad_start_time = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    self.requestid = [fn getTimestamp];
    [http sendApiUserAd:@"点击通关道具奖励的激励视频广告" type:0 ad:kCsj_sloteid_945440304 start_time:self.ad_start_time end_time:@"" requestid:self.requestid];
}

-(void)getGift{
    
    WEAKSELF
    //[[YunShowMsg sharedSingleton] show:@"领取成功！"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[YunShowMsg sharedSingleton] hide];
        
        [__weakSelf.giftNumber setTitle:@(__weakSelf.giftTagNumber).stringValue forState:UIControlStateNormal];
        // 奖励工具
        // 刷新工具
        if (__weakSelf.giftTag==0) {
            int amount = [YunConfig getUserRefreshAmount];
            amount += __weakSelf.giftTagNumber;
            [YunConfig setUserRefreshAmount: amount];

            [__weakSelf hideSelf:^{
                if (__weakSelf.clickButtonBlock) {
                    __weakSelf.clickButtonBlock(nil);
                }
            }];
        }
        // 炸弹
        if (__weakSelf.giftTag==1) {
            int amount = [YunConfig getUserBombAmount];
            amount += __weakSelf.giftTagNumber;
            [YunConfig setUserBombAmount: amount];

            [__weakSelf hideSelf:^{
                if (__weakSelf.clickButtonBlock) {
                    __weakSelf.clickButtonBlock(nil);
                }
            }];
        }
        // 魔术棒
        if (__weakSelf.giftTag==2) {
            int amount = [YunConfig getUserMagicAmount];
            amount += __weakSelf.giftTagNumber;
            [YunConfig setUserMagicAmount: amount];
            [__weakSelf hideSelf:^{
                if (__weakSelf.clickButtonBlock) {
                    __weakSelf.clickButtonBlock(nil);
                }
            }];
        }
        // 金币
        if (__weakSelf.giftTag==3) {
            [__weakSelf hide];
            [[YunGetGoldView sharedSingleton] show:__weakSelf.giftTagNumber intro:@"通关奖励金币" type:3];
            [YunGetGoldView sharedSingleton].hideBlock = ^{
                if (__weakSelf.clickButtonBlock) {
                    __weakSelf.clickButtonBlock(nil);
                }
            };
        }
        // 分数
        if (__weakSelf.giftTag==4) {
            int amount = [YunConfig getUserCoin];
            amount += __weakSelf.giftTagNumber;
            [YunConfig setUserCoin: amount];
            [__weakSelf hideSelf:^{
                if (__weakSelf.clickButtonBlock) {
                    __weakSelf.clickButtonBlock(nil);
                }
            }];
        }
    });
   
}

// 信息流广告
- (void)loadFeedAds {
    YunConfig *config = [YunConfig getConfig];
    if (config) {
        if([config.open_ads indexOf:kCsj_sloteid_945478871]!=NSNotFound && [config.is_open_ad intValue]>0){
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
            slot1.ID = kCsj_sloteid_945478871;
            slot1.AdType = BUAdSlotAdTypeFeed;
            BUSize *imgSize = [BUSize sizeBy:BUProposalSize_Banner600_260];
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
        // 更新广告弹出时间
        [YunConfig seting:kConfig_User_clearance_show_ad_lasttime value:@([YunConfig getUserPassNumber]).stringValue];
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
    [MobClick endEvent:@"clearrance_video_ad"];
    // 看视频后双倍奖励
    self.giftTagNumber *= 2;
    [self getGift];
    
    [http sendApiUserAd:@"点击通关道具奖励的激励视频广告" type:0 ad:kCsj_sloteid_945440304 start_time:self.ad_start_time end_time:[NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"] requestid:self.requestid];

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
