//
//  YunPopstarShowMsgView.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/16.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPopstarShowMsgView.h"

@implementation YunPopstarShowMsgView

// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunPopstarShowMsgView *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _sharedSingleton = [[self alloc] init];
        [_sharedSingleton initViews];
    });
    return _sharedSingleton;
}


-(void)showNice{
    [self showImg:@"ku_icon"];
    //[self showMsg:@"酷！"];
}
-(void)showCool{
    [self showImg:@"ku_icon"];
    //[self showMsg:@"酷！"];
}
-(void)showGood{
    //[self showMsg:@"非常棒！"];
    [self showImg:@"feichangbang_icon"];
}
-(void)showWellDone{
    //[self showMsg:@"精彩绝伦！"];
    [self showImg:@"jingcaijuelun_icon"];
}
-(void)showVeryGood{
    //[self showMsg:@"太厉害了！"];
    [self showImg:@"tailihaile_icon"];
}
-(void)showPerfect{
    //[self showMsg:@"完美无比！"];
    [self showImg:@"wanmeiwubi_icon"];
}
-(void)showReadyGo{
    [self showImg:@"lz_font_reaygo"];
}
-(void)showPassTarget{
    //[self showMsg:@"目标达成！"];
    [self showImg:@"mubiaodacheng_icon"];
}
-(void)showVeryPerfect{
    //[self showMsg:@"目标达成！"];
    [self showImg:@"taiwanmeile_icon"];
}

-(void)showImg:(NSString*)imgstr{
    UIImage *img = [UIImage imageNamed:imgstr];
    if (img) {
        
        float w = UIScreenWidth/3*2;
        if (w>img.size.width) {
            w = img.size.width;
        }
        float h = img.size.height/img.size.width * w;
        
        float x = 0;
        float y = (UIScreenHeight-UIScreenWidth) + UIScreenWidth/2 - h/2 - 100;
        if(iPhoneX || iPhoneXsMax || iPhoneXR){
            y -= 44;
        }
        self.mainView.frame = CGRectMake(0, y, UIScreenWidth, h);
        x = (self.mainView.frame.size.width - w)/2;
        
        self.msgView.frame = CGRectMake(x, 0, w, h);
        self.msgView.image = img;
//        self.msgView.layer.shadowColor = UIColorFromRGB(0xc44c4e).CGColor;//阴影颜色
//        self.msgView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
//        self.msgView.layer.shadowOpacity = 1;//不透明度
//        self.msgView.layer.shadowRadius = 10.0;//半径
        //self.msgView.alpha = 0.9;
        //self.msgView.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //self.msgView.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        
        self.msgView.transform = CGAffineTransformMakeScale(20, 20);
        self.msgView.alpha = 0;
        WEAKSELF
        [UIView animateWithDuration:0.2 animations:^{
            __weakSelf.msgView.transform = CGAffineTransformMakeScale(1, 1);
            __weakSelf.msgView.alpha = 0.9;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                // 通过关键帧动画实现缩放
                [UIView animateWithDuration:0.3 animations:^{
                    //__weakSelf.msgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                    __weakSelf.msgView.frame = CGRectMake(x, -h, w, h);
                    __weakSelf.msgView.alpha = 0;
                } completion:^(BOOL finished) {
                    // 通过关键帧动画实现缩放

                }];
            });
            
        }];
    }
    
    
    [self show];
}


-(void)showMsg:(NSString*)msg{
    //[self hide];
    float h = 50;
    float w = UIScreenWidth;
    
    float x = 15;
//    float y = 0;
//    y = 200 + UIScreenWidth/2;
//    if (iPhoneX || iPhoneXsMax) {
//        y = 250 + UIScreenWidth/2;
//    }
    
    float y = (UIScreenHeight-UIScreenWidth) + UIScreenWidth/4;
    if(iPhoneX || iPhoneXsMax){
        y -= 44;
    }
    
    
    self.mainView.frame = CGRectMake(0, y, w, h);
    self.steamView.frame =CGRectMake(x, 0, w, h);
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:msg];
//    NSDictionary *dict = @{
//        NSStrokeColorAttributeName:UIColorFromRGB(0xc44c4e),
//        NSStrokeWidthAttributeName : [NSNumber numberWithFloat:5],
//        NSForegroundColorAttributeName:[UIColor whiteColor],
//    };
//    [string addAttributes:dict range: NSMakeRange(0, string.string.length)];
//
    self.titleView.frame = CGRectMake(x, 0, w, h);
    self.titleView.text = msg;
    //self.titleView.attributedText = string;
    self.titleView.textColor = UIColorFromRGB(0xffffff);
    self.titleView.textAlignment = NSTextAlignmentCenter;
    self.titleView.font = kFontBold(50);
    self.titleView.alpha = 1;
    
    //self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.glowSize = 20;
    self.titleView.innerGlowSize = 4;
    self.titleView.glowColor = UIColorFromRGB(0x5832b9);
    self.titleView.innerGlowColor = UIColorFromRGB(0xc44c4e);
    
    self.titleView.transform = CGAffineTransformMakeScale(20, 20);
    self.titleView.alpha = 0;
    //[self setupEmitter:CGSizeMake(w, h) x:w/2 y:h/2];
    WEAKSELF
    [UIView animateWithDuration:0.2 animations:^{
        __weakSelf.titleView.transform = CGAffineTransformMakeScale(1, 1);
        __weakSelf.titleView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // 通过关键帧动画实现缩放
            [UIView animateWithDuration:0.8 animations:^{
                __weakSelf.titleView.frame = CGRectMake(x, -50, w, h);
                //__weakSelf.msgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                __weakSelf.titleView.alpha = 0;
            } completion:^(BOOL finished) {
                // 通过关键帧动画实现缩放

            }];
        });
        
    }];
    
    [self show];
}


- (void)setupEmitter:(CGSize)size x:(float)x y:(float)y{
//    1.设置 CAEmitterLayer
    CAEmitterLayer *colorBallLayer = [CAEmitterLayer layer];
    [self.titleView.layer addSublayer:colorBallLayer];
    //colorBallLayer.emitterMode = kCAEmitterLayerLine;
//    发射源的尺寸大小
    colorBallLayer.emitterSize = size;
//    发射源的形状
    colorBallLayer.emitterShape = kCAEmitterLayerPoint;
//    发射模式
    colorBallLayer.emitterMode = kCAEmitterLayerBackToFront;
//    粒子发射形状的中心点
    colorBallLayer.emitterPosition = CGPointMake(x, y);
//    2.配置 CAEmitterCell
    CAEmitterCell *colorBallCell = [CAEmitterCell emitterCell];
//    粒子名称
    colorBallCell.name = @"colorBallCell";
//    粒子产生率, 默认为 0
    colorBallCell.birthRate = 1.f;
//    粒子生命周期
    colorBallCell.lifetime = 1.f;
//    粒子速度, 默认为 0
    colorBallCell.velocity = 1400.f;
//    粒子速度平均量
    colorBallCell.velocityRange = 5000.f;
//    x,y,z 方向上的加速度分量, 三者默认为 0
    colorBallCell.yAcceleration = 0.f;
//    指定纬度, 纬度角代表在 x-z轴平面坐标系中与 x 轴之间的夹角默认为 0
    //colorBallCell.emissionLongitude = M_PI;// 向左
//    发射角度范围,默认为 0, 以锥形分布开的发射角, 角度为弧度制.粒子均匀分布在这个锥形范围内;
    //colorBallCell.emissionRange = M_PI;// 围绕 x 轴向左90 度
//    缩放比例, 默认 1
    colorBallCell.scale = 1;
//    缩放比例范围, 默认是 0
    colorBallCell.scaleRange = 0.1;
//    在生命周期内的缩放速度, 默认是 0
    colorBallCell.scaleSpeed = 0.02;
//    粒子的内容, 为 CGImageRef 的对象
    colorBallCell.contents = (id)[[UIImage imageNamed:@"circle_white"] CGImage];
//    颜色
    colorBallCell.color = [[UIColor whiteColor] colorWithAlphaComponent:1].CGColor;
//    粒子颜色 red, green, blue, alpha 能改变的范围, 默认 0
    colorBallCell.redRange = 1.f;
    colorBallCell.greenRange = 1.f;
    colorBallCell.alphaRange = 0;
//    粒子颜色 red, green, blue, alpha 在生命周期内的改变速度, 默认 0
    colorBallCell.blueSpeed = 1.f;
    colorBallCell.alphaSpeed = -0.1f;
    
//    添加
    colorBallLayer.emitterCells = @[colorBallCell];

}

-(void)show{
    WEAKSELF
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [__weakSelf hide];
    });
    
}
-(void)initViews{
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    self.userInteractionEnabled = NO;
    [[AppDelegate sharedSingleton].window addSubview:self];
    
    float w = UIScreenWidth;
    float h = w;
    float x = 30;
    float y = (UIScreenHeight-UIScreenWidth-h)/2+30;
    
    //self.maskView = [[UIView alloc] initWithFrame:self.bounds];
//    self.maskView.backgroundColor = [UIColor blackColor];
//    self.maskView.alpha = 0;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//    [self.maskView addGestureRecognizer:tap];
    //[self.maskView setUserInteractionEnabled:NO];
    //[self addSubview:self.maskView];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
//    self.mainView.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:[YunConfig getUserBackgroundImageName]]] colorWithAlphaComponent:0.5];
//    self.mainView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
//    self.mainView.layer.borderWidth = 3;
//    self.mainView.layer.cornerRadius = 30;
    [self addSubview:self.mainView];
    
    self.msgView = [[UIImageView alloc] initWithFrame:self.mainView.bounds];
    [self.mainView addSubview:self.msgView];
    
//    self.steamView = [[MCSteamView alloc] initWithFrame:self.mainView.bounds];
//    [self.mainView addSubview:self.steamView];
    
    self.titleView = [[FBGlowLabel alloc] initWithFrame:self.mainView.bounds];
    [self.mainView addSubview:self.titleView];
    
    
    //self.transform = CGAffineTransformScale(self.transform, 0, 0);
}
-(void)hide{
    //self.hidden = YES;
}

-(void)clickButton:(UIButton*)button{
    if (self.magicBlock) {
        self.magicBlock(button,(int)button.tag);
    }
    [self hide];
}
@end
