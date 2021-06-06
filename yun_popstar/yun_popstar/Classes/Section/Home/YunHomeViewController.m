//
//  YunHomeViewController.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/3.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunHomeViewController.h"

@interface YunHomeViewController ()

@end

@implementation YunHomeViewController

-(void)dealloc{
    NSLog(@"YunHomeViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]}forState:UIControlStateNormal];//将title 文字的颜色改为透明
}

-(instancetype)initWityChallenge:(BOOL)challenge challenger:(NSDictionary*)challenger{
    if (self=[super init]) {
        _challenger = challenger;
        _isChallenge = challenge;
    }
    return self;
}

-(void)free{
    [self.starView free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.say stop];
}


-(void)clear{
    if (self.starView) {
        [self.starView resetStarView];
    }
}

- (void)initView{
    // 新人奖励金币
    if ([YunConfig getUserFirstGold]<=0 && !_isChallenge) {
        [[YunShowFirstGoldView sharedSingleton]show];
        [YunShowFirstGoldView sharedSingleton].clickButtonBlock = ^(UIButton * _Nonnull button) {
            //[[YunGetRedEnvelope sharedSingleton] showWithType:3];
            if ([YunConfig getUserIsOpenRedEnvelope]) {
                [[YunGetRedEnvelope sharedSingleton] show];
            }
            
        };
    }
    //[[YunGetRedEnvelope sharedSingleton] show];
    //[[YunShowFirstGoldView sharedSingleton]show];
    
    [self initSay];
    [self initBackgroundView];
    [self initWeatherView];
    [self initHeaderView];
    //[self setBackground];
    
    [self resetStarView];
    //[self makeFireworksDisplay];
    //[self startAnimation];
    // 退出游戏，返回游戏主页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationGameStartHome) name:kNSNotificationName_GoToGameStartHome object:nil];
    // 红包关闭
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRedEnvelopeClose) name:kNSNotificationName_RedEnvelope_Close object:nil];
    
}
-(void)initHeaderView{
    if (_isChallenge) {
        if (!self.challengeHeaderView) {
            float h = UIScreenHeight-(self.view.frame.size.height-self.view.frame.size.width);
            if(iPhoneX || iPhoneXsMax){
                h = UIScreenHeight-(self.view.frame.size.height-self.view.frame.size.width-44);
            }
            self.challengeHeaderView = [[YunPopstarChallengeHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h) isChallenge:_isChallenge challenger:_challenger];
            self.challengeHeaderView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:self.challengeHeaderView];
            [self.challengeHeaderView updateRedenvelope_time:0];
        }
    }else{
        if (!self.headerView) {
            float h = UIScreenHeight-(self.view.frame.size.height-self.view.frame.size.width);
            if(iPhoneX || iPhoneXsMax){
                h = UIScreenHeight-(self.view.frame.size.height-self.view.frame.size.width-44);
            }
            self.headerView = [[YunPopstarHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h)];
            self.headerView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:self.headerView];
            [self.headerView updateRedenvelope_time:0];
        }
    }
    
}

-(void)initBackgroundView{
    if (!self.backgroundView) {
        self.backgroundView = [[YunPopstarBackgroundImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        //self.backgroundView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.backgroundView];
    }
}

-(void)initWeatherView{
    if (!self.weatherView) {
        
        self.weatherView = [[WHWeatherView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        self.weatherView.backgroundColor = [UIColor clearColor];
        [self.weatherView showWeatherAnimationWithType:WHWeatherTypeSnow];
        [self.view addSubview:self.weatherView];
    }
}


- (void)setBackground{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"lz_background_big"]]];
}
- (void)resetStarView{
    
    if (!self.starView) {
        float y = (self.view.frame.size.height-self.view.frame.size.width);
        if(iPhoneX || iPhoneXsMax){
            y = (self.view.frame.size.height-self.view.frame.size.width-44);
        }
        int w = self.view.frame.size.width/10;
        float x = (self.view.frame.size.width-w*10) / 2;
        self.starView = [[YunPopstarView alloc] initWithFrame:CGRectMake(x, y, w*10, self.view.frame.size.width) isChallenge:_isChallenge challenger:_challenger];
        [self.view addSubview:self.starView];
    }
}

- (void)makeFireworksDisplay {
    // 配置layer
    CAEmitterLayer * fireworksLayer = [CAEmitterLayer layer];
    [self.view.layer addSublayer:fireworksLayer];
    self.fireworksLayer = fireworksLayer;
    
    fireworksLayer.emitterPosition = CGPointMake(self.view.layer.bounds.size.width * 0.5, self.view.layer.bounds.size.height); // 在底部
    fireworksLayer.emitterSize = CGSizeMake(self.view.layer.bounds.size.width * 0.1, 0.f);  // 宽度为一半
    fireworksLayer.emitterMode = kCAEmitterLayerOutline;
    fireworksLayer.emitterShape = kCAEmitterLayerLine;
    fireworksLayer.renderMode = kCAEmitterLayerAdditive;
    
    // 发射
    CAEmitterCell * shootCell = [CAEmitterCell emitterCell];
    shootCell.name = @"shootCell";
    
    //shootCell.birthRate = 1.f;
    shootCell.lifetime = 1.02;  // 上一个销毁了下一个再发出来
    
    shootCell.velocity =self.view.layer.bounds.size.height-100;
    shootCell.velocityRange = 100.f;
    shootCell.yAcceleration = 75.f;  // 模拟重力影响
    
    shootCell.emissionRange = M_PI * 0.15; //
    
    shootCell.scale = 0.05;
    shootCell.color = [[UIColor redColor] CGColor];
    shootCell.greenRange = 1.f;
    shootCell.redRange = 1.f;
    shootCell.blueRange = 1.f;
    shootCell.contents = (id)[[UIImage imageNamed:@"shoot_white"] CGImage];
    
    shootCell.spinRange = M_PI;  // 自转360度
    
    // 爆炸
    CAEmitterCell * explodeCell = [CAEmitterCell emitterCell];
    explodeCell.name = @"explodeCell";
    
    explodeCell.birthRate = 1.f;
    explodeCell.lifetime = 0.5f;
    explodeCell.velocity = 0.f;
    explodeCell.scale = 2.5;
    explodeCell.redSpeed = -1.5;  //爆炸的时候变化颜色
    explodeCell.blueRange = 1.5; //爆炸的时候变化颜色
    explodeCell.greenRange = 1.f; //爆炸的时候变化颜色
    
    // 火花
    CAEmitterCell * sparkCell = [CAEmitterCell emitterCell];
    sparkCell.name = @"sparkCell";
    
    sparkCell.birthRate = 400.f;
    sparkCell.lifetime = 3.f;
    sparkCell.velocity = 125.f;
    sparkCell.velocityRange = 500.f;
    sparkCell.yAcceleration = 175.f;  // 模拟重力影响
    sparkCell.emissionRange = M_PI * 2;  // 360度
    
    sparkCell.scale = 1.2f;
    sparkCell.contents = (id)[[UIImage imageNamed:@"star_white_stroke"] CGImage];
    sparkCell.redSpeed = 0.4;
    sparkCell.greenSpeed = -0.1;
    sparkCell.blueSpeed = -0.1;
    sparkCell.alphaSpeed = -0.25;
    
    sparkCell.spin = M_PI * 2; // 自转
    
    //添加动画
    fireworksLayer.emitterCells = @[shootCell];
    shootCell.emitterCells = @[explodeCell];
    explodeCell.emitterCells = @[sparkCell];

}

/**
 * 开始动画
 */
- (void)startAnimation{
    
    [self.say say:@"lz_star_yanhua.wav"];
    
    // 用KVC设置颗粒个数
    [self.fireworksLayer setValue:@10 forKeyPath:@"emitterCells.shootCell.birthRate"];
   
    // 开始动画
    self.fireworksLayer.beginTime = CACurrentMediaTime();
    
    // 延迟停止动画
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.3];
    //[self borderDefault];
}

/**
 * 动画结束
 */
- (void)stopAnimation{
    // 用KVC设置颗粒个数
    [self.fireworksLayer setValue:@0 forKeyPath:@"emitterCells.shootCell.birthRate"];
    [self.fireworksLayer removeAllAnimations];
   

}



-(void)initSay{
    self.say = [YunPopstarSay new];
}

-(void)notificationGameStartHome{
    [self free];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)notificationRedEnvelopeClose{
    // 红包关闭后重新开始初始化
    [self.headerView updateRedenvelope_time:0];
}

@end
