//
//  YunChallengeReadyGo.m
//  yun_popstar
//
//  Created by dangfm on 2020/10/5.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunChallengeReadyGo.h"

@implementation YunChallengeReadyGo

// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunChallengeReadyGo *_sharedSingleton = nil;
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

-(void)show:(NSDictionary *)challenger{
    _challenger = [fn checkNullWithDictionary:challenger];
    self.alpha = 1;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    self.countdownLb.text = @"5";
    [self startCountdownAnimation];
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
    float padding = 20;
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.8;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.maskView addGestureRecognizer:tap];
    [self.maskView setUserInteractionEnabled:YES];
    [self addSubview:self.maskView];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.mainView.backgroundColor = [[UIColor colorWithPatternImage:FMDefaultBackgroundImage] colorWithAlphaComponent:1];
    self.mainView.backgroundColor = [UIColor clearColor];
//    self.mainView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
//    self.mainView.layer.borderWidth = 3;
//    self.mainView.layer.cornerRadius = corner;
    [self addSubview:self.mainView];
    
//    _countdownLb = [[UILabel alloc] initWithFrame:CGRectMake(0, (h-100)/2, w, 100)];
//    _countdownLb.font = kFontBold(100);
//    _countdownLb.textColor = [UIColor whiteColor];
//    _countdownLb.textAlignment = NSTextAlignmentCenter;
//    _countdownLb.text = @"3";
//    [self.mainView addSubview:_countdownLb];
    
    _countdownLb = [[FBGlowLabel alloc] initWithFrame:CGRectMake(0, (h-150)/2, w, 150)];
    _countdownLb.text = @"5";
    _countdownLb.font = kFontBold(150);
    _countdownLb.textAlignment = NSTextAlignmentCenter;
    _countdownLb.textColor = [UIColor whiteColor];
    _countdownLb.glowSize = 20;
    _countdownLb.innerGlowSize = 4;
    _countdownLb.textColor = UIColor.whiteColor;
    _countdownLb.glowColor = UIColorFromRGB(0x5832b9);
    _countdownLb.innerGlowColor = UIColorFromRGB(0xc44c4e);
    _countdownLb.adjustsFontSizeToFitWidth = YES;
    _countdownLb.numberOfLines = 0;
    [self.mainView addSubview:_countdownLb];
    
    // 关闭按钮
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake((UIScreenWidth-20)/2, y+h + 30, 20, 20)];
    [closeBt setImage:[UIImage imageNamed:@"lz_close_bt"] forState:UIControlStateNormal];
    closeBt.tag = 0;
    [closeBt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBt];
    
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    w = 180;
    h = bg.size.height/bg.size.width * w;
    x = (self.mainView.frame.size.width - w) / 2;
    y = self.mainView.frame.size.height - h - padding;
    
    UIButton *bt = [UIButton createDefaultButton:@"立即开始" frame:CGRectMake(x, y, w, h)];
    [bt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    //[self.mainView addSubview:bt];
    _sureBt = bt;
  
}
// 倒计时动画
-(void)startCountdownAnimation{
    
    CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima1.fromValue = [NSNumber numberWithInt:0];
    anima1.toValue = [NSNumber numberWithInt:1];
    //anima1.fillMode = kCAFillModeForwards;
    
    //anima1.duration = 1.3;
    
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:30];
    anima2.toValue = [NSNumber numberWithFloat:1];
    
    //anima2.duration = 1.0;
    //组动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2, nil];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.duration = 0.3;
    groupAnimation.fillMode = kCAFillModeForwards;
    //groupAnimation.delegate = self;
    [self.countdownLb.layer addAnimation:groupAnimation forKey:nil];
    
    int n = [self.countdownLb.text intValue];
    if (n>0 && n<=5) {
        [self.say say:[NSString stringWithFormat:@"countdown_%d.mp3",n]];
    }
    
    
    WEAKSELF
    [fn sleepSeconds:1.0 finishBlock:^{
        int i = [__weakSelf.countdownLb.text intValue];
        i --;
        if (i>=0) {
            
            __weakSelf.countdownLb.text = [NSString stringWithFormat:@"%d",i];
            if (i==0) {
                __weakSelf.countdownLb.text = @"请开始你的表演\nReady Go";
                [__weakSelf.say say:[NSString stringWithFormat:@"countdown_start.mp3"]];
            }
            [__weakSelf startCountdownAnimation];
        }else{
            [__weakSelf.say readygo];
            WEAKSELF
            [fn sleepSeconds:1.0 finishBlock:^{
                [UIView animateWithDuration:0.8 animations:^{
                    __weakSelf.alpha = 0;
                } completion:^(BOOL finished) {
                    __weakSelf.hidden = YES;
                    if (__weakSelf.hideBlock) {
                        __weakSelf.hideBlock();
                    }
                }];
            }];
            
            
            
        }
        
    }];

}

-(void)hide{
    self.hidden = YES;
}

-(void)clickButton:(UIButton*)button{
    [self.say touchButton];
    WEAKSELF
    [UIView animateWithDuration:0.8 animations:^{
        __weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        __weakSelf.hidden = YES;
    }];

   
    if (self.hideBlock) {
        self.hideBlock();
    }
    
}

@end
