//
//  YunPopstarMagicView.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/15.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPopstarMagicView.h"

@implementation YunPopstarMagicView

// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunPopstarMagicView *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _sharedSingleton = [[self alloc] init];
        [_sharedSingleton initViews];
    });
    return _sharedSingleton;
}



-(void)show{
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.layer addAnimation:anima2 forKey:nil];
}
-(void)initViews{
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [[AppDelegate sharedSingleton].window addSubview:self];
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.8;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBody)];
    [self.maskView addGestureRecognizer:tap];
    [self.maskView setUserInteractionEnabled:YES];
    [self addSubview:self.maskView];
    
    self.mainView = [[UIView alloc] init];
    [self addSubview:self.mainView];
    
    float x = 0;
    float y = 0;
    float w = UIScreenWidth/10 * 1.5;
    float h = w;
    for (int i=0; i<5; i++) {
        YunPopstarButton *bt = [[YunPopstarButton alloc] initWithFrame:CGRectMake(x, y, w, h) color:i];
        [bt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:bt];
        x += w;
    }
    w = 5*w;
    x = (UIScreenWidth - w) / 2;
    y = UIScreenHeight-UIScreenWidth - h - 100;
    self.mainView.frame = CGRectMake(x, y, w, h);
    
    //self.transform = CGAffineTransformScale(self.transform, 0, 0);
}
-(void)hide{
    self.hidden = YES;
}
-(void)tapBody{
    if (self.magicBlock) {
        self.magicBlock(0,NO);
    }
    [self hide];
}
-(void)clickButton:(YunPopstarButton*)button{
    if (self.magicBlock) {
        self.magicBlock(button.color,YES);
    }
    [self hide];
}

@end
