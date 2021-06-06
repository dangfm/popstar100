//
//  YunGetGoldView.m
//  yun_popstar
//
//  Created by dangfm on 2020/8/22.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunGetGoldView.h"

#define degreesToRadians(degrees) ((degrees * (float)M_PI) / 180.0f)  //这个公式是计算弧度的

@implementation YunGetGoldView

+ (instancetype)sharedSingleton {
    static YunGetGoldView *_sharedSingleton = nil;
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

-(void)show:(int)num intro:(NSString*)intro type:(int)type{
    // 奖励的金币数量
    _type = type;
    _intro = intro;
    _num = num;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    self.alpha = 1;
    self.moneyBox.transform = CGAffineTransformMakeScale(1, 1);
    self.moneyBox.alpha = 1;
    [self.say coindrop];
    [self startButtonAnimation];
    [self createMoreGoldIcon:15 x:0];
    [self lightAnimation];
}
-(void)show:(int)num intro:(NSString*)intro type:(int)type x:(float)x{
    // 奖励的金币数量
    _type = type;
    _intro = intro;
    _num = num;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    self.alpha = 1;
    self.moneyBox.transform = CGAffineTransformMakeScale(1, 1);
    self.moneyBox.alpha = 1;
    [self.say coindrop];
    [self startButtonAnimation];
    [self createMoreGoldIcon:15 x:x];
    [self lightAnimation];
}
-(void)initViews{
    self.hidden = YES;
    _goldViews = [NSMutableArray new];
    
    [self initSay];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [[AppDelegate sharedSingleton].window addSubview:self];
    
    float w = 180;
    float h = w;
    float x = 30;

    UIImage *mbg = [UIImage imageNamed:@"money_box_icon"];
    h = mbg.size.height/mbg.size.width * w;
    x = (UIScreenWidth - w)/2;
    float y = (UIScreenHeight-h)/2;
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.5;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//    [self.maskView addGestureRecognizer:tap];
//    [self.maskView setUserInteractionEnabled:YES];
    [self addSubview:self.maskView];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    self.moneyBox = [[UIImageView alloc] initWithFrame:self.mainView.bounds];
    self.moneyBox.image = mbg;
    [self.mainView addSubview:self.moneyBox];
    [self addSubview:self.mainView];
    
    self.introLb = [[YunLabel alloc] initWithFrame:CGRectMake(0, UIScreenHeight - 200, UIScreenWidth, 50) borderWidth:6 borderColor:[UIColor blackColor]];
    self.introLb.font = kFontBold(25);
    self.introLb.textColor = [UIColor whiteColor];
    self.introLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.introLb];
    
    //self.transform = CGAffineTransformScale(self.transform, 0, 0);
}

-(void)createMoreGoldIcon:(int)num x:(float)flyx{
    // 围着钱袋子周边生成N个金币，金币在旋转
    float x = 0;
    float y = 0;
    float w = 40;
    float h = 40;
    CGRect frame = self.bounds;
    // 圆心
    CGPoint center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
    // 圆半径
    float radius1 = frame.size.width/2-w/2-60;
    float radius2 = frame.size.width/2-w/2;

    if (_goldViews) {
        for (UIImageView *v in _goldViews) {
            [v removeFromSuperview];
        }
    }
    
    [_goldViews removeAllObjects];
    
    self.introLb.text = [NSString stringWithFormat:@"金币 +%d",_num];
    [self.introLb sizeToFit];
    self.introLb.frame = CGRectMake((UIScreenWidth-self.introLb.frame.size.width - 30)/2, self.introLb.frame.origin.y, self.introLb.frame.size.width+30, self.introLb.frame.size.height+20);
    self.introLb.layer.cornerRadius = self.introLb.frame.size.height/2;
    self.introLb.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.introLb.layer.masksToBounds = YES;
    self.introLb.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    self.introLb.layer.borderWidth = 2;
    
    for (int i=0; i<num; i++) {
        UIImageView *v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gold_3d_icon"]];
        v.frame = CGRectMake(x, y, 0, 0);
        [_goldViews addObject:v];
        v.center = center;
        [self addSubview:v];
    }
    
    [self bringSubviewToFront:self.introLb];
    
    int cout = (int)_goldViews.count;
    float t = 0.1;
    __block float tt = 1.0;
    WEAKSELF
    for (int i=0;i<cout;i++) {

        UIImageView *iv = _goldViews[i];
        float angle = 2 * M_PI * i / cout;
        iv.frame = CGRectMake(x, y, 0, 0);
        iv.center = center;
        CGPoint p = CGPointMake(center.x + (radius1)*cos(angle),center.y + (radius1)*sin(angle));
        if (i%2==0) {
            p = CGPointMake(center.x + (radius2)*cos(angle),center.y + (radius2)*sin(angle));
        }
        [UIView animateWithDuration:t animations:^{
            iv.frame = CGRectMake(x, y, w, h);
            iv.center = p;
        } completion:^(BOOL finished) {
            [__weakSelf transcycle:iv];
            // 3秒后像屋顶飞去
            //tt += 0.05 + t;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(tt * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [iv.layer removeAllAnimations];
                CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
                anima.fromValue = [NSValue valueWithCGPoint:iv.frame.origin];
                float cx = (UIScreenWidth-20 - 100) / 2-11;
                float cy = 58;
                if(iPhone4 || iPhone5 || iPhone6 || iPhone6Plus){
                    cy -= 22;
                }
                if (flyx>0) {
                    cx = flyx;
                }
                anima.toValue = [NSValue valueWithCGPoint:CGPointMake(cx, cy)];
                
                //放大效果，并回到原位
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                //速度控制函数，控制动画运行的节奏
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                animation.fromValue= [NSNumber numberWithFloat:1];  //初始伸缩倍数
                animation.toValue= [NSNumber numberWithFloat:0.7];    //结束伸缩倍数
                
                CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
                animationGroup.duration = .3f;
                animationGroup.autoreverses = NO;   //是否重播，原动画的倒播
                animationGroup.repeatCount = 0;//HUGE_VALF;     //HUGE_VALF,源自math.h
                animationGroup.fillMode = kCAFillModeForwards;
                animationGroup.removedOnCompletion = NO;
                [animationGroup setAnimations:[NSArray arrayWithObjects:anima,animation, nil]];
                
                [iv.layer addAnimation:animationGroup forKey:@"positionAnimation"];
                [__weakSelf.say reward];
                
                if (i==cout-1) {
                    // 给用户增加金币
                    int gold = [YunConfig getUserGold];
                    gold += __weakSelf.num;
                    [YunConfig setUserGold:gold];
                    [__weakSelf sendApiUserGold];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GetCoin object:nil];
                    // 最后一个
                    [__weakSelf hide];
                }
            });
        }];
        t += 0.05;
    }
    
    
}


-(void)startButtonAnimation{
    [self.moneyBox.layer removeAllAnimations];
    //创建一个关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置关键帧
    keyAnimation.values = @[@(-M_PI_4 * 0.3 * 1), @(M_PI_4 * 0.3 * 1), @(-M_PI_4 * 0.3 * 1)];
    //设置重复
    keyAnimation.duration=0.2;      //执行时间
    keyAnimation.repeatCount = NSNotFound;
    keyAnimation.autoreverses= YES;    //完成动画后会回到执行动画之前的状态
    [self.moneyBox.layer addAnimation:keyAnimation  forKey:@"goldView_rotationAnimation"];
}
// 硬币旋转
-(void)transcycle:(UIImageView*)v{
    [v.layer removeAllAnimations];
//    //创建一个关键帧动画
//    CABasicAnimation *keyAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
//    //设置关键帧
//    keyAnimation.toValue = [NSNumber numberWithFloat:(M_PI*4.0)];
//    //设置重复
//    keyAnimation.duration=1.5;      //执行时间
//    keyAnimation.repeatCount = NSNotFound;
//    keyAnimation.autoreverses= YES;    //完成动画后会回到执行动画之前的状态
    
    //创建一个关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置关键帧
    keyAnimation.values = @[@(-M_PI_4 * 0.6 * 1), @(M_PI_4 * 0.6 * 1), @(-M_PI_4 * 0.6 * 1)];
    //设置重复
    keyAnimation.duration=0.2;      //执行时间
//    keyAnimation.repeatCount = NSNotFound;
//    keyAnimation.autoreverses= YES;    //完成动画后会回到执行动画之前的状态
    
    //放大效果，并回到原位
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue= [NSNumber numberWithFloat:1];  //初始伸缩倍数
    animation.toValue= [NSNumber numberWithFloat:0.3];    //结束伸缩倍数
    animation.duration=0.3;      //执行时间
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = .3f;
    animationGroup.autoreverses = YES;   //是否重播，原动画的倒播
    animationGroup.repeatCount = NSNotFound;//HUGE_VALF;     //HUGE_VALF,源自math.h
    [animationGroup setAnimations:[NSArray arrayWithObjects:keyAnimation,animation, nil]];
    
    [v.layer addAnimation:animationGroup  forKey:@"icon_rotationAnimation"];
}
// 背景发光
-(void)lightAnimation{
    [_light_bg removeFromSuperview];
    [_light_bg_2 removeFromSuperview];
    // 发光
    float w = UIScreenWidth * 1.0;
    UIImageView *light = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenWidth-w)/2, (UIScreenHeight-w)/2, w, w)];
    light.image = [UIImage imageNamed:@"light_bg"];
    light.alpha = 1;
    [self addSubview:light];
    _light_bg = light;
    
    UIImageView *light2 = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenWidth-w)/2, (UIScreenHeight-w)/2, w, w)];
    light2.image = [UIImage imageNamed:@"light_bg"];
    light2.alpha = 1;
    [self addSubview:light2];
    _light_bg_2 = light2;
    
    [self bringSubviewToFront:self.mainView];
    if (_goldViews) {
        for (UIImageView *v in _goldViews) {
            [self bringSubviewToFront:v];
        }
    }
    
    [self.say lighting];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 2.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = NSNotFound;
    
    [_light_bg.layer addAnimation:animation forKey:nil];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath: @"transform" ];
    animation2.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation2.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation( 1.0,0.0, 0.0,M_PI) ];
    animation2.duration = 2.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation2.cumulative = YES;
    animation2.repeatCount = NSNotFound;
  
    [_light_bg_2.layer addAnimation:animation2 forKey:nil];
}

-(void)hide{
    WEAKSELF
    [UIView animateWithDuration:0.3 animations:^{
        __weakSelf.alpha = 0;
        __weakSelf.moneyBox.transform = CGAffineTransformMakeScale(2.5,2.5);
        __weakSelf.moneyBox.alpha = 0;
    } completion:^(BOOL finished) {
        __weakSelf.hidden = YES;
        if(__weakSelf.hideBlock){
            __weakSelf.hideBlock();
            __weakSelf.hideBlock = nil;
        }
    }];
    
}

// 保存金币流水
-(void)sendApiUserGold{
    if (!_intro) {
        _intro = @"";
    }
    [http sendApiUserGold:_intro type:_type gold:self.num];
}
@end
