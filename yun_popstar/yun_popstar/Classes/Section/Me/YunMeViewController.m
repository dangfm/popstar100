//
//  YunMeViewController.m
//  yun_popstar
//
//  Created by dangfm on 2020/7/3.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunMeViewController.h"

@interface YunMeViewController ()

@end

@implementation YunMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
 

}
- (void)initView{
    [self initSay];
    [self initBackgroundView];
    [self initHeaderView];
    //[self setBackground];
}

-(void)initHeaderView{
    if (!self.headerView) {
        float h = 100;
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h)];
        self.headerView.backgroundColor = [UIColor clearColor];
        float x = 35;
        float y = 28;
        float w = (UIScreenWidth - 20) / 3;
        if (w<150) {
            w = 150;
        }
        UIFont *font = kFontBold(14);
        float add_w = 25;
        h = 30;
        if (iPhoneX || iPhoneXsMax) {
            y = 50;
        }
        UIButton *bt = [[UIButton alloc] init];
        bt.frame = CGRectMake(x, y, w, h);
        bt.layer.cornerRadius = h/2;
        bt.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
        bt.layer.borderWidth = 1;
        bt.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        //[bt setTitle:@"45" forState:UIControlStateNormal];
        //[bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        bt.titleLabel.textAlignment = NSTextAlignmentCenter;

        bt.layer.shadowColor = UIColorFromRGB(0x5b331b).CGColor;//阴影颜色
        bt.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
        bt.layer.shadowOpacity = 0.3;//不透明度
        bt.layer.shadowRadius = 3.0;//半径

        //bt.alpha = 0.8;
        [self.headerView addSubview:bt];
        // 头像
        UIButton *star = [[UIButton alloc] initWithFrame:CGRectMake(x, y-5, h+10, h+10)];
        [star setImage:[UIImage imageNamed:@"lz_default_face_girl"] forState:UIControlStateNormal];
        [self.headerView addSubview:star];
        // 金币
        UIImageView *coin = [[UIImageView alloc] initWithFrame:CGRectMake(x+h+10+5, y+5, h-10, h-10)];
        coin.image = [UIImage imageNamed:@"lz_coin"];
        [self.headerView addSubview:coin];

        
        UILabel *xx = [[UILabel alloc] initWithFrame:CGRectMake(star.frame.size.width+coin.frame.size.width+10, 0, w-(star.frame.size.width+coin.frame.size.width)-add_w-15, h)];
        xx.text = @"10900";
        xx.textColor = [UIColor whiteColor];
        xx.font = font;
        xx.textAlignment = NSTextAlignmentLeft;
        xx.adjustsFontSizeToFitWidth = YES;
        //xx.alpha = 0.8;
        [bt addSubview:xx];
        
        UIImageView *xx_add = [[UIImageView alloc] init];
        xx_add.image = [UIImage imageNamed:@"lz_tool_add_icon"];
        //xx_add.image = [xx_add.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //[xx_add setTintColor:[UIColor whiteColor]];
        xx_add.frame = CGRectMake(bt.frame.origin.x+bt.frame.size.width-add_w-2.5, y+2.5, add_w, add_w);
        [self.headerView addSubview:xx_add];
        
        [self.view addSubview:self.headerView];
    }
}

-(void)initBackgroundView{
    if (!self.backgroundView) {
        self.backgroundView = [[YunPopstarBackgroundImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        //self.backgroundView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.backgroundView];
    }
}



- (void)setBackground{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"lz_background_big"]]];
}

-(void)initSay{
    self.say = [YunPopstarSay new];
}


@end
