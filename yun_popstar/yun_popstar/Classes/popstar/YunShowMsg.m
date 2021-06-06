//
//  YunShowMsg.m
//  yun_popstar
//
//  Created by dangfm on 2020/8/27.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunShowMsg.h"

@implementation YunShowMsg

// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunShowMsg *_sharedSingleton = nil;
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

-(void)show:(NSString*)msg{
    self.alpha = 1;
    self.titleLb.text = msg;
   
    self.contentLb.text = @"";
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    
    [self updateMainView];
}

-(void)show:(NSString*)title content:(NSString*)content sure:(void(^)(void))block{
    _sureBlock = block;
    self.alpha = 1;
    self.titleLb.text = title;
    self.contentLb.text = content;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    
    [self updateMainView];
}
-(void)initViews{
    self.alpha = 1;
    [self initSay];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [[AppDelegate sharedSingleton].window addSubview:self];
    
    float w = UIScreenWidth-60;
    float h = 100 + 50 + 20;
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
    
    FBGlowLabel *titleLb = [[FBGlowLabel alloc] initWithFrame:CGRectMake(15, 0, w-30, 80)];
    titleLb.text = @"";
    titleLb.font = kFontBold(30);
    titleLb.adjustsFontSizeToFitWidth = YES;
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor whiteColor];
    titleLb.glowSize = 20;
    titleLb.innerGlowSize = 4;
    titleLb.textColor = UIColor.whiteColor;
    titleLb.glowColor = UIColorFromRGB(0x5832b9);
    titleLb.innerGlowColor = UIColorFromRGB(0xc44c4e);
    _titleLb = titleLb;
    [self.mainView addSubview:titleLb];
    
    _contentLb = [[YunLabel alloc] initWithFrame:CGRectMake(15, 80, w-15, 100) borderWidth:1 borderColor:UIColorFromRGB(0xc44c4e)];
    _contentLb.numberOfLines = 0;
    _contentLb.textColor = [UIColor whiteColor];
    _contentLb.textAlignment = NSTextAlignmentCenter;
    //_contentLb.backgroundColor = FMBlackColor;
    [self.mainView addSubview:_contentLb];

    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    w = (w - 30 - 20) / 2;
    h = bg.size.height/bg.size.width * w;
    x = (self.mainView.frame.size.width - 2*w - 20) / 2;
    y = self.mainView.frame.size.height - h- padding;
    
    UIButton *bt = [UIButton createDefaultButton:@"关闭" frame:CGRectMake(x, y, w, h)];
    [bt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    bt.titleLabel.font = kFont(20);
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bt.alpha = 1;
    bt.tag = 0;
    [self.mainView addSubview:bt];
    _closeBt = bt;
    
    UIButton *surebt = [UIButton createDefaultButton:@"确定" frame:CGRectMake(x+w+20, y, w, h)];
    [surebt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    surebt.titleLabel.font = kFont(20);
    [surebt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    surebt.alpha = 1;
    surebt.tag = 1;
    [self.mainView addSubview:surebt];
    _sureBt = surebt;
    
    //self.transform = CGAffineTransformScale(self.transform, 0, 0);
}

-(void)updateMainView{
    
    [_contentLb sizeToFit];
    _contentLb.frame = CGRectMake(_contentLb.frame.origin.x, _contentLb.frame.origin.y, self.mainView.frame.size.width-30, _contentLb.frame.size.height);
    _closeBt.frame = CGRectMake(_closeBt.frame.origin.x, _contentLb.frame.size.height+_contentLb.frame.origin.y+30, _closeBt.frame.size.width, _closeBt.frame.size.height);
    _sureBt.frame = CGRectMake(_sureBt.frame.origin.x, _closeBt.frame.origin.y, _sureBt.frame.size.width, _sureBt.frame.size.height);
    
    UIView *lastView = self.mainView.subviews.lastObject;
    CGRect frame = self.mainView.frame;
    frame.size.height = lastView.frame.size.height + lastView.frame.origin.y + 15;
    frame.origin.y = (UIScreenHeight - frame.size.height) / 2;
    self.mainView.frame = frame;
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
        if (self.closeBlock) {
            self.closeBlock();
            self.closeBlock = ^{};
        }
    }
    if (button.tag==1) {
        if (self.sureBlock) {
            self.sureBlock();
            self.sureBlock = ^{};
        }
    }
    
    
}



@end
