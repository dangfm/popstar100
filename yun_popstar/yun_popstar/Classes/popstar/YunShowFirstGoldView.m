//
//  YunShowFirstGoldView.m
//  yun_popstar
//
//  Created by dangfm on 2020/8/28.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunShowFirstGoldView.h"

@implementation YunShowFirstGoldView


// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunShowFirstGoldView *_sharedSingleton = nil;
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

    self.mainView.hidden = NO;
    self.maskView.alpha = 0.8;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    
    [self startOtherButtons];
    
}
-(void)initViews{
    [self initSay];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [[AppDelegate sharedSingleton].window addSubview:self];
    
    float w = UIScreenWidth-60;
    float h = UIScreenWidth;
    float x = 30;
    float y = (UIScreenHeight-h)/2;
    float corner = 30;
    float padding = 20;
    
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
    titleLb.text = @"新人奖励";
    titleLb.font = kFontBold(35);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor whiteColor];
    titleLb.glowSize = 20;
    titleLb.innerGlowSize = 4;
    titleLb.textColor = UIColor.whiteColor;
    titleLb.glowColor = UIColorFromRGB(0x5832b9);
    titleLb.innerGlowColor = UIColorFromRGB(0xc44c4e);

    [self.mainView addSubview:titleLb];
    
    [self createGiftView];
    
    // 关闭按钮
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake(w-30-20, 20, 30, 30)];
    [closeBt setImage:[UIImage imageNamed:@"lz_close_bt"] forState:UIControlStateNormal];
    closeBt.tag = 2;
    [closeBt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:closeBt];
    _closeBt = closeBt;
    

    NSArray *titles = @[@"马上领取"];
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
        if([bt.titleLabel.text isEqualToString:@"马上领取"]){
            bt = [UIButton createDefaultButton:titles[i] frame:CGRectMake(x, y, w, h)];
            [self startButtonAnimation:bt];
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

-(void)startGiftAnimation:(UIButton*)bt{
    //创建一个关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置关键帧
    keyAnimation.values = @[@(-M_PI_4 * 0.1 * 1), @(M_PI_4 * 0.1 * 1), @(-M_PI_4 * 0.1 * 1)];
    //设置重复
    keyAnimation.duration=0.5;      //执行时间
    keyAnimation.repeatCount = NSNotFound;
    keyAnimation.autoreverses=YES;    //完成动画后会回到执行动画之前的状态
    //把核心动画添加到layer上
    [[bt layer] addAnimation:keyAnimation forKey:@"gift_keyAnimation"];
}


-(void)createGiftView{
    
    // 工具按钮
    float w = 180;
    float x = (UIScreenWidth - w)/2;
    float y = (UIScreenHeight-w)/ 2 - 20;
    float h = w;
    
    UIButton *tool1_bg = [[UIButton alloc] init];
    tool1_bg.frame = CGRectMake(x, y, w, h);
    //tool1_bg.layer.cornerRadius = w/2;
    //tool1_bg.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [tool1_bg setImage:[UIImage imageNamed:@"money_box_icon"] forState:UIControlStateNormal];
    [self addSubview:tool1_bg];
    
    UIImage *g = [UIImage imageNamed:@"more_gold_icon"];
    float gw = 50;
    float gh = g.size.height/g.size.width * gw;
    UIImageView *goldv = [[UIImageView alloc] initWithFrame:CGRectMake(w-gw, h-gh, gw, gh)];
    goldv.image = g;
    [tool1_bg addSubview:goldv];
    
    [self startGiftAnimation:tool1_bg];
    
}



-(void)hide{
    self.hidden = YES;
}

-(void)hideSelf:(void(^)(void))block{
    
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
    
    if (self.giftTag<3) {
        x += self.giftTag * (w+padding);
    }
    
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        toolv.frame = CGRectMake(x-3, y-3, w+6, w+6);
        toolv.alpha = 0.2;
        __weakSelf.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        __weakSelf.hidden = YES;
        if (block) {
            block();
        }
    }];
}

// 关闭按钮和不用谢谢按钮，慢慢显示
-(void)startOtherButtons{
    _closeBt.alpha = 0;
    _otherBt.alpha = 0;
//    WEAKSELF
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:3 animations:^{
//            __weakSelf.closeBt.alpha = 1;
//            __weakSelf.otherBt.alpha = 1;
//        }];
//    });
    
}

-(void)clickButton:(UIButton*)button{
    if (button) {
        if ([[button class] isEqual:[UIButton class]]) {
            [self.say touchButton];
            if (button.tag==1) {
                // 点击不用谢谢
                if (self.clickButtonBlock) {
                    self.clickButtonBlock(button);
                }
                
                [self hide];
            }
            if (button.tag==0) {
                // 领取奖励
                WEAKSELF
                // 金币
                [self hide];
                int gold = [[YunConfig getConfig].newmen_gold intValue];
                [[YunGetGoldView sharedSingleton] show:gold intro:@"新人奖励金币" type:6];
                [YunConfig setUserFirstGold:gold];
                [YunGetGoldView sharedSingleton].hideBlock = ^{
                    if (__weakSelf.clickButtonBlock) {
                        __weakSelf.clickButtonBlock(button);
                    }
                };
                
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


@end
