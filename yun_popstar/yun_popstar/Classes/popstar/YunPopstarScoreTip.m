//
//  YunPopstarScoreTip.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/10.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPopstarScoreTip.h"

@interface YunPopstarScoreTip()<CAAnimationDelegate>

@end

@implementation YunPopstarScoreTip

-(instancetype)initWithFrame:(CGRect)frame color:(int)color{
    if([super initWithFrame:frame]){
        [self initView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame color:(int)color scroe:(int)scroe{
    if([super initWithFrame:frame]){
        self.scroe = scroe;
        [self initView];
    }
    return self;
}

-(void)initSay{
    self.say = [YunPopstarSay new];
}

-(void)initView{
    [self initSay];
    int p = [YunConfig getUserPassNumber];
    float less = 0;
    NSDictionary *pass_star_coin_less = [[YunConfig getConfig].pass_star_coin_less mj_JSONObject];
    if (pass_star_coin_less) {
        int maxlevels = 0;
        for (NSString *key in pass_star_coin_less.allKeys) {
            int levels = [key intValue];
            if (levels>maxlevels && [YunConfig getUserPassNumber]>=levels) {
                // 每个等级对应的星星得分率
                less = [pass_star_coin_less[key] floatValue];
                maxlevels = levels;
            }
        }
    }
    int start = (kPass_starCoin_start + p)*less;
    int end = (kPass_starCoin_end + p)*less;
    if(self.scroe<=0) self.scroe = [self getRandomNumber:start to:end];
    float w = UIScreenWidth/10-10;
    UIButton *star = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, w)];
    [star setBackgroundImage:[UIImage imageNamed:@"lz_star_score2"] forState:UIControlStateNormal];
    [star setTitle:[NSString stringWithFormat:@"+%d",self.scroe] forState:UIControlStateNormal];
    [star setTitleColor:UIColorFromRGB(0x532202) forState:UIControlStateNormal];
    star.titleLabel.font = [UIFont systemFontOfSize:14];
    star.titleLabel.adjustsFontSizeToFitWidth = YES;
    //star.alpha = 0.8;
    [self addSubview:star];
    self.starBt = star;
    CGRect frame = self.frame;
    frame.origin = CGPointMake(frame.origin.x+5, frame.origin.y+5);
    frame.size = star.frame.size;
    self.frame = frame;
    self.backgroundColor = [UIColor clearColor];
}
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
-(void)hide{
    if(self.superview){
        float x = self.superview.frame.origin.x;
        float y = self.superview.frame.origin.y;
        x = x + self.frame.origin.x;
        y = y + self.frame.origin.y;
        
        float yy = 22 + 50;
        if (iPhoneX || iPhoneXsMax) {
            yy = 44+50;
        }
        yy += 25;
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        
        CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"position"];
        anima1.fromValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        anima1.toValue = [NSValue valueWithCGPoint:CGPointMake(UIScreenWidth/2, yy)];
        //anima1.fillMode = kCAFillModeForwards;
        
        //anima1.duration = 1.3;
        
        CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        anima2.fromValue = [NSNumber numberWithFloat:1.0];
        anima2.toValue = [NSNumber numberWithFloat:0.1];
        
        //anima2.duration = 1.0;
        //组动画
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2, nil];
        groupAnimation.removedOnCompletion = NO;
        groupAnimation.duration = 0.5;
        groupAnimation.fillMode = kCAFillModeForwards;
        groupAnimation.delegate = self;
        [self.layer addAnimation:groupAnimation forKey:nil];
        
        
    }
    
}

-(void)hideself{
    float x = self.superview.frame.origin.x;
    float y = self.superview.frame.origin.y;
    x += self.frame.size.width/2;
    y += self.frame.size.height/2;
    float yy = 22 + 50;
    if (iPhoneX || iPhoneXsMax) {
        yy = 44+50;
    }
    yy += 25;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"position"];
    anima1.fromValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
    anima1.toValue = [NSValue valueWithCGPoint:CGPointMake(UIScreenWidth/2, yy)];
    //anima1.fillMode = kCAFillModeForwards;
    
    //anima1.duration = 1.3;
    
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:1.0];
    anima2.toValue = [NSNumber numberWithFloat:0.1];
    
    //anima2.duration = 1.0;
    //组动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2, nil];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.duration = 0.5;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.delegate = self;
    [self.layer addAnimation:groupAnimation forKey:nil];
}


/**
 * 开始动画
 */
- (void)startAnimation{
    
    // 延迟停止动画
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:1.0];
    //[self borderDefault];
    
}

/**
 * 动画结束
 */
- (void)stopAnimation{
    
    [self removeFromSuperview];

}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_AddScroe object:@(self.scroe)];

    [self.starBt setTitle:@"" forState:UIControlStateNormal];
    
    CABasicAnimation *anima1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima1.fromValue = [NSNumber numberWithInt:1];
    anima1.toValue = [NSNumber numberWithInt:0];
    //anima1.fillMode = kCAFillModeForwards;
    
    //anima1.duration = 1.3;
    
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    
    //anima2.duration = 1.0;
    //组动画
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2, nil];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.duration = 0.1;
    groupAnimation.fillMode = kCAFillModeForwards;
    //groupAnimation.delegate = self;
    [self.layer addAnimation:groupAnimation forKey:nil];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
    
    //[self makeFireworksDisplay];
    //[self startAnimation];
    //[self removeFromSuperview];
    
    //[self.say reward];
    
}
@end
