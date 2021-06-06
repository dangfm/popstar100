//
//  YunChallengePassView.m
//  yun_popstar
//
//  Created by dangfm on 2020/10/6.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunChallengePassView.h"

@implementation YunChallengePassView
// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunChallengePassView *_sharedSingleton = nil;
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

-(void)showMsg:(NSDictionary *)challenger msg:(NSString*)msg{
    _titleLb.text = @"挑战结果";
    _meLb.text = [NSString stringWithFormat:@"%@",msg];
    _challenger = [fn checkNullWithDictionary:challenger];
    self.alpha = 1;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    
    YunLabel *l = [_sureBt viewWithTag:101];
    l.text = @"返回社区";
    _sureBt.tag = 0;
    
    _statusIconView.hidden = YES;
}
-(void)showSuccess:(NSDictionary *)challenger seconds:(float)seconds popnum:(int)popnum{
    [self.say say:@"challenge_success.wav"];
    _titleLb.text = @"挑战成功";
    _second = seconds;
    _meLb.text = [NSString stringWithFormat:@"%.f秒消灭%d颗星星",seconds,popnum];
    _challenger = [fn checkNullWithDictionary:challenger];
    self.alpha = 1;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    self.mainView.backgroundColor = [[UIColor colorWithPatternImage:FMDefaultBackgroundImage] colorWithAlphaComponent:1];
    YunLabel *l = [_sureBt viewWithTag:101];
    l.text = @"领取奖励";
    _sureBt.tag = 1;
    UIImage *icon = [UIImage imageNamed:@"challenge_success"];
    _statusIconView.image = icon;
    float h = _statusIconView.frame.size.height;
    float w = icon.size.width/icon.size.height * h;
    _statusIconView.frame = CGRectMake((self.mainView.frame.size.width-w)/2, _statusIconView.frame.origin.y, w, h);
    _statusIconView.hidden = NO;
}
-(void)showFail:(NSDictionary *)challenger seconds:(float)seconds popnum:(int)popnum{
    [self.say say:@"challenge_fail.wav"];
    _titleLb.text = @"挑战失败";
    _meLb.text = [NSString stringWithFormat:@"%.f秒消灭%d颗星星",seconds,popnum];
    _challenger = [fn checkNullWithDictionary:challenger];
    self.alpha = 1;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    self.mainView.backgroundColor = [UIColor clearColor];
    YunLabel *l = [_sureBt viewWithTag:101];
    l.text = @"返回社区";
    _sureBt.tag = 0;

    UIImage *icon = [UIImage imageNamed:@"challenge_fail"];
    _statusIconView.image = icon;
    float h = _statusIconView.frame.size.height;
    float w = icon.size.width/icon.size.height * h;
    _statusIconView.frame = CGRectMake((self.mainView.frame.size.width-w)/2, _statusIconView.frame.origin.y, w, h);
    _statusIconView.hidden = NO;
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
    
    _titleLb = [[FBGlowLabel alloc] initWithFrame:CGRectMake(0, 0, w, 80)];
    _titleLb.text = @"";
    _titleLb.font = kFontBold(35);
    _titleLb.textAlignment = NSTextAlignmentCenter;
    _titleLb.textColor = [UIColor whiteColor];
    _titleLb.glowSize = 20;
    _titleLb.innerGlowSize = 4;
    _titleLb.textColor = UIColor.whiteColor;
    _titleLb.glowColor = UIColorFromRGB(0x5832b9);
    _titleLb.innerGlowColor = UIColorFromRGB(0xc44c4e);
    _titleLb.adjustsFontSizeToFitWidth = YES;
    _titleLb.numberOfLines = 0;
    [self.mainView addSubview:_titleLb];
    
    float iconw = 80;
    float yy = (h-30-20-iconw) / 2;
    _meLb = [[FBGlowLabel alloc] initWithFrame:CGRectMake(15, yy+iconw+20, w-30, 31)];
    _meLb.text = @"";
    _meLb.font = kFontBold(30);
    _meLb.textAlignment = NSTextAlignmentCenter;
    _meLb.textColor = [UIColor whiteColor];
    _meLb.glowSize = 20;
    _meLb.innerGlowSize = 4;
    _meLb.textColor = UIColor.whiteColor;
    _meLb.glowColor = UIColorFromRGB(0x5832b9);
    _meLb.innerGlowColor = UIColorFromRGB(0xc44c4e);
    _meLb.adjustsFontSizeToFitWidth = YES;
    _meLb.numberOfLines = 0;
    [self.mainView addSubview:_meLb];
    
    _challengerLb = [[FBGlowLabel alloc] initWithFrame:CGRectMake(15, 110, w-30, 30)];
    _challengerLb.text = @"";
    _challengerLb.font = kFontBold(20);
    _challengerLb.textAlignment = NSTextAlignmentLeft;
    _challengerLb.textColor = [UIColor whiteColor];
    _challengerLb.glowSize = 20;
    _challengerLb.innerGlowSize = 4;
    _challengerLb.textColor = UIColor.whiteColor;
    _challengerLb.glowColor = UIColorFromRGB(0x5832b9);
    _challengerLb.innerGlowColor = UIColorFromRGB(0xc44c4e);
    _challengerLb.adjustsFontSizeToFitWidth = YES;
    _challengerLb.numberOfLines = 0;
    [self.mainView addSubview:_challengerLb];
    
    _statusIconView = [[UIImageView alloc] initWithFrame:CGRectMake((w-iconw)/2, yy, iconw, iconw)];
    _statusIconView.image = [UIImage imageNamed:@"challenge_success"];
    [self.mainView addSubview:_statusIconView];
    
    // 关闭按钮
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake((UIScreenWidth-20)/2, y+h + 30, 20, 20)];
    [closeBt setImage:[UIImage imageNamed:@"lz_close_bt"] forState:UIControlStateNormal];
    closeBt.tag = 0;
    [closeBt addTarget:self action:@selector(clickCloseBt) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBt];
    
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    w = 180;
    h = bg.size.height/bg.size.width * w;
    x = (self.mainView.frame.size.width - w) / 2;
    y = self.mainView.frame.size.height - h - padding;
    
    UIButton *bt = [UIButton createDefaultButton:@"返回社区" frame:CGRectMake(x, y, w, h)];
    [bt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:bt];
    _sureBt = bt;
  
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
    
    if (button.tag==0) {
        // 返回社区
        [self returnCommunity];
    }
    if (button.tag==1) {
        // 领取奖励
        NSDictionary *challenge_golds = [[YunConfig getConfig].challenge_golds mj_JSONObject];
        int amount = 0;
        float lastSec = 0;
        for (NSString *key in challenge_golds.allKeys) {
            int value = [challenge_golds[key] intValue];
            int sec = [key floatValue];
            if (_second>=sec && sec>lastSec) {
                amount = value;
                lastSec = sec;
            }
        }
        [[YunGetGoldView sharedSingleton] show:amount intro:@"挑战成功奖励" type:8 x:UIScreenWidth-15-20];
        [YunGetGoldView sharedSingleton].hideBlock = ^{
            [__weakSelf returnCommunity];
        };
    }
    if (button.tag==2) {
        // 重新挑战
        
    }

   
    if (self.hideBlock) {
        self.hideBlock();
    }
    
}

-(void)clickCloseBt{
    [self hide];
    [self returnCommunity];
    if (self.hideBlock) {
        self.hideBlock();
    }
}

-(void)returnCommunity{
    [(UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController popViewControllerAnimated:YES];
}

@end
