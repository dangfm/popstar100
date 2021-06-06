//
//  YunPopstarButton.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/6.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPopstarButton.h"

@interface YunPopstarButton()

@property (nonatomic, strong) CAEmitterLayer * explosionLayer;

@end

@implementation YunPopstarButton

-(void)dealloc{
    NSLog(@"YunPopstarButton dealloc");
}

-(instancetype)initWithFrame:(CGRect)frame color:(PopstarColor)color{
    if([super initWithFrame:frame]){
        self.color = color;
        [self initView];
    }
    return self;
}

- (void)style{
//    self.layer.shadowColor = UIColorFromRGB(0x5b331b).CGColor;//阴影颜色
//    self.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
//    self.layer.shadowOpacity = 0.3;//不透明度
//    self.layer.shadowRadius = 3.0;//半径
    
    [self borderDefault];
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;//阴影的位置
//    self.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
//    self.layer.shadowOffset = CGSizeMake(1, 1);//阴影的大小，x往右和y往下是正
//    self.layer.shadowRadius = 1;     //阴影的扩散范围，相当于blur radius，也是shadow的渐变距离，从外围开始，往里渐变shadowRadius距离
//    self.layer.shadowOpacity = 1;    //阴影的不透明度
    self.layer.masksToBounds = NO;   //很重要的属性，可以用此属性来防止子元素大小溢出父元素，如若防止溢出，请设为 true
}

-(void)initView{
    [self initSay];
    self.firstTag = -1;
    self.exclusiveTouch = YES;
    [self style];
    [self setupExplosion];
    _bg = [[UIImageView alloc] initWithFrame:CGRectMake(0.5, 0.5, self.frame.size.width-1, self.frame.size.height-1)];
    [self addSubview:_bg];
    if (self.color==red_popstar) {
        //[self setBackgroundImage:[UIImage imageNamed:@"star_red"] forState:UIControlStateNormal];
        _bg.image = [UIImage imageNamed:@"star_red"];
    }
    if (self.color==green_popstar) {
        //[self setBackgroundImage:[UIImage imageNamed:@"star_green"] forState:UIControlStateNormal];
        _bg.image = [UIImage imageNamed:@"star_green"];
    }
    if (self.color==blue_popstar) {
        //[self setBackgroundImage:[UIImage imageNamed:@"star_blue"] forState:UIControlStateNormal];
        _bg.image = [UIImage imageNamed:@"star_blue"];
    }
    if (self.color==yellow_popstar) {
        //[self setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
        _bg.image = [UIImage imageNamed:@"star_yellow"];
    }
    if (self.color==purple_popstar) {
        //[self setBackgroundImage:[UIImage imageNamed:@"star_purple"] forState:UIControlStateNormal];
        _bg.image = [UIImage imageNamed:@"star_purple"];
    }
}

-(void)setColor:(PopstarColor)color{
    _color = color;
    _bg.image = nil;
    if (_color==red_popstar) {
        //[self setBackgroundImage:[UIImage imageNamed:@"star_red"] forState:UIControlStateNormal];
        _bg.image = [UIImage imageNamed:@"star_red"];
    }
    if (_color==green_popstar) {
        //[self setBackgroundImage:[UIImage imageNamed:@"star_green"] forState:UIControlStateNormal];
        _bg.image = [UIImage imageNamed:@"star_green"];
    }
    if (_color==blue_popstar) {
        //[self setBackgroundImage:[UIImage imageNamed:@"star_blue"] forState:UIControlStateNormal];
        _bg.image = [UIImage imageNamed:@"star_blue"];
    }
    if (_color==yellow_popstar) {
        //[self setBackgroundImage:[UIImage imageNamed:@"star_yellow"] forState:UIControlStateNormal];
        _bg.image = [UIImage imageNamed:@"star_yellow"];
    }
    if (_color==purple_popstar) {
        //[self setBackgroundImage:[UIImage imageNamed:@"star_purple"] forState:UIControlStateNormal];
        _bg.image = [UIImage imageNamed:@"star_purple"];
    }
}


- (void)setupExplosion{
    
     // 发射
    CAEmitterCell * explosionCell = [CAEmitterCell emitterCell];
    explosionCell.name = @"explosionCell";

    UIImage *img = [UIImage imageNamed:@"lz_star"];// [UIImage imageNamed:@"star_white_stroke"]
    explosionCell.contents = (id)[img CGImage];
    if(self.color==red_popstar)
        explosionCell.color = UIColorFromRGB(0xe0486e).CGColor;
    if(self.color==green_popstar)
        explosionCell.color = UIColorFromRGB(0x5ab625).CGColor;
    if(self.color==blue_popstar)
        explosionCell.color = UIColorFromRGB(0x2fb9fc).CGColor;
    if(self.color==purple_popstar)
        explosionCell.color = UIColorFromRGB(0xbf47fb).CGColor;
    if(self.color==yellow_popstar)
        explosionCell.color = UIColorFromRGB(0xfdb72f).CGColor;
    // 每秒产生的数量
    //explosionCell.birthRate = 3.f;
    explosionCell.lifetime = .8f;
    // 速度
    explosionCell.velocity = -500.f;
    //初速度范围
    explosionCell.velocityRange = -1000.f;
    // Y方向加速
    explosionCell.yAcceleration = 1300.f;

    explosionCell.scale = 0.1;
    explosionCell.scaleRange = 0.5;
    explosionCell.scaleSpeed = 0.01;
//
    explosionCell.redRange = 1.f;
    explosionCell.greenRange = 1.f;
    explosionCell.blueSpeed = 1.f;
    explosionCell.alphaRange = 0.1;
    explosionCell.alphaSpeed = -0.1f;
    // 掉落的角度范围
    //explosionCell.emissionLongitude = M_PI_2; // 向左
    explosionCell.emissionRange = M_PI * 2; // 围绕X轴向左90度

    // 旋转的速度
    explosionCell.spin = M_PI_2;
    explosionCell.spinRange = M_PI_2 / 2;

    // 火花
    CAEmitterCell * sparkCell = [CAEmitterCell emitterCell];
    sparkCell.name = @"sparkCell";

    sparkCell.birthRate = 400.f;
    sparkCell.lifetime = 1.8f;
    sparkCell.velocity = 100.f;
    sparkCell.yAcceleration = 1375.f;  // 模拟重力影响
    sparkCell.emissionRange = M_PI * 2;  // 360度

    sparkCell.scale = 0.5f;
    sparkCell.contents = (id)[img CGImage];
    sparkCell.redSpeed = 0.4;
    sparkCell.greenSpeed = -0.1;
    sparkCell.blueSpeed = -0.1;
    sparkCell.alphaSpeed = -0.25;

    sparkCell.spin = M_PI * 2; // 自转
    if(self.color==red_popstar)
        sparkCell.color = UIColorFromRGB(0xe0486e).CGColor;
    if(self.color==green_popstar)
        sparkCell.color = UIColorFromRGB(0x5ab625).CGColor;
    if(self.color==blue_popstar)
        sparkCell.color = UIColorFromRGB(0x2fb9fc).CGColor;
    if(self.color==purple_popstar)
        sparkCell.color = UIColorFromRGB(0xbf47fb).CGColor;
    if(self.color==yellow_popstar)
        sparkCell.color = UIColorFromRGB(0xfdb72f).CGColor;


    // 2.发射源
    CAEmitterLayer * explosionLayer = [CAEmitterLayer layer];

    [self.layer addSublayer:explosionLayer];
    self.explosionLayer = explosionLayer;
    //开启三维效果
    //explosionLayer.preservesDepth = true;
    //发射源的尺寸大小
    self.explosionLayer.emitterSize = CGSizeMake(0 , 0);
    //发射源的形状
    explosionLayer.emitterShape = kCAEmitterLayerCircle;
    //发射模式
    explosionLayer.emitterMode = kCAEmitterLayerOutline;
    //渲染模式
    explosionLayer.renderMode = kCAEmitterLayerOldestFirst;
    explosionLayer.repeatCount = 1;
    explosionLayer.emitterCells = @[explosionCell];
    //explosionCell.emitterCells = @[sparkCell];

    
    
}


-(void)layoutSubviews{
    // 发射源位置
    self.explosionLayer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);

    [super layoutSubviews];
}

/**
 * 选中状态 实现缩放
 */
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [self borderHighlight];
    
}

-(void)initSay{
    self.say = [YunPopstarSay new];
}


-(void)hide{
  
    //[self.say say:@"lz_star_clear.wav"];
    [self.say popstar_disappear];
    [self borderHighlight];
    [self startAnimation];
    //[self hideSelf];
    [self performSelector:@selector(hideSelf) withObject:nil afterDelay:0.1];
}

-(void)hideNoAnimation{
    
    [self borderHighlight];
    //[self hideSelf];
    [self performSelector:@selector(hideSelf) withObject:nil afterDelay:0.1];
    // 延迟停止动画
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.3];
}

-(void)hideSelf{
    _bg.layer.borderWidth = 0;
    _bg.layer.borderColor = [UIColor clearColor].CGColor;
    _bg.image = nil;
    //[self setBackgroundImage:nil forState:UIControlStateNormal];
    self.backgroundColor = [UIColor clearColor];
}

-(void)borderDefault{
    _bg.layer.borderWidth = 0;
    _bg.layer.borderColor = [UIColor clearColor].CGColor;;//[UIColor colorWithPatternImage:[UIImage imageNamed:@"background-1"]].CGColor;
    _bg.layer.cornerRadius = 7;
}
-(void)borderHighlight{
    _bg.layer.borderWidth = 2;
    _bg.layer.borderColor = [UIColor whiteColor].CGColor;
    _bg.layer.cornerRadius = 7;
}

// 没有高亮状态
- (void)setHighlighted:(BOOL)highlighted{[super setHighlighted:highlighted];}

/**
 * 开始动画
 */
- (void)startAnimation{
    
    // 用KVC设置颗粒个数
    [self.explosionLayer setValue:@500 forKeyPath:@"emitterCells.explosionCell.birthRate"];
    
    
    // 开始动画
    self.explosionLayer.beginTime = CACurrentMediaTime();
    
    // 延迟停止动画
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:.3];
    //[self borderDefault];
}

/**
 * 动画结束
 */
- (void)stopAnimation{
    // 用KVC设置颗粒个数
    [self.explosionLayer setValue:@0 forKeyPath:@"emitterCells.explosionCell.birthRate"];
    //[self.explosionLayer removeAllAnimations];
    [self clearSelf];
    //[self performSelector:@selector(clearSelf) withObject:nil afterDelay:0.15];

}

-(void)clearSelf{

    self.isClear = YES;
    if (self.clearPopstarBlock) {
        self.clearPopstarBlock(self,self.isClear);
    }
    self.enabled = false;
    //[self removeFromSuperview];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
}

- (void)drawRect:(CGRect)rect {}

-(void)moveDown:(int)y block:(MoveDownComplateBlock)complate{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width,self.frame.size.height);
        //CGPoint tempPoint=buttonBottom.center;
        //tempPoint.y += 10;
        //buttonBottom.center=tempPoint;
    } completion:^(BOOL finished) {
        complate(self,finished);
    }];
    
}

-(void)moveLeft:(int)x block:(MoveDownComplateBlock)complate{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
        //CGPoint tempPoint=buttonBottom.center;
        //tempPoint.y += 10;
        //buttonBottom.center=tempPoint;
    } completion:^(BOOL finished) {
        complate(self,finished);
    }];
    
}
@end
