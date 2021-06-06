//
//  YunLittleRedEnvelopeView.m
//  yun_popstar
//
//  Created by dangfm on 2020/8/22.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunLittleRedEnvelopeView.h"

@implementation YunLittleRedEnvelopeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)initViews{
    UIImage *icon = [UIImage imageNamed:@"little_redbox_icon"];
    [self setImage:icon forState:UIControlStateNormal];
    
    [self startAnimaition];
}

-(void)startAnimaition{
    //创建一个关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置关键帧
    keyAnimation.values = @[@(-M_PI_4 * 0.8 * 1), @(M_PI_4 * 0.8 * 1), @(-M_PI_4 * 0.3 * 1)];
    //设置重复
    keyAnimation.repeatCount = NSNotFound;
    keyAnimation.duration=1.5;      //执行时间
    keyAnimation.autoreverses=YES;    //完成动画后会回到执行动画之前的状态
    //把核心动画添加到layer上
    [self.layer addAnimation:keyAnimation forKey:@"red_envelope_keyAnimation"];
//    int t = 1 +  (arc4random() % 10);
//    WEAKSELF
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [__weakSelf startAnimaition];
//    });
    
}
@end
