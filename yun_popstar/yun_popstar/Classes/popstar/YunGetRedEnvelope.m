//
//  YunGetRedEnvelope.m
//  yun_popstar
//
//  Created by dangfm on 2020/8/22.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunGetRedEnvelope.h"

@implementation YunGetRedEnvelope
+ (instancetype)sharedSingleton {
    static YunGetRedEnvelope *_sharedSingleton = nil;
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
    _type = 0;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    _openBt.enabled = YES;
    _otherBt.enabled=YES;
    _closeBt.enabled=YES;
    _submitBt.enabled=YES;
    _bottomCloseBt.enabled = YES;
    self.openBt.hidden = NO;
    self.noOpenBg.hidden = NO;
    _bottomCloseBt.hidden = YES;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    [self startOtherButtons];
    
    // 红包关闭通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_RedEnvelope_Close object:nil];
}
-(void)showWithType:(int)type{
    _type = type;
    [self show];
}
-(void)initViews{
    [self initSay];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [[AppDelegate sharedSingleton].window addSubview:self];
    
    float w = UIScreenWidth-60;
    float h = w;
    float x = 30;
    float padding = 20;
    
    UIImage *mbg = [UIImage imageNamed:@"redbox_bg"];
    h = mbg.size.height/mbg.size.width * w;
    float y = (UIScreenHeight-h)/2;
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.8;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//    [self.maskView addGestureRecognizer:tap];
//    [self.maskView setUserInteractionEnabled:YES];
    [self addSubview:self.maskView];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.mainView.bounds];
    iv.image = mbg;
    [self.mainView addSubview:iv];
    //self.mainView.backgroundColor = [[UIColor colorWithPatternImage:bg] colorWithAlphaComponent:1];
//    self.mainView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
//    self.mainView.layer.borderWidth = 3;
//    self.mainView.layer.cornerRadius = corner;
    [self addSubview:self.mainView];
    
    FBGlowLabel *titleLb = [[FBGlowLabel alloc] initWithFrame:CGRectMake(0, 0, w, 60)];
    titleLb.text = @"领取红包";
    titleLb.font = kFontBold(26);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = UIColorFromRGB(0x7a5e1a);
    //titleLb.textColor = FMBlackColor;
    
    [titleLb sizeToFit];
    float tw = titleLb.frame.size.width + 40;
    float th = titleLb.frame.size.height + 10;
    titleLb.frame = CGRectMake((w - tw)/2, 15, tw, th);
    titleLb.layer.cornerRadius = titleLb.frame.size.height/2;
    titleLb.backgroundColor = UIColorFromRGB(0xd6b461);
    titleLb.layer.masksToBounds = YES;
//    titleLb.glowSize = 20;
//    titleLb.innerGlowSize = 4;
//    titleLb.glowColor = UIColorFromRGB(0x5832b9);
//    titleLb.innerGlowColor = UIColorFromRGB(0xc44c4e);

    [self.mainView addSubview:titleLb];
    
    UILabel *blancelb = [[UILabel alloc] initWithFrame:CGRectMake(15, self.mainView.frame.size.height/4-20, w-30, 50)];
    blancelb.font = kFontBold(36);
    blancelb.adjustsFontSizeToFitWidth = YES;
    blancelb.textAlignment = NSTextAlignmentCenter;
    blancelb.textColor = UIColorFromRGB(0xfd6d60);
    blancelb.text = @"0.00";
    [self.mainView addSubview:blancelb];
    _balanceLb = blancelb;
    
    UILabel *introLb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.mainView.frame.size.height/4+30, w, 30)];
    introLb.font = kFont(20);
    introLb.textAlignment = NSTextAlignmentCenter;
    introLb.textColor = titleLb.backgroundColor;
    introLb.text = @"已存入余额";
    [self.mainView addSubview:introLb];
    _balanceTipLb = introLb;
    
    
    // 关闭按钮
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake(w-15-25, 15, 25, 25)];
    UIImage *closeIcon = [UIImage imageNamed:@"lz_close_black_bt"];
    [closeBt setImage:closeIcon forState:UIControlStateNormal];
    closeBt.tag = 2;
    [closeBt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:closeBt];
    _closeBt = closeBt;
    
    // 注释按钮
    UIButton *noteBt = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 25, 25)];
    UIImage *noteicon = [UIImage imageNamed:@"lz_note_icon"];
    [noteBt setImage:noteicon forState:UIControlStateNormal];
    noteBt.tag = 1;
    [noteBt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:noteBt];
    
    
    
    NSArray *titles = @[@"领取双倍",@"不用，谢谢"];
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    w = 180;
    h = bg.size.height/bg.size.width * w;
    x = (self.mainView.frame.size.width - w) / 2;
    y = self.mainView.frame.size.height - titles.count*(h);
    float by = self.mainView.frame.size.height - titles.count*(h);
    for (int i=0; i<titles.count; i++) {
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        
        [bt setTitle:titles[i] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // 如果是免费领取，加一个AD视频广告图标
        if([bt.titleLabel.text isEqualToString:@"领取双倍"]){
            bt = [UIButton createAdButton:titles[i] frame:CGRectMake(x, y, w, h)];
            [self startButtonAnimation:bt];
            _submitBt = bt;
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
    
    _bottomCloseBt = [UIButton createDefaultButton:@"关闭" frame:CGRectMake(x, by, w, h)];
    [_bottomCloseBt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    _bottomCloseBt.tag = 2;
    _bottomCloseBt.hidden = YES;
    [self.mainView addSubview:_bottomCloseBt];
    
    
    // 未开封状态
    _noOpenBg = [[UIImageView alloc] initWithFrame:self.mainView.bounds];
    _noOpenBg.image = [UIImage imageNamed:@"hongbao_weikai_bg"];
    [self.mainView addSubview:_noOpenBg];
    // 开红包按钮
    float ow = self.mainView.frame.size.height/4;
    _openBt = [[UIButton alloc] initWithFrame:CGRectMake((self.mainView.frame.size.width-ow)/2, self.mainView.frame.size.height/3*2 - ow/2 + 20, ow, ow)];
    [_openBt setImage:[UIImage imageNamed:@"hongbao_kai_icon"] forState:UIControlStateNormal];
    [_openBt addTarget:self action:@selector(clickOpenButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:_openBt];
    [self startButtonAnimation:_openBt];
    
    [self.mainView bringSubviewToFront:self.closeBt];
    //self.transform = CGAffineTransformScale(self.transform, 0, 0);
}

-(void)createRedEnvelope:(float)amount{
    
    
    // 给用户增加红包
    float red = [YunConfig getUserRedEnvelope];
    red += amount;
    [YunConfig setUserRedEnvelope:red];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GetRedEnvelope object:nil];
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
        animation.toValue= [NSNumber numberWithFloat:1.2];    //结束伸缩倍数
        [[bt layer] addAnimation:animation forKey:nil];
        
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [__weakSelf startButtonAnimation:bt];
        });
 
    
}

// 旋转
-(void)transcycle:(UIButton*)v{
//    [v.layer removeAllAnimations];
//    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
//    // 旋转角度， 其中的value表示图像旋转的最终位置
//    keyAnimation.values = [NSArray arrayWithObjects:
//                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
//                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation((M_PI/2), 0,1,0)],
//                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
//                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,1,0)],
//                           nil];
//    keyAnimation.keyTimes = @[@(0),@(0.2),@(0.4),@(1.0)];//每一个的取值范围是0-1
//    keyAnimation.duration = .3 ;
//    keyAnimation.repeatCount = NSNotFound;
//    keyAnimation.autoreverses=YES;    //完成动画后会回到执行动画之前的状态
//    [v.layer addAnimation:keyAnimation  forKey:@"kai_icon_rotationAnimation"];
    if (v.hidden) {
        return;
    }
    [v.layer removeAllAnimations];
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
            v.transform = CGAffineTransformMakeScale(-1, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
                v.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            [__weakSelf transcycle:v];
        }];
    }];
}

-(void)hide{
    self.hidden = YES;
}

-(void)clickButton:(UIButton*)button{
    button.enabled = NO;
    if (button.tag==1) {
        // 不用谢谢
    }
    if (button.tag==0) {
        // 领取双倍
        [self openAd];
        return;
    }
    if (button.tag==2) {
        // 关闭
    }
    
    if (button.tag==3) {
        //注释
    }
    [self.say touchButton];
    if (self.magicBlock) {
        self.magicBlock(button,(int)button.tag);
    }
    [self hide];
}

-(void)clickOpenButton:(UIButton*)button{
    button.enabled = NO;
    [self.say touchButton];
    [self transcycle:button];
    // 打开红包的次数
    int times = [[YunConfig get:kConfig_User_redenvelope_show_ad_lasttime] intValue];
    YunConfig *config = [YunConfig getConfig];
    if (config) {
        // 每隔N次就要强制打开激励视频
        if (times % [config.open_ad_redenvelope intValue]==0 && times>0) {
            // 强制打开激励视频广告
            [self openAd];
        }else{
            WEAKSELF
            [fn sleepSeconds:1.0 finishBlock:^{
                __weakSelf.openBt.transform = CGAffineTransformMakeScale(1, 1);
                [__weakSelf sendApiUserRedEnvelope:nil];
            }];
        }
    }
    
    
}

-(void)openAd{
    // 领取奖励看广告
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = [YunConfig getUserId];;
    self.rewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:kCsj_sloteid_945463813 rewardedVideoModel:model];
    //self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:@"945438638" adloadSeq:1 primeRit:@"945438638" rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
    [MobClick beginEvent:@"openredenvelope_video_ad"];
    self.ad_start_time = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    self.requestid = [fn getTimestamp];
    [http sendApiUserAd:@"打开红包的激励视频广告" type:0 ad:kCsj_sloteid_945463813 start_time:self.ad_start_time end_time:@"" requestid:self.requestid];
}


- (void)setupExplosion:(int)num{
    
    // 爆炸
    CAEmitterCell * explodeCell = [CAEmitterCell emitterCell];
    explodeCell.name = @"explodeCell";
    explodeCell.contents = (id)[[UIImage imageNamed:@"lz_star"] CGImage];
    //explodeCell.color = FMRedColor.CGColor;
    //explodeCell.birthRate = 1.f;
    explodeCell.lifetime = 0.3f;
    explodeCell.velocity = 0.f;
    
    explodeCell.scale = 0.3;
    explodeCell.scaleRange = 0.8;
    explodeCell.scaleSpeed = 0.01;
//
    explodeCell.redRange = 1.f;
    explodeCell.greenRange = 1.f;
    explodeCell.blueSpeed = 1.f;
    explodeCell.alphaRange = 0.1;
    explodeCell.alphaSpeed = -0.1f;
    
    // 火花
    CAEmitterCell * sparkCell = [CAEmitterCell emitterCell];
    sparkCell.name = @"sparkCell";
    
    sparkCell.birthRate = 100.f;
    sparkCell.lifetime = 3.1f;
    sparkCell.velocity = 125.f;
    sparkCell.velocityRange = 500.f;
    sparkCell.yAcceleration = 175.f;  // 模拟重力影响
    sparkCell.emissionRange = M_PI * 2;  // 360度
    
    sparkCell.contents = (id)[[UIImage imageNamed:@"lz_star"] CGImage];
    //sparkCell.color = FMYellowColor.CGColor;
    
    sparkCell.scale = 0.5f;
    sparkCell.redSpeed = 0.4;
    sparkCell.greenSpeed = -0.1;
    sparkCell.blueSpeed = -0.1;
    sparkCell.alphaSpeed = -0.25;
    
    sparkCell.spin = M_PI * 2; // 自转
   
    // 2.发射源
    CAEmitterLayer * explosionLayer = [CAEmitterLayer layer];
    
    [self.layer addSublayer:explosionLayer];
    //开启三维效果
    //explosionLayer.preservesDepth = true;
    //发射源的尺寸大小
    //explosionLayer.emitterSize = _redenvelope_time.frame.size;
    explosionLayer.emitterPosition = CGPointMake(self.center.x, self.center.y-100);
    //发射源的形状
    explosionLayer.emitterShape = kCAEmitterLayerLine;
    //发射模式
    explosionLayer.emitterMode = kCAEmitterLayerOutline;
    //渲染模式
    explosionLayer.renderMode = kCAEmitterLayerAdditive;
    explosionLayer.repeatCount = 1;
    
    //添加动画
    explosionLayer.emitterCells = @[explodeCell];
    explodeCell.emitterCells = @[sparkCell];
    //explosionCell.emitterCells = @[sparkCell];
    self.explosionLayer = explosionLayer;
    
    [self startAnimation:num];
}

/**
 * 开始动画
 */
- (void)startAnimation:(int)num{
    [self.say peng];
    
    // 用KVC设置颗粒个数
    [self.explosionLayer setValue:@(num) forKeyPath:@"emitterCells.explodeCell.birthRate"];
    
    // 开始动画
    self.explosionLayer.beginTime = CACurrentMediaTime();
    
    // 延迟停止动画
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.5];
    //[self borderDefault];
}

/**
 * 动画结束
 */
- (void)stopAnimation{
    // 用KVC设置颗粒个数
    [self.explosionLayer setValue:@0 forKeyPath:@"emitterCells.explodeCell.birthRate"];
    //[self.explosionLayer removeAllAnimations];
    //[self performSelector:@selector(clearSelf) withObject:nil afterDelay:0.15];

}

// 保存金币流水
-(void)sendApiUserRedEnvelope:(NSString*)redenvelope_id{
    self.balanceLb.text = [NSString stringWithFormat:@"正在抢红包..."];
    self.balanceTipLb.hidden = YES;
    self.submitBt.hidden = YES;
    self.otherBt.hidden = YES;
    int passNumber = [YunConfig getUserPassNumber];
    long requestid = [fn getTimestamp];
    if (!redenvelope_id) {
        redenvelope_id = @"";
    }
    NSDictionary *p = @{
        @"levels":@(passNumber).stringValue,
        @"type":@(_type).stringValue,
        @"intro":@"关卡随机红包",
        @"redenvelope_id":redenvelope_id,
        @"requestid":@(requestid).stringValue
    };
    WEAKSELF
    [http sendPostRequestWithParams:p api:kAPI_Users_AddRedEnvelope start:^{
        
    } failure:^{
        NSLog(@"保存红包流水失败，网络不给力");
        __weakSelf.openBt.hidden = YES;
        __weakSelf.noOpenBg.hidden = YES;
        __weakSelf.bottomCloseBt.hidden = NO;
        __weakSelf.balanceLb.text = @"人数太多,网络不给力啦!";
    } success:^(NSDictionary *dic) {
        
        NSLog(@"保存红包流水 %@",dic);
        __weakSelf.openBt.hidden = YES;
        __weakSelf.noOpenBg.hidden = YES;
        int code = [dic[@"code"] intValue];
        if (code==200) {
            NSDictionary *data = dic[@"data"];
            if (data) {
                float amount = [data[@"amount"] floatValue];
                int isnew = [data[@"isnew"] intValue];
                NSString *rid = data[@"redenvelope_id"];
                if (amount>0) {
                    __weakSelf.redenvelope_id = [NSString stringWithFormat:@"%@",rid];
                    if (![redenvelope_id isEqualToString:@""]) {
                        // 双倍领取成功后，清除标识
                        __weakSelf.redenvelope_id = @"";
                    }
                    // 更新打开红包的次数
                    int times = [[YunConfig get:kConfig_User_redenvelope_show_ad_lasttime] intValue];
                    times ++;
                    [YunConfig seting:kConfig_User_redenvelope_show_ad_lasttime value:@(times).stringValue];
                    
                    __weakSelf.submitBt.hidden = NO;
                    __weakSelf.otherBt.hidden = NO;
                    __weakSelf.balanceTipLb.hidden = NO;
                    __weakSelf.bottomCloseBt.hidden = YES;
                    __weakSelf.balanceLb.text = [NSString stringWithFormat:@"%.2f",amount];
                    [__weakSelf createRedEnvelope:amount];
                    [__weakSelf setupExplosion:50];
                    // 如果是领取双倍，领取成功后只显示关闭按钮
                    if (![redenvelope_id isEqualToString:@""] || isnew<=0) {
                        __weakSelf.bottomCloseBt.hidden = NO;
                        __weakSelf.submitBt.hidden = YES;
                        __weakSelf.otherBt.hidden = YES;
                    }
                    return;
                }
            }
            
        }
        __weakSelf.bottomCloseBt.hidden = NO;
        NSString *msg = dic[@"msg"];
        if (!msg) {
            msg = @"人数太多,网络不给力啦!";
        }
        __weakSelf.balanceLb.text = msg;
    }];
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
    [MobClick endEvent:@"openredenvelope_video_ad"];
    // 看视频后双倍奖励
    [http sendApiUserAd:@"打开红包的激励视频广告" type:0 ad:kCsj_sloteid_945463813 start_time:self.ad_start_time end_time:[NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"] requestid:self.requestid];
    
    WEAKSELF
    [fn sleepSeconds:1.0 finishBlock:^{
        __weakSelf.openBt.transform = CGAffineTransformMakeScale(1, 1);
        [__weakSelf sendApiUserRedEnvelope:__weakSelf.redenvelope_id];
    }];

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
