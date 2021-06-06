//
//  YunPopstarPlayView.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/16.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPopstarPlayView.h"

@implementation YunPopstarPlayView

// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunPopstarPlayView *_sharedSingleton = nil;
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
    _isChallenge = NO;
    _resetGameBt.hidden = NO;
    _continueBt.hidden = NO;
    self.alpha = 1;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    
    _redenvelopeBt.hidden = ![YunConfig getUserIsOpenRedEnvelope];
    
    YunLabel *l = [_resetGameBt viewWithTag:101];
    l.text = @"新 游 戏";
    
}
-(void)showChallenge{
    _isChallenge = YES;
    _resetGameBt.hidden = NO;
    _continueBt.hidden = NO;
    self.alpha = 1;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    
    _redenvelopeBt.hidden = ![YunConfig getUserIsOpenRedEnvelope];
    
    YunLabel *l = [_resetGameBt viewWithTag:101];
    l.text = @"挑 战 规 则";
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
    self.mainView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    self.mainView.layer.borderWidth = 3;
    self.mainView.layer.cornerRadius = corner;
    [self addSubview:self.mainView];
    
    // 关闭按钮
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake((UIScreenWidth-20)/2, y+h + 30, 20, 20)];
    [closeBt setImage:[UIImage imageNamed:@"lz_close_bt"] forState:UIControlStateNormal];
    closeBt.tag = 0;
    [closeBt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBt];
    
    // 背景音乐和游戏音效开关
    [self initSoundView];
    
    
    NSArray *titles = @[@"继 续",@"新 游 戏",@"退 出"];
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    w = 180;
    h = bg.size.height/bg.size.width * w;
    x = (self.mainView.frame.size.width - w) / 2;
    y = self.mainView.frame.size.height - titles.count*(h+padding) - padding;
    
    for (int i=0; i<titles.count; i++) {
        UIButton *bt = [UIButton createDefaultButton:titles[i] frame:CGRectMake(x, y, w, h)];
        [bt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        //[bt setBackgroundImage:bg forState:UIControlStateNormal];
        //[bt setTitle:titles[i] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i==0) {
            _continueBt = bt;
        }
        if (i==1) {
            _resetGameBt = bt;
        }
//        bt.layer.cornerRadius = h/2;
//        bt.layer.masksToBounds = YES;
//        bt.layer.borderWidth = 3;
        //bt.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
        bt.tag = i;
        bt.alpha = 1;
        [self.mainView addSubview:bt];
        y += h + padding;
        bt = nil;
        
    }
    
    //self.transform = CGAffineTransformScale(self.transform, 0, 0);
    
    // 红包屏蔽
    // 红包
    UIButton *redenvelope = [[UIButton alloc] init];
    UIImage *redimage = [UIImage imageNamed:@"lz_red_envelope"];
    float rw = 50;
    float rh = redimage.size.height/redimage.size.width * rw;
    redimage = [UIImage scaleToSize:redimage size:CGSizeMake(rw, rh)];
    [redenvelope setBackgroundImage:redimage forState:UIControlStateNormal];
    redenvelope.frame = CGRectMake(self.mainView.frame.size.width - rw - 15, 120, rw, rh);
    redenvelope.tag = 0;
    [redenvelope addTarget:self action:@selector(clickRedEnvelopeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:redenvelope];
    if ([YunConfig getUserShieldRedEnvelope]) {
        UIImage *icon = [UIImage imageNamed:@"shield_icon"];
        icon = [UIImage scaleToSize:icon size:CGSizeMake(25, 25)];
        [redenvelope setImage:icon forState:UIControlStateNormal];
        redenvelope.tag = 1;
    }
    _redenvelopeBt = redenvelope;
    
}

-(void)clickRedEnvelopeButton:(UIButton*)bt{
    [self.say touchButton];
    bt.userInteractionEnabled = NO;
    if (bt.tag==0) {
        // 变成屏蔽
        bt.tag = 1;
        UIImage *icon = [UIImage imageNamed:@"shield_icon"];
        icon = [UIImage scaleToSize:icon size:CGSizeMake(25, 25)];
        [bt setImage:icon forState:UIControlStateNormal];
        [YunConfig setUserShieldRedEnvelope:YES];
    }else{
        bt.tag = 0;
        [bt setImage:nil forState:UIControlStateNormal];
        [YunConfig setUserShieldRedEnvelope:NO];
        
    }
    bt.userInteractionEnabled = YES;
    // 红包关闭通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_RedEnvelope_Close object:nil];
}

-(void)initSoundView{
    NSArray *bgnames_open = @[@"lz_sound_open",@"lz_voice_open"];
    NSArray *bgnames_close = @[@"lz_sound_close",@"lz_voice_close"];
    
    float w = 60;
    float padding = self.mainView.frame.size.width/2-2*w;
    float h = w;
    float x = (self.mainView.frame.size.width - 2*w-padding) / 2;
    float y = 30;
    UIImage *bg = [UIImage gradientColorImageFromColors:@[
        UIColorFromRGB(0xfeee91),
        UIColorFromRGB(0xfec144)
    ] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(w, h)];
    
    for (int i=0; i<bgnames_open.count; i++) {
        UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [bt addTarget:self action:@selector(clickSoundButton:) forControlEvents:UIControlEventTouchUpInside];
        [bt setBackgroundImage:bg forState:UIControlStateNormal];
        UIImage *tg = [UIImage imageNamed:bgnames_open[i]];
        if (i==0 && ![YunConfig getGameSoundIsOpen]) {
            tg = [UIImage imageNamed:bgnames_close[i]];
            bt.selected = YES;
        }
        if (i==1 && ![YunConfig getGameVoiceIsOpen]) {
            tg = [UIImage imageNamed:bgnames_close[i]];
            bt.selected = YES;
        }
        tg = [UIImage scaleToSize:tg size:CGSizeMake(w/2, h/2)];
        [bt setImage:tg forState:UIControlStateNormal];
        //[bt setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 0, 0)];
        bt.layer.cornerRadius = h/2;
        bt.layer.masksToBounds = YES;
        bt.layer.borderWidth = 3;
        bt.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
        bt.tag = i;
        bt.alpha = 1;
        [self.mainView addSubview:bt];
        x += w + padding;
        tg = nil;
        bt = nil;
    }
    
    
    
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
    if (button.tag==1) {
        YunLabel *l = [button viewWithTag:101];
        NSString *title = l.text;
        if ([title isEqualToString:@"新 游 戏"]) {
            // 点击新游戏
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_NewGame object:nil];
            });
        }
        
        if ([title isEqualToString:@"挑 战 规 则"]) {
            [[YunWebView sharedSingleton] show:kAPI_ChallengeRule];
        }
        
    }
    if (button.tag==0) {
        // 继续
    }
    if (button.tag==2) {
        // 退出游戏
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GoToGameStartHome object:nil];
        });
    }
   
    if (self.magicBlock) {
        self.magicBlock(button,(int)button.tag);
    }
    
}

-(void)clickSoundButton:(UIButton*)button{
    [self.say say:@"lz_touch_on.wav"];
    NSArray *bgnames_open = @[@"lz_sound_open",@"lz_voice_open"];
    NSArray *bgnames_close = @[@"lz_sound_close",@"lz_voice_close"];
    UIImage *tg_open = [UIImage imageNamed:bgnames_open[button.tag]];
    tg_open = [UIImage scaleToSize:tg_open size:CGSizeMake(button.frame.size.width/2, button.frame.size.height/2)];
    UIImage *tg_close = [UIImage imageNamed:bgnames_close[button.tag]];
    tg_close = [UIImage scaleToSize:tg_close size:CGSizeMake(button.frame.size.width/2, button.frame.size.height/2)];
    
    if (button.selected==NO) {
       [button setImage:tg_close forState:UIControlStateNormal];
        button.selected = YES;
        if (button.tag==0) {
            [YunConfig setGameSoundIsOpen:NO];
            // 暂停背景音乐
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_SoundStop object:nil];
        }
        if (button.tag==1) {
            [YunConfig setGameVoiceIsOpen:NO];
        }
        
    }else{
        [button setImage:tg_open forState:UIControlStateNormal];
        button.selected = NO;
        if (button.tag==0) {
            [YunConfig setGameSoundIsOpen:YES];
            // 开始播放背景音乐
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_SoundStart object:nil];
        }
        if (button.tag==1) {
            [YunConfig setGameVoiceIsOpen:YES];
        }
    }
    
}



@end
