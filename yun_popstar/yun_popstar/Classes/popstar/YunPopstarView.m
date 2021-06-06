//
//  YunPopstarView.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/6.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPopstarView.h"

#define kPopTime 0.08

@interface YunPopstarView()<AVAudioPlayerDelegate,BUNativeExpressRewardedVideoAdDelegate,BUNativeExpressAdViewDelegate>
@property (nonatomic,retain) BUNativeExpressRewardedVideoAd *rewardedVideoAd;
@property (retain,nonatomic) NSString *ad_start_time;
@property (assign,nonatomic) long requestid;
@property (retain,nonatomic) BUNativeExpressAdManager *nativeExpressAdManager;
@property (retain,nonatomic) NSMutableArray *expressAdViews;
@property (retain,nonatomic) UIView *expressViewBox;



@end

@implementation YunPopstarView
-(void)dealloc{
    
    NSLog(@"YunPopstarView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame isChallenge:(BOOL)isChallenge challenger:(nonnull NSDictionary *)challenger{
    if([super initWithFrame:frame]){
        _challenger = challenger;
        _isChallenge = isChallenge;
        [self initView];
    }
    return self;
}

-(void)free{
    _isExit = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.say free];
}

-(void)initView{
    [self initSay];
    [self resetStarView];
    [self checkPopstarHasTheSame];
    [self createLittleRedEnvelopeView];
    // 刷新所以按钮颜色通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshButtons) name:kNSNotificationName_GameChangeAllButtonColor object:nil];
    // 重新开始游戏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRestarNewGame) name:kNSNotificationName_NewGame object:nil];
    // 红包激活
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRedEnvelopeActive) name:kNSNotificationName_RedEnvelope_Active object:nil];
    // 红包关闭
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRedEnvelopeClose) name:kNSNotificationName_RedEnvelope_Close object:nil];
    // 挑战结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationChallengeEndPlay) name:kNSNotificationName_ChallengeEndPlay object:nil];
    // 挑战开始
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(challengePlayStartNotification:) name:kNSNotificationName_ChallengeStartPlay object:nil];
    // 每一关分数
//    for (int i=1; i<1000; i++) {
//        int fenshu = [YunConfig passNumberDefaultTargetNumber:i];
//        NSLog(@"第%d关：%d",i,fenshu);
//    }
//    [[YunShowMsg sharedSingleton] show:@"挑战结果" content:@"网络不给力，请重试" sure:^{
//        [((UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController) popViewControllerAnimated:YES] ;
//    }];
}

-(void)clear{
    if (self.littleRedEnvelope) {
        [self.littleRedEnvelope removeFromSuperview];
        self.littleRedEnvelope = nil;
    }
    if (self.starButtonsView) {
        for (UIView *v in self.starButtonsView.subviews) {
            [v removeFromSuperview];
        }
        [self.starButtonsView removeFromSuperview];
        
    }
    self.starButtonsView = nil;
    if (self.linkButtons) {
        [self.linkButtons removeAllObjects];
    }
    self.linkButtons = nil;
    if (self.buttonStatus) {
        [self.buttonStatus removeAllObjects];
    }
    self.buttonStatus = nil;
    
    if (self.downButtons) {
        [self.downButtons removeAllObjects];
    }
    self.downButtons = nil;
}

-(void)initSay{
    self.say = [YunPopstarSay new];
}

-(void)notificationRestarNewGame{
    
    // 新游戏规则，通关变为1，目标变为默认，总分数变为0
    [YunConfig setUserPassNumber:1];
    [YunConfig setUserTargetCoin:0];
    [YunConfig setUserCoin:0];
    [YunConfig setUserCoinSingle:0];
    [YunConfig setUserCoinMax:0];
    [self resetStarView];
    
}
// 挑战开始
-(void)challengePlayStartNotification:(NSNotification*)noti{
    _isStartPlay = YES;
    _start_time = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    //[[YunGetGoldView sharedSingleton] show:1 intro:@"挑战成功奖励" type:8 x:UIScreenWidth-15-10];
}
// 挑战结束
-(void)notificationChallengeEndPlay{
    // 显示挑战结束弹窗
    [self gameOverAction];
}

- (void)resetStarView{
    
    // 控制玩多局相同关卡强弹广告
    int amount = 0;
    NSString *levels_sametime = [YunConfig get:kConfig_User_LevelsSameTime];
    if (levels_sametime) {
        NSDictionary *sametime = [levels_sametime mj_JSONObject];
        if (sametime) {
            amount = [sametime[@"amount"] intValue];
        }
    }
    if (amount % [[YunConfig getConfig].levels_sametime_ad intValue]==0 && amount>0 && [[YunConfig getConfig].is_open_ad intValue]>0 && !_isChallenge) {
        // 弹出广告
        [self openAd];
    }
    
    
    //[self showPassRewardView];
    //_isShowRedenvelope = NO;
    [[YunStarCommand sharedSingleton] reset];
    _goldAmount = 0;
    
    WEAKSELF;
    if (!_isChallenge) {
        [self.say readygo];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say say:@"lz_tool_bg_xuanzhuan.wav"];
        });
        
        [self.say playBackgroundMusic];
    }
    
    
    [self clear];
    if (!self.starButtonsView) {
        self.starButtonsView = [[UIView alloc] initWithFrame:self.bounds];
        self.starButtonsView.backgroundColor = [UIColor clearColor];
        self.starButtonsView.tag = 10010;
        [self addSubview:self.starButtonsView];
    }
    
    if (!self.buttonStatus) {
        self.buttonStatus = [NSMutableDictionary new];
    }
    if (!self.downButtons) {
        self.downButtons = [NSMutableArray new];
    }
    self.isFinished = YES;
    self.gameOver = NO;
    self.isPass = NO;
    float padding = 0;
    int rowcount = 10;
    int btw = (self.frame.size.width-(rowcount-1)*padding)/rowcount;
    int bth = btw;
    int x = 0;
    int y = 0;
    float t = 0.005;
    self.starButtonsView.frame = CGRectMake((self.frame.size.width-10*btw)/2, (self.frame.size.height-10*bth)/2, 10*btw, 10*bth);
    if (!_isChallenge) {
        for(int i=0;i<10;i++){
                x = 0;
                y = i * bth;
                for(int j=0;j<10;j++){
                    int color = arc4random() % 5;
                    
                    if (j>0 && j<9) {
                        x += padding;
                    }
                    // 生成星星 一行十个
                    YunPopstarButton *star = [[YunPopstarButton alloc] initWithFrame:CGRectMake(x, y, btw, bth) color:color];
                    [star addTarget:self action:@selector(clickbtaction:) forControlEvents:UIControlEventTouchUpInside];
                    //[self addSubview:star];
                    [self.starButtonsView addSubview:star];
                    // 星星消失回调
                    star.clearPopstarBlock = ^(YunPopstarButton *me, BOOL isClear) {
                        // 清除标识
                        NSLog(@"清除：%d",(int)me.firstTag);
                        if(!__weakSelf.gameOver){
                            // 生成一个分数的icon
                            YunPopstarScoreTip *score = [[YunPopstarScoreTip alloc] initWithFrame:me.frame color:me.color];
                            [__weakSelf addSubview:score];
                            [score performSelector:@selector(hide) withObject:nil afterDelay:0.5];
                        }else{
                            if (me.isReward) {
                                // 如果游戏结束，随机奖励，根据剩余星星的数量进行有效奖励 100-200分
                                int from = 1000;
                                int to = 2000;
                                int rnd = from +  (arc4random() % (to-from+1));
                                float fenshu = rnd/__weakSelf.gameOverLastStarCount;
                                if (fenshu>30) {
                                    //[__weakSelf.say reward];
                                    [[YunPopstarShowMsgView sharedSingleton] showMsg:[NSString stringWithFormat:@"+%.f",fenshu]];
                                    // 生成一个分数的icon
                                    YunPopstarScoreTip *score = [[YunPopstarScoreTip alloc] initWithFrame:me.frame color:me.color scroe:fenshu];
                                    [__weakSelf addSubview:score];
                                    [score performSelector:@selector(hide) withObject:nil afterDelay:0.5];
                                }else{
                                    YunPopstarScoreTip *score = [[YunPopstarScoreTip alloc] initWithFrame:me.frame color:me.color];
                                    [__weakSelf addSubview:score];
                                    [score performSelector:@selector(hide) withObject:nil afterDelay:0.5];
                                }
         
                            }
                        }
                        
                        // 检查是否过关
                        if ([YunConfig getUserCoin]+[YunConfig getUserCoinSingle]>=[YunConfig getUserTargetCoin] && !__weakSelf.isPass) {
                            // 通过检测
                            [__weakSelf showPassTarget];
                        }
                        
                        [__weakSelf.buttonStatus setValue:@(1) forKey:[NSString stringWithFormat:@"%d",(int)me.firstTag]];
                    };
                    
                    
                    //旋转动画
                    CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                    anima3.toValue = [NSNumber numberWithFloat:M_PI*4];
                    anima3.duration = 1.0;
                    
                    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
                    anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
                    anima.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];;
                    anima.duration = t;
                    //[star.layer addAnimation:anima forKey:nil];
        //
                    // 通过关键帧动画实现缩放
                    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
                    animation.keyPath = @"transform.scale";
                    animation.values = @[@0.1,@1.0];
                    animation.duration = 1.0;
                    //animation.calculationMode = kCAAnimationLinear;
                    
                    //组动画
                    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
                    groupAnimation.animations = [NSArray arrayWithObjects:animation,anima,anima3, nil];
                    groupAnimation.duration = 4.0f;
                    
                    [star.layer addAnimation:groupAnimation forKey:nil];
                        
                    t+= 0.005;
                    x += btw;
                    
                    anima = nil;
                    anima3 = nil;
                    animation = nil;
                    star = nil;
                }
            }
    }else{
        WEAKSELF
        NSArray *cmds = [_challenger[@"cmds"] mj_JSONObject];
        NSArray *buttons = @[];
        if (cmds) {
            NSDictionary *item = cmds[0];
            // 星星对象
            buttons = item[@"links"];
        }
        
        for(NSArray*item in buttons){
            //int tag = [item.firstObject intValue];
            int color = [item.lastObject intValue];
            
            // 生成星星 一行十个
            YunPopstarButton *star = [[YunPopstarButton alloc] initWithFrame:CGRectMake(x, y, btw, bth) color:color];
            //star.tag = tag;
            //star.userInteractionEnabled = NO;
            [star addTarget:self action:@selector(clickbtaction:) forControlEvents:UIControlEventTouchUpInside];
            //[self addSubview:star];
            [self.starButtonsView addSubview:star];
            // 星星消失回调
            star.clearPopstarBlock = ^(YunPopstarButton *me, BOOL isClear) {
               // 清除标识
               NSLog(@"清除：%d",(int)me.firstTag);
               if(!__weakSelf.gameOver){
                   // 生成一个分数的icon
                   YunPopstarScoreTip *score = [[YunPopstarScoreTip alloc] initWithFrame:me.frame color:me.color scroe:1];
                   [__weakSelf addSubview:score];
                   [score performSelector:@selector(hide) withObject:nil afterDelay:0.5];
               }else{
                   
               }
               
               // 检查是否过关
               if ([YunConfig getUserCoin]+[YunConfig getUserCoinSingle]>=[YunConfig getUserTargetCoin] && !__weakSelf.isPass) {
                   // 通过检测
                   [__weakSelf showPassTarget];
               }
               
               [__weakSelf.buttonStatus setValue:@(1) forKey:[NSString stringWithFormat:@"%d",(int)me.firstTag]];
            };
            
            
            //旋转动画
            CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            anima3.toValue = [NSNumber numberWithFloat:M_PI*4];
            anima3.duration = 1.0;
            
            CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
            anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
            anima.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];;
            anima.duration = t;
            //[star.layer addAnimation:anima forKey:nil];
    //
            // 通过关键帧动画实现缩放
            CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@0.1,@1.0];
            animation.duration = 1.0;
            //animation.calculationMode = kCAAnimationLinear;
            
            //组动画
            CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
            groupAnimation.animations = [NSArray arrayWithObjects:animation,anima,anima3, nil];
            groupAnimation.duration = 4.0f;
            
            [star.layer addAnimation:groupAnimation forKey:nil];
            t+= 0.005;
            x += btw;
            if (x>self.frame.size.width-btw) {
                y += bth;
                x = 0;
            }
            
            anima = nil;
            anima3 = nil;
            animation = nil;
            groupAnimation = nil;
            star = nil;
        }
    }
    
    [self setButtonTag];
    
    // 游戏开始命令
    [[YunStarCommand sharedSingleton] cmdWithName:@"start" linkButtons:self.starButtonsView.subviews];
    
//    // 游戏开始通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GameStart object:nil];
 
}

// 在某个星星上面覆盖一个红包
// 随机覆盖一个红包，红包出现逻辑，每隔N分钟，没关卡都有红包，每天出现多少次
-(void)createLittleRedEnvelopeView{
    if (_isExit) {
        return;
    }
    if (![YunConfig getUserIsOpenRedEnvelope]) {
        // 没有打开红包就隐藏
        return;
    }
    WEAKSELF
    // 红包没有激活不能显示
    if (!_isShowRedenvelope) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf createLittleRedEnvelopeView];
        });
        return;
    }
    
    // 随机数
    int t = 1 +  (arc4random() % 100);
    if (t>=0 && t<100) {
        UIButton *bt = [self.starButtonsView viewWithTag:t];
        if (bt) {
            if (self.littleRedEnvelope) {
                [self.littleRedEnvelope removeFromSuperview];
            }
            
            self.littleRedEnvelope = [[YunLittleRedEnvelopeView alloc] initWithFrame:bt.bounds];
            [self.littleRedEnvelope addTarget:self action:@selector(clickLittleRedEnvelope) forControlEvents:UIControlEventTouchUpInside];
            
            if (!self.littleRedEnvelope.superview && bt.tag==t) {
                [bt addSubview:self.littleRedEnvelope];
                self.littleRedEnvelope.alpha = 0;
                [self.littleRedEnvelope startAnimaition];
                
                [UIView animateWithDuration:5 animations:^{
                    __weakSelf.littleRedEnvelope.alpha = 1;
                } completion:^(BOOL finished) {
                    [__weakSelf.say redenvelope_comein];
                    // 五秒后隐藏
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [UIView animateWithDuration:2 animations:^{
                            __weakSelf.littleRedEnvelope.alpha = 0;
                        } completion:^(BOOL finished) {
                            [__weakSelf.littleRedEnvelope removeFromSuperview];
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                [__weakSelf createLittleRedEnvelopeView];
                            });
                            
                        }];
                    });
                }];
                
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [__weakSelf createLittleRedEnvelopeView];
                });
            }
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [__weakSelf createLittleRedEnvelopeView];
            });
        }
        
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf createLittleRedEnvelopeView];
        });
    }
    
}

-(void)clickLittleRedEnvelope{
    [self.say touchButton];
    [[YunGetRedEnvelope sharedSingleton] show];
    [self.littleRedEnvelope removeFromSuperview];

}

-(void)clickbtaction:(YunPopstarButton *)button{
    if (!_isStartPlay) {
        _isStartPlay = YES;
        if (!_isChallenge) {
            _start_time = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
        }
    }
    if(self.isFinished){
        self.isFinished = NO;
        if ([YunConfig getUserIsUseBomb]) {
            // 如果使用炸弹
            [self bomb:button];
        }else if([YunConfig getUserIsUseMagic]){
            // 变换一个星星颜色
            [self changeColorWithButton:button];
        }else{
            // 获取相同颜色的相邻按钮
            [self getLinkedButtons:button];
            // 消失
            [self popStar];
        }
        
        // 检查是否完成一次消失任务
        [self checkPopstarFinished];
    }
}

-(void)popStar{
    WEAKSELF

    // 消灭五个，欢呼
    if (self.linkButtons.count==5) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say nice];
        });

    }
    if (self.linkButtons.count==6) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say good];
        });

    }
    if (self.linkButtons.count==7) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say welldone];
        });

    }
    // 消灭8个，欢呼
    if (self.linkButtons.count==8) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say verygood];
        });

    }
    // 消灭9个，欢呼
    if (self.linkButtons.count>=9 && self.linkButtons.count<15) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say perfect];
        });

    }
    
    // 消灭15个以上
    if (self.linkButtons.count>=15) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say veryperfect];
        });

    }
    

    float t = 0;
    for (YunPopstarButton *button in self.linkButtons) {
        [self.starButtonsView bringSubviewToFront:button];
        button.selected = YES;
        button.enabled = NO;
        [button performSelector:@selector(hide) withObject:nil afterDelay:t];
        t += kPopTime;
    }
 
    
    // 自由落体
    [self performSelector:@selector(moveDownButtons) withObject:nil afterDelay:t+0.3];
    
    
    YunConfig *config = [YunConfig getConfig];
    if (config && !_isChallenge) {
        NSDictionary *list = [config.link_star_coin mj_JSONObject];
        int star = 0;
        int amount = 0;
        int linksamount = (int)self.linkButtons.count;
        for (NSString*key in list.allKeys) {
            amount = [list[key] intValue];
            star = [key intValue];
            if (linksamount==star && amount>0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1+0.8*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    __weakSelf.goldAmount += amount;
                    [[YunGetGoldView sharedSingleton] show:amount intro:[NSString stringWithFormat:@"消灭%d颗星星",linksamount] type:0];
                });

            }
        }
        if (self.linkButtons.count>star && amount>0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1+0.8*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [[YunGetGoldView sharedSingleton] show:amount intro:[NSString stringWithFormat:@"消灭%d颗星星",linksamount] type:0];
            });
        }
    }
    
//    // 消灭6个以上奖励金币
//    if (self.linkButtons.count==6) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1+0.8*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [[YunGetGoldView sharedSingleton] show:18];
//        });
//    }
//    // 消灭6个以上奖励金币
//    if (self.linkButtons.count==7) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1+0.8*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [[YunGetGoldView sharedSingleton] show:28];
//        });
//    }
//    // 消灭6个以上奖励金币
//    if (self.linkButtons.count==8) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1+0.8*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [[YunGetGoldView sharedSingleton] show:38];
//        });
//    }
//    // 消灭6个以上奖励金币
//    if (self.linkButtons.count>=9 && self.linkButtons.count<15) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1+0.8*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [[YunGetGoldView sharedSingleton] show:58];
//        });
//    }
    
//    // 消灭15个以上奖励金币
//    if (self.linkButtons.count>=15) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1+0.8*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [[YunGetGoldView sharedSingleton] show:118];
//        });
//    }
    
    // 消除命令
    [[YunStarCommand sharedSingleton] cmdWithName:@"pop" linkButtons:self.linkButtons];
    
}

/// 获取连接的相同颜色的按钮
/// @param button 当前点击的按钮
-(void)getLinkedButtons:(YunPopstarButton *)button{
    if (!self.linkButtons) {
        self.linkButtons = [NSMutableArray new];
    }
    [self.linkButtons removeAllObjects];
    // 查找此按钮的上下左右相邻颜色按钮
    [self checkFourButtons:button];
    
}
- (void)checkFourButtons:(YunPopstarButton *)sender {
    
    //NSLog(@"sender.tag=%ld",(long)sender.tag);
    
    YunPopstarButton *buttonLeft = nil;
    YunPopstarButton *buttonRight = nil;
    YunPopstarButton *buttonTop = nil;
    YunPopstarButton *buttonBottom = nil;
    
    if (sender.tag % 10 != 0) {
        buttonLeft = [self.starButtonsView viewWithTag:sender.tag - 1];
    }
    
    if (sender.tag % 10 != 9) {
        buttonRight = [self.starButtonsView viewWithTag:sender.tag + 1];
    }
    
    if (sender.tag / 10 != 0) {
        buttonTop = [self.starButtonsView viewWithTag:sender.tag - 10];
    }
    
    if (sender.tag / 10 != 9) {
        buttonBottom = [self.starButtonsView viewWithTag:sender.tag + 10];
    }
    
    if (![[sender class] isEqual:[YunPopstarButton class]]) {
        sender = nil;
    }
    if (![[buttonLeft class] isEqual:[YunPopstarButton class]]) {
        buttonLeft = nil;
    }
    if (![[buttonRight class] isEqual:[YunPopstarButton class]]) {
        buttonRight = nil;
    }
    if (![[buttonTop class] isEqual:[YunPopstarButton class]]) {
        buttonTop = nil;
    }
    if (![[buttonBottom class] isEqual:[YunPopstarButton class]]) {
        buttonBottom = nil;
    }
    
    
    if ((buttonLeft && buttonLeft.color == sender.color && ![_linkButtons containsObject:buttonLeft]) ||
        (buttonRight && buttonRight.color == sender.color && ![_linkButtons containsObject:buttonRight]) ||
        (buttonTop && buttonTop.color == sender.color && ![_linkButtons containsObject:buttonTop]) ||
        (buttonBottom && buttonBottom.color == sender.color && ![_linkButtons containsObject:buttonBottom])) {
        
        [_linkButtons addObject:sender];
        [self.buttonStatus setObject:@(0) forKey:[NSString stringWithFormat:@"%d",(int)sender.tag]];
    } else {
        if (_linkButtons.count > 0) {
            [self.buttonStatus setObject:@(0) forKey:[NSString stringWithFormat:@"%d",(int)sender.tag]];
            [_linkButtons addObject:sender];
        }
        return;
    }
    
    if (buttonLeft && buttonLeft.color == sender.color && ![_linkButtons containsObject:buttonLeft]) {
    
        [self checkFourButtons:buttonLeft];
    }
    
    if (buttonRight && buttonRight.color == sender.color && ![_linkButtons containsObject:buttonRight]) {
   
        [self checkFourButtons:buttonRight];
    }
    
    if (buttonTop && buttonTop.color == sender.color && ![_linkButtons containsObject:buttonTop]) {
   
        [self checkFourButtons:buttonTop];
    }
    
    if (buttonBottom && buttonBottom.color == sender.color && ![_linkButtons containsObject:buttonBottom]) {
  
        [self checkFourButtons:buttonBottom];
    }
}


/// 按钮自由落体
-(void)moveDownButtons{
    [self.downButtons removeAllObjects];
    // 排序一下先,从上到下去搜索
    NSArray *sortedArray = [self.linkButtons sortedArrayUsingComparator:^NSComparisonResult(YunPopstarButton *p1, YunPopstarButton *p2){
        //对数组进行排序（升序）
        return p1.tag>p2.tag;
    }];
    int t=0;
    for (YunPopstarButton *button in sortedArray) {
        int tag = (int)button.tag;
        // 防止重复
        button.tag = tag * 1000;
        BOOL isLast = button==sortedArray.lastObject;
        [self checkButtonDowns:tag step:10 s:1  isLast:isLast t:t];
        t+=1;
    }
    if (self.downButtons.count>0) {
        [self.say say:@"lz_movedown.wav"];
    }
    

    [self moveLeftButtons];
    
    [self performSelector:@selector(setButtonTag) withObject:nil afterDelay:0.5];
}

- (void)checkButtonDowns:(int)tag step:(int)step s:(int)s isLast:(BOOL)isLast t:(int)t{
    
    WEAKSELF
    
    YunPopstarButton *buttonBottom = nil;
    
    int target_tag = tag - step;
    //NSLog(@"target_tag=%d",target_tag);
    buttonBottom = [self.starButtonsView viewWithTag:target_tag];
    if (buttonBottom && [[buttonBottom class] isEqual:[YunPopstarButton class]]) {
        if (buttonBottom.selected) {
            // 跳过继续上一个
            [self checkButtonDowns:tag step:step+10 s:s+1 isLast:isLast t:t];
        }else{
            int btw = (int)self.frame.size.width/10;
            int bth = btw;
            if (target_tag>=0 && target_tag<100) {
                int x = buttonBottom.frame.origin.x;
                int y = buttonBottom.frame.origin.y + buttonBottom.frame.size.height*s;
//                int w = buttonBottom.frame.size.width;
//                int h = buttonBottom.frame.size.height;
                int end_tag = x / btw + y / bth * 10;
                buttonBottom.tag = end_tag;
                NSLog(@"oldtag=%d,tag=%d move=%d",tag,end_tag,y);
                buttonBottom.isMoving = YES;
                [self.buttonStatus setObject:@(0) forKey:[NSString stringWithFormat:@"%d",end_tag]];
                [buttonBottom moveDown:y block:^(YunPopstarButton * me, BOOL finished) {
                    buttonBottom.isMoving = NO;
                    [__weakSelf.buttonStatus setObject:@(1) forKey:[NSString stringWithFormat:@"%d",end_tag]];
                }];
                [self.downButtons addObject:buttonBottom];
                //[sender removeFromSuperview];
                [self checkButtonDowns:tag step:step+10 s:s isLast:isLast t:t];
            }
        }
    }else{
        if (target_tag>=0 && target_tag<100) {
            // 跳过继续上一个
            [self checkButtonDowns:tag step:step+10 s:s isLast:isLast t:t];
        }
    }
}

/// 向左移动星星
-(void)moveLeftButtons{
    // 检查最后一排的星星是否存在，不存在就要向左移动拉
    for (int i=90; i<100; i++) {
        YunPopstarButton *button = [self.starButtonsView viewWithTag:i];
        BOOL isClear = YES;
        if(button){
            isClear = button.isClear;
        }
        if(isClear){
            // 如果星星已经消失,那就查找下一排星星，并且移动x轴
            int tag = i + 1;
            [self moveLeft:tag s:1];
        }
    }
    
}

/// 向左移动
/// @param start_tag 起始标签
/// @param s 移动列数
-(void)moveLeft:(int)start_tag s:(int)s{
    WEAKSELF
    YunPopstarButton *start_button = [self.starButtonsView viewWithTag:start_tag];
    if (start_button) {
        int tag_num = start_tag % 10;
        for (int i=0; i<10; i++) {
            int tag = tag_num + i*10;
            int btw = (int)self.frame.size.width/10;
            int bth = btw;
            YunPopstarButton *button = [self.starButtonsView viewWithTag:tag];
            if (tag>0 && tag<100 && button) {
                int x = button.frame.origin.x;
                int y = button.frame.origin.y;
                int w = button.frame.size.width;
                //int h = button.frame.size.height;
                x -= w*s;
                int end_tag = x / btw + y / bth * 10;
                button.tag = end_tag;
                //NSLog(@"oldtag=%d,tag=%d move=%d",tag,end_tag,y);
                button.isMoving = YES;
                [self.buttonStatus setObject:@(0) forKey:[NSString stringWithFormat:@"%d",end_tag]];
                
                [button moveLeft:x block:^(YunPopstarButton * me, BOOL finished) {
                    button.isMoving = NO;
                    [__weakSelf.buttonStatus setObject:@(1) forKey:[NSString stringWithFormat:@"%d",end_tag]];
                    
                }];
                
            }
        }
        [self moveLeft:start_tag+1 s:1];
    }else{
        if (start_tag<100) {
            // 遇到空的继续寻找下一个，并且移动列数加1
            [self moveLeft:start_tag+1 s:s+1];
        }
    }

}


/// 检查是否还有相同颜色的星星，没有就全部爆裂
-(void)checkTheSameStar{
    BOOL isHasTheSameStar = NO;
    for (YunPopstarButton *button in self.starButtonsView.subviews) {
        YunPopstarButton *buttonLeft = nil;
        YunPopstarButton *buttonRight = nil;
        YunPopstarButton *buttonTop = nil;
        YunPopstarButton *buttonBottom = nil;
        
        if (button.tag % 10 != 0) {
            buttonLeft = [self.starButtonsView viewWithTag:button.tag - 1];
        }
        
        if (button.tag % 10 != 9) {
            buttonRight = [self.starButtonsView viewWithTag:button.tag + 1];
        }
        
        if (button.tag / 10 != 0) {
            buttonTop = [self.starButtonsView viewWithTag:button.tag - 10];
        }
        
        if (button.tag / 10 != 9) {
            buttonBottom = [self.starButtonsView viewWithTag:button.tag + 10];
        }
        
        if (![[buttonLeft class] isEqual:[YunPopstarButton class]]) {
            buttonLeft = nil;
        }
        if (![[buttonRight class] isEqual:[YunPopstarButton class]]) {
            buttonRight = nil;
        }
        if (![[buttonTop class] isEqual:[YunPopstarButton class]]) {
            buttonTop = nil;
        }
        if (![[buttonBottom class] isEqual:[YunPopstarButton class]]) {
            buttonBottom = nil;
        }
        
        if ((buttonLeft && buttonLeft.color == button.color) ||
            (buttonRight && buttonRight.color == button.color) ||
            (buttonTop && buttonTop.color == button.color) ||
            (buttonBottom && buttonBottom.color == button.color)) {
            isHasTheSameStar = YES;
            break;
        }
    }
    
    
    // 剩余爆破
    if (!isHasTheSameStar) {
        [self gameOverAction];
    }

}

/// 通过按钮位置换算tag值
- (void)setButtonTag {
    int btw = (int)self.frame.size.width/10;
    int bth = btw;
    for (YunPopstarButton *button in self.starButtonsView.subviews) {
        int tag = button.frame.origin.x / btw + button.frame.origin.y / bth * 10;
        if (button.selected) {
            //[button removeFromSuperview];
        }else{
            if (button.firstTag<0) {
                button.firstTag = tag;
            }
            button.tag = tag;
        }
    }
}

- (void)checkPopstarFinished{
    typeof(self) __weak weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{    // 检查是否完成一次清除工作，只有完成清除后才可以继续下一次清除
        while (true) {
            __block BOOL isFinish = YES;
            @synchronized(weakSelf) {
                if (weakSelf.buttonStatus) {
                    for (NSString *key in weakSelf.buttonStatus.allKeys) {
                      BOOL isClear = [weakSelf.buttonStatus[key] boolValue];
                      dispatch_sync(dispatch_get_main_queue(), ^{
                          YunPopstarButton *button = [weakSelf.starButtonsView viewWithTag:[key intValue]];
                          if (!isClear && button) {
                              // 未消失，等待
                              NSLog(@"消失：%@",key);
                              isFinish = NO;
                          }

                      });
                    }
                }else{
                    isFinish = NO;
                }
                weakSelf.isFinished = isFinish;
            }
            
            if (isFinish) {
                [weakSelf.buttonStatus removeAllObjects];
                NSLog(@"完成一次");
                break;;
            }
            NSLog(@"weakSelf.isFinished=%d",isFinish);
            [NSThread sleepForTimeInterval:0.3];
        }
    });
}

- (void)checkPopstarHasTheSame{
    typeof(self) __weak weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{    // 检查相同的星星，没有就爆破
        while (!weakSelf.isExit) {
            
            @synchronized(weakSelf) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                        if (!weakSelf.gameOver) {
                          [weakSelf checkTheSameStar];
                        }
                    
                });
            }
            [NSThread sleepForTimeInterval:0.5];
        }
        
    });
}

// 炸弹 点击按钮，把按钮四周的星星炸掉
-(void)bomb:(YunPopstarButton*)button{
    button.enabled = NO;
    [self.say say:@"lz_tool_bg_bomb.mp3"];
    if (!self.linkButtons) {
        self.linkButtons = [NSMutableArray new];
    }
    [self.linkButtons removeAllObjects];
    
    YunPopstarButton *buttonLeft = nil;
    YunPopstarButton *buttonRight = nil;
    YunPopstarButton *buttonTop = nil;
    YunPopstarButton *buttonBottom = nil;
    
    YunPopstarButton *buttonTopLeft = nil;
    YunPopstarButton *buttonTopRight = nil;
    YunPopstarButton *buttonBottomRight = nil;
    YunPopstarButton *buttonBottomLeft = nil;
    
    if (button.tag % 10 != 0) {
        buttonLeft = [self.starButtonsView viewWithTag:button.tag - 1];
    }
    
    if (button.tag % 10 != 9) {
        buttonRight = [self.starButtonsView viewWithTag:button.tag + 1];
    }
    
    if (button.tag / 10 != 0) {
        int toptag = (int)button.tag - 10;
        buttonTop = [self.starButtonsView viewWithTag:toptag];
        if ((toptag-1)/10 == toptag/10) {
            buttonTopLeft = [self.starButtonsView viewWithTag:toptag - 1];
        }
        if ((toptag+1)/10 == toptag/10) {
            buttonTopRight = [self.starButtonsView viewWithTag:toptag + 1];
        }
    }
    
    if (button.tag / 10 != 9) {
        int bottomtag = (int)button.tag + 10;
        buttonBottom = [self.starButtonsView viewWithTag:bottomtag];
        if ((bottomtag-1)/10 == bottomtag/10) {
            buttonBottomLeft = [self.starButtonsView viewWithTag:bottomtag-1];
        }
        if ((bottomtag+1)/10 == bottomtag/10) {
            buttonBottomRight = [self.starButtonsView viewWithTag:bottomtag+1];
        }
        
    }
    
    if (![[buttonLeft class] isEqual:[YunPopstarButton class]]) {
        buttonLeft = nil;
    }
    if (![[buttonRight class] isEqual:[YunPopstarButton class]]) {
        buttonRight = nil;
    }
    if (![[buttonTop class] isEqual:[YunPopstarButton class]]) {
        buttonTop = nil;
    }
    if (![[buttonTopLeft class] isEqual:[YunPopstarButton class]]) {
        buttonTopLeft = nil;
    }
    if (![[buttonTopRight class] isEqual:[YunPopstarButton class]]) {
        buttonTopRight = nil;
    }
    if (![[buttonBottom class] isEqual:[YunPopstarButton class]]) {
        buttonBottom = nil;
    }
    if (![[buttonBottomLeft class] isEqual:[YunPopstarButton class]]) {
        buttonBottomLeft = nil;
    }
    if (![[buttonBottomRight class] isEqual:[YunPopstarButton class]]) {
        buttonBottomRight = nil;
    }

    if (button) {
        [self.linkButtons addObject:button];
    }
    if (buttonLeft) {
        [self.linkButtons addObject:buttonLeft];
    }
    if (buttonRight) {
        [self.linkButtons addObject:buttonRight];
    }
    if (buttonTop) {
        [self.linkButtons addObject:buttonTop];
    }
    if (buttonTopLeft) {
        [self.linkButtons addObject:buttonTopLeft];
    }
    if (buttonTopRight) {
        [self.linkButtons addObject:buttonTopRight];
    }
    if (buttonBottom) {
        [self.linkButtons addObject:buttonBottom];
    }
    if (buttonBottomLeft) {
        [self.linkButtons addObject:buttonBottomLeft];
    }
    if (buttonBottomRight) {
        [self.linkButtons addObject:buttonBottomRight];
    }
    for (YunPopstarButton *bt in self.linkButtons) {
        [self.starButtonsView bringSubviewToFront:bt];
        bt.selected = YES;
        bt.enabled = NO;
        [bt hideNoAnimation];
    }
    
    // 爆炸命令
    [[YunStarCommand sharedSingleton] cmdWithName:@"bomb" linkButtons:self.linkButtons];
    
    [self bombAnimation:button];
    
    // 自由落体
    [self performSelector:@selector(moveDownButtons) withObject:nil afterDelay:0.5];
    
    // 炸弹减1
    if (!_isChallenge) {
        int amount = [YunConfig getUserBombAmount];
        amount --;
        if (amount<=0) {
            amount = 0;
        }
        [YunConfig setUserBombAmount:amount];
    }
    
    
    // 工具完成
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_ToolFinished object:@"1"];
    
}

// 刷新颜色
-(void)refreshButtons{
    if([YunConfig getUserIsUseRefresh]){
        for (YunPopstarButton *button in self.starButtonsView.subviews) {
            int color = arc4random() % 5;
            button.color = color;
        }
    }
    
    // 刷新命令
    [[YunStarCommand sharedSingleton] cmdWithName:@"refresh" linkButtons:self.starButtonsView.subviews];
    
    if (!_isChallenge) {
        // 刷新减1
        int amount = [YunConfig getUserRefreshAmount];
        amount --;
        if (amount<=0) {
            amount = 0;
        }
        [YunConfig setUserRefreshAmount:amount];
    }
    // 工具完成
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_ToolFinished object:@"0"];
    
    
}

// 变换颜色
-(void)changeColorWithButton:(YunPopstarButton*)button{
    WEAKSELF
    //int oldcode = button.color;
    // 显示弹框
    [self.say touchButton];
    [self.starButtonsView bringSubviewToFront:button];
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:1];
    anima2.toValue = [NSNumber numberWithFloat:2];
    anima2.duration = 0.5;
    anima2.autoreverses = YES;
    anima2.repeatCount = NSNotFound;
    //以下两行同时设置才能保持移动后的位置状态不变
//    anima2.fillMode=kCAFillModeForwards;
//    anima2.removedOnCompletion = NO;
    
    [button.layer addAnimation:anima2 forKey:nil];
    
    // 烟雾
//    MCSteamView *smoke = [[MCSteamView alloc] initWithFrame: button.frame];
//    [self addSubview:smoke];
//    [self bringSubviewToFront:button];
    
    [[YunPopstarMagicView sharedSingleton] show];
    [YunPopstarMagicView sharedSingleton].magicBlock = ^(PopstarColor color,BOOL success) {
        //[smoke removeFromSuperview];
        [__weakSelf.say touchButton];
        [__weakSelf.starButtonsView bringSubviewToFront:button];
        CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        anima2.fromValue = [NSNumber numberWithFloat:2];
        anima2.toValue = [NSNumber numberWithFloat:1];
        //以下两行同时设置才能保持移动后的位置状态不变
        anima2.fillMode=kCAFillModeForwards;
        anima2.removedOnCompletion = NO;
        anima2.duration = 0.5;
        [button.layer addAnimation:anima2 forKey:nil];
        
        if (success) {
            button.color = color;
            if (!__weakSelf.isChallenge) {
                // 减1
                int amount = [YunConfig getUserMagicAmount];
                amount --;
                if (amount<=0) {
                    amount = 0;
                }
                [YunConfig setUserMagicAmount:amount];
            }
        }
        
        // 改变颜色命令
        [[YunStarCommand sharedSingleton] cmdWithName:@"magic" linkButtons:@[button]];
        
        // 工具完成
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_ToolFinished object:@"2"];
        
    };
}

// 游戏结束
-(void)gameOverAction{
    self.gameOver = YES;
    
    // 表名已经没有相同颜色的了，就爆破所有星星
    self.gameOverLastStarCount = 0;
    float t = 0;
    int i = 0;
    for (YunPopstarButton *button in self.starButtonsView.subviews) {
        if (!button.isClear) {
            self.gameOverLastStarCount += 1;
            // 挑战模式不用自动消灭完，留着
            if (!_isChallenge) {
                [self sendSubviewToBack:button];
                int rnd = 3 + arc4random() % 3;
                if (i<rnd) {
                    // 前面3到5个内可以加分奖励
                    button.isReward = YES;
                    t += 5*kPopTime;
                }else{
                    t += kPopTime;
                }
                [button performSelector:@selector(hide) withObject:nil afterDelay:t];
                i ++;
            }
        }
        
        //sleep(0.1);
        
    }
    // 全部打完，奖励
    if (!_isChallenge) {
        if(self.gameOverLastStarCount<=0){
            
            // 如果游戏结束，全部打完奖励 1000-2000分,奖励10个金币
            //[[YunPopstarShowMsgView sharedSingleton] showPerfect];
            int from = 1000;
            int to = 2000;
            int rnd = from +  (arc4random() % (to-from+1));
            float fenshu = rnd;
            [self.say reward];
            [[YunPopstarShowMsgView sharedSingleton] showMsg:[NSString stringWithFormat:@"+%.f",fenshu]];
            // 生成一个分数的icon
            YunPopstarScoreTip *score = [[YunPopstarScoreTip alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 0, 0) color:0 scroe:fenshu];
            [self addSubview:score];
            [score performSelector:@selector(hide) withObject:nil afterDelay:0.5];
            // 奖励88个金币
            int clear_star_golds = [[YunConfig getConfig].clear_star_golds intValue];
            _goldAmount += clear_star_golds;
            [[YunGetGoldView sharedSingleton] show:clear_star_golds intro:@"清空奖励金币" type:5];
            WEAKSELF
            [YunGetGoldView sharedSingleton].hideBlock = ^{
                [__weakSelf saveUserCoin:t];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GameOver object:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                });
            };
        }else{
            [self saveUserCoin:t];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GameOver object:nil];
            
        }
    }else{
        [self saveUserChallenge:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GameOver object:nil];
        
    }
    
    //[self.say stop];
}

// 目标达成 显示
-(void)showPassTarget{
//    // 上次分数
//    int count = [YunConfig getUserCoin];
//    // 当前关卡分数
//    int currentCount = [YunConfig getUserCoinSingle];
//    // 当前总分
//    count += currentCount;
//    // 当前目标
//    int target = [YunConfig getUserTargetCoin];
//    // 是否大于当前目标分数
//    if(count>target && !_isPass){
//        _isPass = YES;
//        [self.say passtarget];
//    }else{
//        
//    }
}

// 每一关结束后，保存这一关的分数
-(void)saveUserCoin:(float)t{
    // 测试回放
//    YunPlayPopStarViewController *play = [[YunPlayPopStarViewController alloc] initWityCmds:[YunStarCommand sharedSingleton].cmdlines];
//    [(UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController pushViewController:play animated:YES];
    // 打印命令
    NSString *end_time = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    NSMutableArray *cmds = [YunStarCommand sharedSingleton].cmdlines;
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t+1.5)*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSLog(@"%@",cmds);
        int count = [YunConfig getUserCoin];
        int currentCount = [YunConfig getUserCoinSingle];
        count += currentCount;
        
        // 分数对应通关等级,是否通过，如果大于当前等级，就表明通过了
        int target = [YunConfig getUserTargetCoin];
        __block int passNumber = [YunConfig getUserPassNumber];
        
        // 控制玩多局相同关卡强弹广告
        int levels = passNumber;
        int amount = 0;
        NSString *levels_sametime = [YunConfig get:kConfig_User_LevelsSameTime];
        if (levels_sametime) {
            NSDictionary *sametime = [levels_sametime mj_JSONObject];
            if (sametime) {
                levels = [sametime[@"levels"] intValue];
                amount = [sametime[@"amount"] intValue];
                if (levels==passNumber) {
                    amount ++;
                }else{
                    levels = passNumber;
                    amount = 1;
                }
            }
        }
//        if (amount>=[[YunConfig getConfig].levels_sametime_ad intValue]) {
//            // 弹出广告
//            [self openAd];
//        }
        NSDictionary *newsametime = @{@"levels":@(levels).stringValue,@"amount":@(amount).stringValue};
        [YunConfig seting:kConfig_User_LevelsSameTime value:[newsametime mj_JSONString]];
        
        
        NSDictionary *p = @{
            @"levels":@(passNumber).stringValue,
            @"fraction":@(count).stringValue,
            @"gold":@([YunConfig getUserGold]).stringValue,
            @"max_fraction":@([YunConfig getUserCoinMax]).stringValue,
            @"tool_refresh_num":@([YunConfig getUserRefreshAmount]).stringValue,
            @"tool_bomb_num":@([YunConfig getUserBombAmount]).stringValue,
            @"tool_magic_num":@([YunConfig getUserMagicAmount]).stringValue,
            @"start_time":__weakSelf.start_time,
            @"end_time":end_time,
            @"cmds":[cmds mj_JSONString]
            
        };
        
        [http sendPostRequestWithParams:p api:kAPI_Users_AddLevels start:^{
            [SVProgressHUD showWithStatus:@"正在存档..."];
        } failure:^{
            [SVProgressHUD showErrorWithStatus:@"存档失败，网络不给力"];
            [fn sleepSeconds:1 finishBlock:^{
                // 金币回退
                int amount = [YunConfig getUserGold];
                amount -= __weakSelf.goldAmount;
                [YunConfig setUserGold:amount];
                // 红包进度回滚
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_PassFail object:@(100-self.gameOverLastStarCount)];
                // 更新分数
                // 存档失败 无法进入下一关
                int nextTarget = [YunConfig passNumberDefaultTargetNumber:passNumber];
                [YunConfig setUserTargetCoin:nextTarget];
                [YunConfig setUserCoinSingle:0]; // 当前关卡分数复位0
                //[__weakSelf performSelector:@selector(showPassRewardView) withObject:nil afterDelay:t+1.5];
                [__weakSelf resetStarView];
            }];
            
            
        } success:^(NSDictionary *dic) {
            [SVProgressHUD dismiss];
            int code = [dic[@"code"] intValue];
            if (code==200) {
                [YunConfig setUserCoin:count];
                // 存档成功
                if(count>=target){
                    passNumber ++ ;// 关卡加1
                    [YunConfig setUserPassNumber:passNumber];
                    // 下一关的目标分数
                    int nextTarget = [YunConfig passNumberDefaultTargetNumber:passNumber];
                    [YunConfig setUserTargetCoin:nextTarget];
                    [YunConfig setUserCoinSingle:0]; // 当前关卡分数复位0
                    //[__weakSelf performSelector:@selector(showPassRewardView) withObject:nil afterDelay:t+1.5];
                    [__weakSelf showPassRewardView];
                }else{
                    // 没有过关，保持原来的关卡
                    passNumber = [YunConfig getUserPassNumber];
                    // 下一关的目标分数
                    int nextTarget = [YunConfig passNumberDefaultTargetNumber:passNumber];
                    [YunConfig setUserTargetCoin:nextTarget];
                    [YunConfig setUserCoinSingle:0]; // 当前关卡分数复位0
                   // [__weakSelf performSelector:@selector(resetStarView) withObject:nil afterDelay:t+1.5];
                    [__weakSelf showNoPassRewardView];
                }
            }else{
                FMHttpShowError(dic);
                [__weakSelf resetStarView];
            }
        }];
        
        
    });
    

}
// 保存挑战记录
-(void)saveUserChallenge:(float)t{
  
    // 打印命令
    NSMutableArray *cmds = [YunStarCommand sharedSingleton].cmdlines;
    NSString *end_time = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    WEAKSELF
    NSLog(@"%@",cmds);
    // 挑战的关卡ID
    NSString *parent_user_levels_id = [NSString stringWithFormat:@"%@",__weakSelf.challenger[@"id"]];
    int seconds = [end_time stringToDateWithFormat:@"yyyy-MM-dd HH:mm:ss"].timeIntervalSince1970 - [__weakSelf.start_time stringToDateWithFormat:@"yyyy-MM-dd HH:mm:ss"].timeIntervalSince1970;
    int popnum = 100 - __weakSelf.gameOverLastStarCount;
    // 结束时间
    NSDictionary *p = @{
        @"start_time":__weakSelf.start_time,
        @"end_time":end_time,
        @"cmds":[cmds mj_JSONString],
        @"user_levels_id":parent_user_levels_id
    };
    
    [http sendPostRequestWithParams:p api:kAPI_Users_AddChallenge start:^{
        [SVProgressHUD showWithStatus:@"正在存档..."];
    } failure:^{
        //[SVProgressHUD showErrorWithStatus:@"存档失败，网络不给力"];
        [[YunShowMsg sharedSingleton] show:@"挑战结果" content:@"网络不给力，请重试" sure:^{
            [((UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController) popViewControllerAnimated:YES] ;
        }];
    } success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        int code = [dic[@"code"] intValue];
        if (code==200) {
            int status = [dic[@"data"] intValue];
            // 存档成功
            if(status==1){
                // 挑战成功
                [[YunChallengePassView sharedSingleton] showSuccess:__weakSelf.challenger seconds:seconds popnum:popnum];
                // 保存挑战过的关卡ID
                NSMutableArray *ids = [NSMutableArray arrayWithArray:[[YunConfig get:kConfig_User_Challenged_UserLevelsIds] mj_JSONObject]];
                if (!ids) {
                    ids = [NSMutableArray new];
                }
                [ids addObject:parent_user_levels_id];
                [YunConfig seting:kConfig_User_Challenged_UserLevelsIds value:[ids mj_JSONString]];
            }else{
                
                // 挑战失败
                [[YunChallengePassView sharedSingleton] showFail:__weakSelf.challenger seconds:seconds popnum:popnum];
            }
        }else{
            //FMHttpShowError(dic);
            NSString*msg = dic[@"msg"];
            if (!msg) {
                msg = @"网络不给力，请返回重试！";
            }
            [[YunShowMsg sharedSingleton] show:@"挑战结果" content:msg sure:^{
                [((UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController) popViewControllerAnimated:YES] ;
            }];
        }
    }];
    

}


-(void)bombAnimation:(YunPopstarButton*)button{
    //爆炸
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.bounds;
    [self.layer addSublayer:emitter];
    self.fireworksLayer = emitter;
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width*0.5,    emitter.frame.size.height*0.5);
    emitter.emitterSize= CGSizeMake(1, 1);
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.name = @"sparkCell";
    cell.contents = (__bridge id)[UIImage imageNamed:@"lz_star"].CGImage;//和CALayer一样，只是用来设置图片
    cell.birthRate = 150;//出生率
    cell.lifetime = 2.0;//生命周期
    cell.emissionLongitude = 0;//决定了粒子飞行方向跟水平坐标轴（x轴）之间的夹角，默认是0，即沿着x轴向右飞行。
    cell.color = [UIColor redColor].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 350;//速度
    cell.velocityRange = 500;//速度范围
    cell.yAcceleration = 575.f;  // 模拟重力影响
    cell.emissionRange =M_PI_2;
    cell.scale = 0.3;
    cell.redRange = 1.f;
    cell.greenRange = 1.f;
    cell.blueSpeed = 1.f;
    cell.alphaRange = 0.1;
    cell.alphaSpeed = -0.1f;
    cell.scaleRange = 0.5;
    cell.scaleSpeed = 0.01;
    
    CAEmitterCell *cell2 = [[CAEmitterCell alloc] init];
    cell2.name = @"sparkCell2";
    cell2.contents = (__bridge id)[UIImage imageNamed:@"lz_star"].CGImage;//和CALayer一样，只是用来设置图片
    cell2.birthRate = 100;//出生率
    cell2.lifetime = 2.0;//生命周期
    cell2.emissionLongitude = 0;//决定了粒子飞行方向跟水平坐标轴（x轴）之间的夹角，默认是0，即沿着x轴向右飞行。
    cell2.color = [UIColor yellowColor].CGColor;
    cell2.alphaSpeed = -0.4;
    cell2.velocity = 150;//速度
    cell2.velocityRange = 500;//速度范围
    cell2.yAcceleration = 575.f;  // 模拟重力影响
    cell2.emissionRange =M_PI_2;
    cell2.scale = 0.2;
    cell2.redSpeed = 0.4;
    cell2.greenSpeed = -0.1;
    cell2.blueSpeed = -0.1;
    cell2.alphaSpeed = -0.25;
    //add particle template to emitter
    emitter.emitterPosition = CGPointMake(button.frame.origin.x+button.frame.size.width/2, button.frame.origin.y+button.frame.size.height/2); // 在底部
    emitter.emitterMode = kCAEmitterLayerOutline;
    emitter.emitterShape = kCAEmitterLayerLine;
    emitter.renderMode = kCAEmitterLayerAdditive;
    
    emitter.emitterCells = @[cell,cell2];
    
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.5];
}

/**
 * 动画结束
 */
- (void)stopAnimation{
    // 用KVC设置颗粒个数
    [self.fireworksLayer setValue:@0 forKeyPath:@"emitterCells.sparkCell.birthRate"];
    [self.fireworksLayer setValue:@0 forKeyPath:@"emitterCells.sparkCell2.birthRate"];
    //[self.fireworksLayer removeAllAnimations];
}

// 红包激活
-(void)notificationRedEnvelopeActive{
    _isShowRedenvelope = YES;
}
// 红包关闭
-(void)notificationRedEnvelopeClose{
    _isShowRedenvelope = NO;
}

// 过关奖励界面
-(void)showPassRewardView{
    //[self.say stop];
    WEAKSELF
    [[YunPopstarPassRewardView sharedSingleton] show:self.gameOverLastStarCount];
    [YunPopstarPassRewardView sharedSingleton].clickButtonBlock = ^(UIButton * _Nonnull button) {
        [__weakSelf resetStarView];
    };
}
-(void)showNoPassRewardView{
    // 没过关，红包倒计时回退
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_PassFail object:@(100-self.gameOverLastStarCount)];
    //[self.say stop];
    WEAKSELF
    [[YunPopstarPassRewardView sharedSingleton] showfail];
    [YunPopstarPassRewardView sharedSingleton].clickButtonBlock = ^(UIButton * _Nonnull button) {
        [__weakSelf resetStarView];
    };
}


-(void)openAd{
    // 领取奖励看广告
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = [YunConfig getUserId];;
    self.rewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:kCsj_sloteid_945440304 rewardedVideoModel:model];
    //self.rewardedVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:@"945438638" adloadSeq:1 primeRit:@"945438638" rewardedVideoModel:model];
    self.rewardedVideoAd.delegate = self;
    [self.rewardedVideoAd loadAdData];
    [MobClick beginEvent:@"levels_sametime_ad"];
    self.ad_start_time = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    self.requestid = [fn getTimestamp];
    [http sendApiUserAd:@"连续通关失败视频激励广告" type:0 ad:kCsj_sloteid_945440304 start_time:self.ad_start_time end_time:@"" requestid:self.requestid];
}
//加载广告的时候，delegate 传的是self，广告事件发生后会自动回调回来，我们只需要重新实现这些方法即可
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
    NSLog(@"展示奖励视频广告");
    if(self.rewardedVideoAd.isAdValid){
        [[AppDelegate sharedSingleton].window sendSubviewToBack:self];
        UINavigationController *n = (UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController;
        [self.rewardedVideoAd showAdFromRootViewController:n];
        // 更新广告弹出时间
        //[YunConfig seting:kConfig_User_clearance_show_ad_lasttime value:@([YunConfig getUserPassNumber]).stringValue];
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
    [MobClick endEvent:@"levels_sametime_ad"];
    [[YunGetGoldView sharedSingleton] show:[[YunConfig getConfig].levels_sametime_ad_gold intValue] intro:[NSString stringWithFormat:@"连续通关失败视频激励广告奖励%d金币",[[YunConfig getConfig].levels_sametime_ad_gold intValue]] type:0];
    // 看视频后奖励
    [http sendApiUserAd:@"连续通过失败视频激励广告" type:0 ad:kCsj_sloteid_945440304 start_time:self.ad_start_time end_time:[NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"] requestid:self.requestid];

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
