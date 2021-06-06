//
//  YunSetingView.m
//  yun_popstar
//
//  Created by dangfm on 2020/8/28.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunSetingView.h"

@implementation YunSetingView

// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunSetingView *_sharedSingleton = nil;
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
    self.alpha = 1;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
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
    
    // 背景音乐和游戏音效开关
    [self initSoundView];
    
    
    NSArray *titles = @[@"马上评论",@"隐私条款",@"关闭"];
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
    [self.say say:@"lz_touch_on.wav"];
    WEAKSELF
    
    [UIView animateWithDuration:0.8 animations:^{
        __weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        __weakSelf.hidden = YES;
    }];
    if (button.tag==1) {
        // 隐私条款
        [[YunWebView sharedSingleton]show:kAPI_ProcyTip];
//        YunWebViewController *web = [[YunWebViewController alloc] initWithUrl:kAPI_ProcyTip];
//        [(UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController pushViewController:web animated:YES];
    }
    if (button.tag==0) {
        // 马上评论
       NSString *itunesurl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review",kAppStore_Id];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success) {
            
        }];

    }
    if (button.tag==2) {
        // 关闭
        
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
