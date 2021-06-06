//
//  YunPopstarHeaderView.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/11.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPopstarHeaderView.h"

@implementation YunPopstarHeaderView

-(void)free{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.say free];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        [self initSay];
        [self initView];
    }
    return self;
}

-(void)initView{
    float x = 5;
    float y = 22;
    float w = (UIScreenWidth - 20) / 3;
    float h = 30;
    if (iPhoneX || iPhoneXsMax || iPhoneXR) {
        y = 44;
    }
    float add_w = 25;
    UIFont *font = kFontBold(14);
    
    float w2 = 100;
    float w1 = (UIScreenWidth-20 - w2) / 2;
    
    // 红包
    UIButton *redenvelope = [[UIButton alloc] init];
    UIImage *redimage = [UIImage imageNamed:@"lz_red_envelope"];
    [redenvelope setImage:redimage forState:UIControlStateNormal];
    redenvelope.frame = CGRectMake(2, y+h+20, h+20, redimage.size.height/redimage.size.width * (h+20));
    [redenvelope addTarget:self action:@selector(clickRedEnvelopeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:redenvelope];
    redenvelope.hidden = ![YunConfig getUserIsOpenRedEnvelope];
    
    // 余额
    UILabel *ye = [[UILabel alloc] initWithFrame:CGRectMake(0, 10,redenvelope.frame.size.width, 50)];
    ye.text = @"";
    ye.textColor = [UIColor yellowColor];
    ye.font = [UIFont systemFontOfSize:8 weight:200];
    ye.textAlignment = NSTextAlignmentCenter;
    ye.numberOfLines = 2;
    ye.adjustsFontSizeToFitWidth = YES;
    [redenvelope addSubview:ye];
    _balanceLb = ye;
    [self startRedEnvelopeAnimation:redenvelope];
    [self notificationGetRedEnvelope];
    
    // 红包提示
//    _redenvelope_time = [[UIButton alloc] initWithFrame:CGRectMake(10, redenvelope.frame.origin.y+redenvelope.frame.size.height + 5, redenvelope.frame.size.width-15, 15)];
//    _redenvelope_time.layer.cornerRadius = _redenvelope_time.frame.size.height/2;
//    _redenvelope_time.layer.masksToBounds = YES;
//    _redenvelope_time.titleLabel.font = kFontBold(10);
//    [_redenvelope_time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _redenvelope_time.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
//    [_redenvelope_time setTitle:@"60" forState:UIControlStateNormal];
//    _redenvelope_time.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
//    _redenvelope_time.layer.borderWidth = 0.5;
//    _redenvelope_time.hidden = ![YunConfig getUserIsOpenRedEnvelope];
//    [self addSubview:_redenvelope_time];
    
    LDProgressView *progressView=[[LDProgressView alloc]initWithFrame:CGRectMake(5, redenvelope.frame.origin.y+redenvelope.frame.size.height + 5, redenvelope.frame.size.width-5, 15)];
    progressView.color = UIColorFromRGB(0xec5254);
    progressView.progress = 0;
    progressView.animate = @NO;
    progressView.showText = @NO;
    progressView.flat = @YES;
    progressView.type = LDProgressStripes;
    progressView.background = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    progressView.hidden = ![YunConfig getUserIsOpenRedEnvelope];
    _redenvelope_time = progressView;
    [self addSubview:_redenvelope_time];
    _redenvelope_time_lb = [[UILabel alloc] initWithFrame:_redenvelope_time.bounds];
    _redenvelope_time_lb.font = kFontBold(8);
    _redenvelope_time_lb.textAlignment = NSTextAlignmentCenter;
    _redenvelope_time_lb.textColor = [UIColor whiteColor];
    [_redenvelope_time addSubview:_redenvelope_time_lb];
    
    
    UIButton *bt = [[UIButton alloc] init];
    bt.frame = CGRectMake(x, y, w1, h);
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
    [bt addTarget:self action:@selector(clickMyGold) forControlEvents:UIControlEventTouchUpInside];
    //bt.alpha = 0.8;
    [self addSubview:bt];
    
    
    UILabel *jb_title = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 40, h-4)];
    jb_title.text = @"金币";
    jb_title.textColor = UIColorFromRGB(0x5832b9);//[UIColor colorWithPatternImage:[UIImage imageNamed:[YunConfig getUserBackgroundImageName]]];
    jb_title.font = [UIFont systemFontOfSize:12 weight:200];;
    jb_title.textAlignment = NSTextAlignmentCenter;
    jb_title.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    jb_title.layer.cornerRadius = h/2-2;
    jb_title.layer.masksToBounds = YES;
    [bt addSubview:jb_title];
    
    // 金币
//    UIImageView *coin = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, h, h)];
//    coin.image = [UIImage imageNamed:@"gold_face_icon"];
//    [self addSubview:coin];

    
    UILabel *xx = [[UILabel alloc] initWithFrame:CGRectMake(jb_title.frame.size.width+5, 0, w1-jb_title.frame.size.width-add_w-10, h)];
    xx.text = [NSString stringWithFormat:@"%d",[YunConfig getUserGold]];
    xx.textColor = [UIColor whiteColor];
    xx.font = font;
    xx.textAlignment = NSTextAlignmentCenter;
    xx.adjustsFontSizeToFitWidth = YES;
    //xx.alpha = 0.8;
    [bt addSubview:xx];
    _userGold = xx;
    
    UIImageView *xx_add = [[UIImageView alloc] init];
    xx_add.image = [UIImage imageNamed:@"lz_coin"];
    //xx_add.image = [xx_add.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //[xx_add setTintColor:[UIColor whiteColor]];
    xx_add.frame = CGRectMake(bt.frame.origin.x+bt.frame.size.width-add_w-2.5, y+2.5, add_w, add_w);
    [self addSubview:xx_add];
    
    if ([YunConfig getUserIsOpenRedEnvelope]) {
        // 可提现
        UIImage *enbg = [UIImage imageNamed:@"enchashment_bg_icon"];
        enbg = [UIImage imageWithTintColor:UIColorFromRGB(0x5ab625) blendMode:kCGBlendModeDestinationIn WithImageObject:enbg];
        float eh = 20;
        float ew = enbg.size.width/enbg.size.height * eh;
        UIButton *enchashmentBt = [[UIButton alloc] initWithFrame:CGRectMake(x+(w1-ew)/2, y+h-8, ew, eh)];
        [enchashmentBt setBackgroundImage:enbg forState:UIControlStateNormal];
        [enchashmentBt setTitle:@"可提现" forState:UIControlStateNormal];
        [enchashmentBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        enchashmentBt.titleLabel.font = kFontBold(10);
        enchashmentBt.titleEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
        [enchashmentBt addTarget:self action:@selector(clickMyGold) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:enchashmentBt];
    
    }
//    UILabel *xx = [[UILabel alloc] initWithFrame:CGRectMake(coin.frame.origin.x+coin.frame.size.width, 0, w1-(coin.frame.origin.x+coin.frame.size.width)-add_w-5, h)];
//    xx.text = [NSString stringWithFormat:@"%d",[YunConfig getUserGold]];
//    xx.textColor = [UIColor whiteColor];
//    xx.font = font;
//    xx.textAlignment = NSTextAlignmentLeft;
//    xx.adjustsFontSizeToFitWidth = YES;
//    //xx.alpha = 0.8;
//    [bt addSubview:xx];
    //_userGold = xx;
    
    
    
    
    
    UIButton *bt2 = [[UIButton alloc] init];
    bt2.frame = CGRectMake(x+w1+5, y, w2, h);
    bt2.layer.cornerRadius = h/2;
    bt2.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
    bt2.layer.borderWidth = 1;
    bt2.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    [bt2 setTitle:@"" forState:UIControlStateNormal];
    bt2.titleLabel.font = font;
    [bt2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bt2.titleLabel.textAlignment = NSTextAlignmentLeft;
    bt2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    bt2.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    bt2.layer.shadowColor = UIColorFromRGB(0x5b331b).CGColor;//阴影颜色
    bt2.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    bt2.layer.shadowOpacity = 0.3;//不透明度
    bt2.layer.shadowRadius = 3.0;//半径
    
    //bt2.alpha = 0.8;
    [self addSubview:bt2];
    
    UILabel *gk_title = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 40, h-4)];
    gk_title.text = @"关卡";
    gk_title.textColor = UIColorFromRGB(0x5832b9);//[UIColor colorWithPatternImage:[UIImage imageNamed:[YunConfig getUserBackgroundImageName]]];
    gk_title.font = [UIFont systemFontOfSize:12 weight:200];;
    gk_title.textAlignment = NSTextAlignmentCenter;
    gk_title.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    gk_title.layer.cornerRadius = h/2-2;
    gk_title.layer.masksToBounds = YES;
    [bt2 addSubview:gk_title];
    
    UILabel *gk = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, w2-30, h)];
    gk.text = [NSString stringWithFormat:@"%d",[YunConfig getUserPassNumber]];
    gk.textColor = [UIColor whiteColor];
    gk.font = font;
    gk.textAlignment = NSTextAlignmentCenter;
    [bt2 addSubview:gk];
    //gk.alpha = 0.8;
    self.passNumber = gk;
    
    float w3 = UIScreenWidth - w1 - w2 - 20;
    
    UIButton *bt3 = [[UIButton alloc] init];
    bt3.frame = CGRectMake(x+(w2+5)+(w1+5), y, w3, h);
    bt3.layer.cornerRadius = h/2;
    bt3.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
    bt3.layer.borderWidth = 1;
    bt3.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    bt3.titleLabel.font = font;
    [bt3 setTitle:@"" forState:UIControlStateNormal];
    [bt3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //bt3.titleLabel.textAlignment = NSTextAlignmentLeft;
    bt3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    bt3.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    bt3.layer.shadowColor = UIColorFromRGB(0x5b331b).CGColor;//阴影颜色
    bt3.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    bt3.layer.shadowOpacity = 0.3;//不透明度
    bt3.layer.shadowRadius = 3.0;//半径
    //bt3.alpha = 0.8;
    [self addSubview:bt3];
    
    UILabel *mb_title = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 40, h-4)];
    mb_title.text = @"目标";
    mb_title.textColor = UIColorFromRGB(0x5832b9);//[UIColor colorWithPatternImage:[UIImage imageNamed:[YunConfig getUserBackgroundImageName]]];
    mb_title.font = [UIFont systemFontOfSize:12 weight:200];
    mb_title.textAlignment = NSTextAlignmentCenter;
    mb_title.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    mb_title.layer.cornerRadius = h/2-2;
    mb_title.layer.masksToBounds = YES;
    [bt3 addSubview:mb_title];
    
    
    UILabel *mb = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, w-40, h)];
    mb.text = [NSString stringWithFormat:@"%d",[YunConfig getUserTargetCoin]];;
    mb.adjustsFontSizeToFitWidth = YES;
    mb.textColor = [UIColor whiteColor];
    mb.font = font;
    mb.textAlignment = NSTextAlignmentCenter;
    //mb.alpha = 0.8;
    [bt3 addSubview:mb];
    self.targetCoin = mb;
    self.totalNumber =[YunConfig getUserCoin];
    float fs = (UIScreenWidth-100-9*5) / 9;
    self.numberView = [[YunPopstarNumberView alloc] initWithNumber:self.totalNumber fontsize:fs padding:-5];
    self.numberView.frame = CGRectMake((self.frame.size.width-[self.numberView getSize].width)/2, y + h +30, 0, 0);
    [self addSubview:self.numberView];
    
    // 播放按钮
    UIButton *playbt = [[UIButton alloc] init];
    UIImage *image = [UIImage imageNamed:@"lz_play_icon"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [playbt setImage:image forState:UIControlStateNormal] ;
    [playbt setTintColor:[UIColor whiteColor]];
    playbt.frame = CGRectMake(self.frame.size.width-5-h-20, y+h+20, h+20, image.size.height/image.size.width * (h+20));
    [playbt addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    //playbt.alpha = 0.8;
    [self addSubview:playbt];
    
    UIImageView *playbt_megic_bg = [[UIImageView alloc] initWithFrame:CGRectMake(playbt.frame.origin.x-1, playbt.frame.origin.y-1, playbt.frame.size.width+2, playbt.frame.size.height+2)];
    playbt_megic_bg.image = [UIImage imageNamed:@"megic_tool_bg"];
    [self addSubview:playbt_megic_bg];
    
    // 回放按钮
    UIImage *backplayimage = [UIImage imageNamed:@"back_play_icon"];
    backplayimage = [UIImage scaleToSize:backplayimage size:CGSizeMake(backplayimage.size.width/backplayimage.size.height * 40, 40)];
    UIButton *backplaybt = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-5-h-15, y+h+10+playbt.frame.size.height + 20, backplayimage.size.width/backplayimage.size.height * 40,40)];
    backplaybt.titleLabel.font = kFont(12);
    [backplaybt setTitle:@"回放" forState:UIControlStateNormal];
    [backplaybt setImage:backplayimage forState:UIControlStateNormal] ;
    //backplaybt.imageView.contentMode = UIViewContentModeScaleAspectFill;
    backplaybt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [backplaybt setTitleEdgeInsets:UIEdgeInsetsMake(backplaybt.imageView.frame.size.height ,-backplaybt.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [backplaybt setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -backplaybt.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    [backplaybt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backplaybt addTarget:self action:@selector(clickBackPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    //playbt.alpha = 0.8;
    [self addSubview:backplaybt];
    
    // 工具按钮
    w = UIScreenWidth / 7;
    float padding = 15;
    x = (UIScreenWidth - (3*w+2*padding))/2;
    float ww = w-20;
    float xxx = (w-ww) / 2;
    float yyy = (w-ww) / 2;
    y += 30;
    
    UIButton *tool1_bg = [[UIButton alloc] init];
    tool1_bg.frame = CGRectMake(x, y+h+20+70, w, w);
    tool1_bg.layer.borderWidth = 10;
    tool1_bg.layer.cornerRadius = w/2;
    tool1_bg.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    tool1_bg.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [tool1_bg addTarget:self action:@selector(clickRefresh:) forControlEvents:UIControlEventTouchUpInside];
    [tool1_bg addTarget:self action:@selector(touchInRefresh:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tool1_bg];
    _refreshBt = tool1_bg;
    
    UIImageView *tool1_megic_bg = [[UIImageView alloc] initWithFrame:CGRectMake(tool1_bg.frame.origin.x-3, tool1_bg.frame.origin.y-3, tool1_bg.frame.size.width+6, tool1_bg.frame.size.height+6)];
    tool1_megic_bg.image = [UIImage imageNamed:@"megic_tool_bg"];
    [self addSubview:tool1_megic_bg];
    
    
    UIImageView *tool1 = [[UIImageView alloc] init];
    tool1.image = [UIImage imageNamed:@"lz_tool_refresh"];
    //tool1.image = [tool1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //tool1.tintColor = UIColorFromRGB(0x169f49);
    tool1.frame = CGRectMake(xxx, yyy, ww, tool1.image.size.height/tool1.image.size.width * ww);
    tool1.layer.shadowColor = UIColorFromRGB(0x5b331b).CGColor;//阴影颜色
    tool1.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    tool1.layer.shadowOpacity = 0.3;//不透明度
    tool1.layer.shadowRadius = 3.0;//半径
    [tool1_bg addSubview:tool1];
    UIImageView *tool1_add = [[UIImageView alloc] init];
    tool1_add.image = [UIImage imageNamed:@"lz_tool_add_icon"];
    tool1_add.frame = CGRectMake(tool1_bg.frame.origin.x + tool1_bg.frame.size.width-add_w/2-10, tool1_bg.frame.origin.y+tool1_bg.frame.size.height-add_w/2-10, add_w, add_w);
    [self addSubview:tool1_add];
    _refresh_num = tool1_add;
    
    
    UIButton *tool2_bg = [[UIButton alloc] init];
    tool2_bg.frame = CGRectMake(x+w+padding, y+h+20+70, w, w);
    tool2_bg.layer.borderWidth = 10;
    tool2_bg.layer.cornerRadius =  w/2;
    tool2_bg.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    tool2_bg.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [tool2_bg addTarget:self action:@selector(clickBomb:) forControlEvents:UIControlEventTouchUpInside];
    [tool2_bg addTarget:self action:@selector(touchInBomb:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tool2_bg];
    _bombBt = tool2_bg;
    
    UIImageView *tool2_megic_bg = [[UIImageView alloc] initWithFrame:CGRectMake(tool2_bg.frame.origin.x-3, tool2_bg.frame.origin.y-3, tool2_bg.frame.size.width+6, tool2_bg.frame.size.height+6)];
    tool2_megic_bg.image = [UIImage imageNamed:@"megic_tool_bg"];
    [self addSubview:tool2_megic_bg];
    
    UIImageView *tool2 = [[UIImageView alloc] init];
    tool2.image = [UIImage imageNamed:@"lz_tool_bomb"];
//    tool2.image = [tool2.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    tool2.tintColor = [UIColor blackColor];
    tool2.frame = CGRectMake(xxx, yyy, ww, tool2.image.size.height/tool2.image.size.width * ww);
    tool2.layer.shadowColor = UIColorFromRGB(0x5b331b).CGColor;//阴影颜色
    tool2.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    tool2.layer.shadowOpacity = 0.3;//不透明度
    tool2.layer.shadowRadius = 3.0;//半径
    
    [tool2_bg addSubview:tool2];
    
    UIImageView *tool2_add = [[UIImageView alloc] init];
    tool2_add.image = [UIImage imageNamed:@"lz_tool_add_icon"];
    tool2_add.frame = CGRectMake(tool2_bg.frame.origin.x + tool2_bg.frame.size.width-add_w/2-10, tool2_bg.frame.origin.y+tool2_bg.frame.size.height-add_w/2-10, add_w, add_w);
    [self addSubview:tool2_add];
    _bomb_num = tool2_add;
    
    
    UIButton *tool3_bg = [[UIButton alloc] init];
    tool3_bg.frame = CGRectMake(x+w+padding+w+padding, y+h+20+70, w, w);
    tool3_bg.layer.borderWidth = 10;
    tool3_bg.layer.cornerRadius = w/2;
    tool3_bg.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
    tool3_bg.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [tool3_bg addTarget:self action:@selector(clickMagic:) forControlEvents:UIControlEventTouchUpInside];
    [tool3_bg addTarget:self action:@selector(touchInMagic:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tool3_bg];
    _magicBt = tool3_bg;
    
    UIImageView *tool3_megic_bg = [[UIImageView alloc] initWithFrame:CGRectMake(tool3_bg.frame.origin.x-3, tool3_bg.frame.origin.y-3, tool3_bg.frame.size.width+6, tool3_bg.frame.size.height+6)];
    tool3_megic_bg.image = [UIImage imageNamed:@"megic_tool_bg"];
    [self addSubview:tool3_megic_bg];
    
    UIImageView *tool3 = [[UIImageView alloc] init];
    tool3.image = [UIImage imageNamed:@"lz_tool_magic"];
    //tool3.image = [tool3.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //tool3.tintColor = UIColorFromRGB(0xfc418a);
    ww += 5;
    tool3.frame = CGRectMake(xxx, yyy, ww, tool3.image.size.height/tool3.image.size.width * ww);
    tool3.layer.shadowColor = UIColorFromRGB(0x5b331b).CGColor;//阴影颜色
    tool3.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    tool3.layer.shadowOpacity = 0.3;//不透明度
    tool3.layer.shadowRadius = 3.0;//半径
    [tool3_bg addSubview:tool3];
    
    UIImageView *tool3_add = [[UIImageView alloc] init];
    tool3_add.image = [UIImage imageNamed:@"lz_tool_add_icon"];
    tool3_add.frame = CGRectMake(tool3_bg.frame.origin.x + tool3_bg.frame.size.width-add_w/2-10, tool3_bg.frame.origin.y +tool3_bg.frame.size.height-add_w/2-10, add_w, add_w);
    [self addSubview:tool3_add];
    _magic_num = tool3_add;
    
    // 点击工具按钮显示说明
    _remarkLb = [[YunLabel alloc] initWithFrame:CGRectMake(0, tool1_bg.frame.size.height+tool1_bg.frame.origin.y + 20, UIScreenWidth, 30) borderWidth:3 borderColor:UIColorFromRGB(0x5832b9)];
    _remarkLb.font = kFontBold(14);
    _remarkLb.textColor = [UIColor whiteColor];
    _remarkLb.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_remarkLb];
    
    [self updateToolAmount];
    
    //得分通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addScroeNotification:) name:kNSNotificationName_AddScroe object:nil];
    //游戏开始通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStartNotification:) name:kNSNotificationName_GameStart object:nil];
    // 重新开始游戏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRestarNewGame) name:kNSNotificationName_NewGame object:nil];
    //游戏结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameEndNotification:) name:kNSNotificationName_GameOver object:nil];
    // 获得金币
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationGetCoin) name:kNSNotificationName_GetCoin object:nil];
    // 获得红包
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationGetRedEnvelope) name:kNSNotificationName_GetRedEnvelope object:nil];
    // 工具完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearSpaceAction) name:kNSNotificationName_ToolFinished object:nil];
    // 通关失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passFail:) name:kNSNotificationName_PassFail object:nil];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearSpaceAction)];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tap];
}

-(void)initSay{
    self.say = [YunPopstarSay new];
}

// 得分通知
-(void)addScroeNotification:(NSNotification *)noti{
    // 得到一个分数表明消灭一个星星
    [self updateRedenvelope_time:1];
    //使用object处理消息
    NSNumber *info = [noti object];
    NSLog(@"接收 object传递的消息：%@",info);
    self.currentNumber += [info intValue];
    self.totalNumber += [info intValue];
   
    //[YunConfig setUserCoin:self.totalNumber];
    [YunConfig setUserCoinSingle:self.currentNumber];
    
    if (self.currentNumber>[YunConfig getUserCoinMax]) {
        [YunConfig setUserCoinMax:self.currentNumber];
    }
    // 如果目标达成，则显示
    [self showPassTarget];
    
    [self.numberView showNumber:self.totalNumber];
    self.numberView.frame = CGRectMake((self.frame.size.width-[self.numberView getSize].width)/2, self.numberView.frame.origin.y, 0, 0);
    
    //[self clearToolAction];
}

// 目标达成 显示
-(void)showPassTarget{
    // 上次分数
    int count = [YunConfig getUserCoin];
    // 当前关卡分数
    int currentCount = [YunConfig getUserCoinSingle];
    // 当前总分
    count += currentCount;
    // 当前目标
    int target = [YunConfig getUserTargetCoin];
    // 是否大于当前目标分数
    if(count>=target && !_isPass){
        _isPass = YES;
        [self.say passtarget];
    }else{
        
    }
}

// 重新开始游戏通知
-(void)notificationRestarNewGame{
    self.isPass = NO;
    self.currentNumber = 0;
    self.totalNumber = 0;
    [YunConfig setUserCoinMax:0];
    [YunConfig setUserCoinSingle:0];
    [YunConfig setUserCoin:0];
    // 更新广告弹出时间
    [YunConfig seting:kConfig_User_clearance_show_ad_lasttime value:@(1).stringValue];
    
    [self.numberView showNumber:self.currentNumber];
    self.numberView.frame = CGRectMake((self.frame.size.width-[self.numberView getSize].width)/2, self.numberView.frame.origin.y, 0, 0);
    [YunConfig setUserCoin:self.currentNumber];
    
    // 默认
    // 初始化关卡
    self.passNumber.text = @"1";
    // 初始化目标
    self.targetCoin.text = [NSString stringWithFormat:@"%d",[YunConfig passNumberDefaultTargetNumber:1]];
    // 红包提示倒计时
    [self updateRedenvelope_time:0];
    [self clearToolAction];
    
    [self setHttpResetGame];
    
}

// 重新开始游戏
-(void)setHttpResetGame{
    //WEAKSELF
    int count = [YunConfig getUserCoin];
    int currentCount = [YunConfig getUserCoinSingle];
    count += currentCount;
    
    // 分数对应通关等级,是否通过，如果大于当前等级，就表明通过了
    //int target = [YunConfig getUserTargetCoin];
    __block int passNumber = [YunConfig getUserPassNumber];
    NSString *end_time = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    NSDictionary *p = @{
        @"levels":@(passNumber).stringValue,
        @"fraction":@(count).stringValue,
        @"gold":@([YunConfig getUserGold]).stringValue,
        @"max_fraction":@([YunConfig getUserCoinMax]).stringValue,
        @"tool_refresh_num":@([YunConfig getUserRefreshAmount]).stringValue,
        @"tool_bomb_num":@([YunConfig getUserBombAmount]).stringValue,
        @"tool_magic_num":@([YunConfig getUserMagicAmount]).stringValue,
        @"start_time":end_time,
        @"end_time":end_time,
        @"reset":@"1"
    };
    [http sendPostRequestWithParams:p api:kAPI_Users_AddLevels start:^{
        //[SVProgressHUD showWithStatus:@"正在重新配置..."];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"配置失败，网络不给力"];
    } success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        int code = [dic[@"code"] intValue];
        if (code==200) {
            
        }else{
            FMHttpShowError(dic);
        }
    }];
    

}
// 开始下一关游戏
-(void)gameStartNotification:(NSNotification *)noti{
    self.isPass = NO;
//    //使用object处理消息
//    NSNumber *info = [noti object];
//    NSLog(@"接收 object传递的消息：%@",info);
//    self.currentNumber = 0;
//    [self.numberView showNumber:self.currentNumber];
//    self.numberView.frame = CGRectMake((self.frame.size.width-[self.numberView getSize].width)/2, self.numberView.frame.origin.y, 0, 0);
    [YunConfig setUserCoinSingle:0];
    self.currentNumber = 0;
    self.totalNumber = [YunConfig getUserCoin];
    // 初始化关卡
    self.passNumber.text = [NSString stringWithFormat:@"%d",[YunConfig getUserPassNumber]];
    // 初始化目标
    self.targetCoin.text = [NSString stringWithFormat:@"%d",[YunConfig getUserTargetCoin]];
    // 用户得分
    [self.numberView showNumber:[YunConfig getUserCoin]];
    self.numberView.frame = CGRectMake((self.frame.size.width-[self.numberView getSize].width)/2, self.numberView.frame.origin.y, 0, 0);
    // 用户金币
    [self notificationGetCoin];
    // 红包提示倒计时
    //[self updateRedenvelope_time:0];
    [self clearToolAction];
}

// 游戏结束，保存数据
-(void)gameEndNotification:(NSNotification *)noti{
     //[YunConfig setUserCoin:self.totalNumber];
     //[YunConfig setUserCoinSingle:self.currentNumber];
}

// 获得金币
-(void)notificationGetCoin{
    _userGold.text = [NSString stringWithFormat:@"%d",[YunConfig getUserGold]];
    
}

// 获得红包
-(void)notificationGetRedEnvelope{
    _balanceLb.text = [NSString stringWithFormat:@"余额\n%.2f",[YunConfig getUserRedEnvelope]];
}

-(void)clickBomb:(UIButton*)button{
    [self.say touchButton];
    if ([YunConfig getUserBombAmount]<=0) {
        [[YunBuyToolStoreView sharedSingleton] show:1];
        button.transform = CGAffineTransformMakeScale(1, 1);
        [self clearToolAction];
        return;
    }
    _remarkLb.text = @"爆破：消除3x3范围内的星星";
    
    button.transform = CGAffineTransformMakeScale(1, 1);
    [self clearToolAction];
    [YunConfig setUserIsUseBomb:YES];
    [self toolButtonAnimation:button];
    
}
// 按炸弹
-(void)touchInBomb:(UIButton*)button{
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformScale(button.transform, 1.2, 1.2);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)clickRefresh:(UIButton*)button{
    
    if ([YunConfig getUserRefreshAmount]<=0) {
        [self.say touchButton];
        [[YunBuyToolStoreView sharedSingleton] show:0];
        button.transform = CGAffineTransformMakeScale(1, 1);
        [self clearToolAction];
        return;
    }
    _remarkLb.text = @"";
    [self.say say:@"lz_tool_bg_xuanzhuan.wav"];
    button.transform = CGAffineTransformMakeScale(1, 1);
    //button.transform = CGAffineTransformRotate(button.transform, 0);
    //[button.layer removeAllAnimations];
    [self clearToolAction];
    [YunConfig setUserIsUseRefresh:YES];
    
    // 游戏开始通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GameChangeAllButtonColor object:nil];
}
// 按刷新
-(void)touchInRefresh:(UIButton*)button{
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 2;
    [button.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformScale(button.transform, 1.2, 1.2);
        //button.transform = CGAffineTransformRotate(button.transform, M_PI);
    } completion:^(BOOL finished) {

    }];
    
    
}

-(void)clickMagic:(UIButton*)button{
    [self.say touchButton];
    if ([YunConfig getUserMagicAmount]<=0) {
        
        [[YunBuyToolStoreView sharedSingleton] show:2];
        button.transform = CGAffineTransformMakeScale(1, 1);
        [self clearToolAction];
        return;
    }
    _remarkLb.text = @"变色：改变一个星星的颜色";
    button.transform = CGAffineTransformMakeScale(1, 1);
    [self clearToolAction];
    [YunConfig setUserIsUseMagic:YES];
    
    [self toolButtonAnimation:button];
}
// 按刷子
-(void)touchInMagic:(UIButton*)button{
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformScale(button.transform, 1.2, 1.2);
    } completion:^(BOOL finished) {
        
    }];
}

// 点击空白处就取消所有工具功能
-(void)clearSpaceAction{
    _remarkLb.text = @"";
    
    [self clearToolAction];
}
-(void)clearToolAction{
    [_bombBt.layer removeAllAnimations];
    [_refreshBt.layer removeAllAnimations];
    [_magicBt.layer removeAllAnimations];
    [YunConfig setUserIsUseBomb:NO];
    [YunConfig setUserIsUseRefresh:NO];
    [YunConfig setUserIsUseMagic:NO];
    
    [self updateToolAmount];
    
}

-(void)updateToolAmount{
    int refresh_amount = [YunConfig getUserRefreshAmount];
    int bomb_amount = [YunConfig getUserBombAmount];
    int magic_amount = [YunConfig getUserMagicAmount];
    
    UIColor *color = UIColorFromRGB(0x78de73);
    
    [_refresh_num.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (refresh_amount<=0) {
        _refresh_num.image = [UIImage imageNamed:@"lz_tool_add_icon"];
    }else{
        UILabel *l = [[UILabel alloc] initWithFrame:_refresh_num.bounds];
        l.font = kFontBold(12);
        l.textColor = [UIColor whiteColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = color;
        l.layer.cornerRadius = l.frame.size.height/2;
        l.layer.masksToBounds = YES;
        l.text = [NSString stringWithFormat:@"%d",refresh_amount];
        l.adjustsFontSizeToFitWidth = YES;
        l.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
        l.layer.borderWidth = 1;
        [_refresh_num addSubview:l];
    }
    
    [_bomb_num.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (bomb_amount<=0) {
        _bomb_num.image = [UIImage imageNamed:@"lz_tool_add_icon"];
    }else{
        UILabel *l = [[UILabel alloc] initWithFrame:_bomb_num.bounds];
        l.font = kFontBold(12);
        l.textColor = [UIColor whiteColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = color;
        l.layer.cornerRadius = l.frame.size.height/2;
        l.layer.masksToBounds = YES;
        l.text = [NSString stringWithFormat:@"%d",bomb_amount];
        l.adjustsFontSizeToFitWidth = YES;
        l.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
        l.layer.borderWidth = 1;
        [_bomb_num addSubview:l];
    }
    
    [_magic_num.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (magic_amount<=0) {
        _magic_num.image = [UIImage imageNamed:@"lz_tool_add_icon"];
    }else{
        UILabel *l = [[UILabel alloc] initWithFrame:_magic_num.bounds];
        l.font = kFontBold(12);
        l.textColor = [UIColor whiteColor];
        l.textAlignment = NSTextAlignmentCenter;
        l.backgroundColor = color;
        l.layer.cornerRadius = l.frame.size.height/2;
        l.layer.masksToBounds = YES;
        l.text = [NSString stringWithFormat:@"%d",magic_amount];
        l.adjustsFontSizeToFitWidth = YES;
        l.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
        l.layer.borderWidth = 1;
        [_magic_num addSubview:l];
    }
    
}


-(void)clickPlayButton:(UIButton*)button{
    [self.say touchButton];
    [[YunPopstarPlayView sharedSingleton] show];
}

-(void)clickBackPlayButton:(UIButton*)button{
    [self.say touchButton];
    [MobClick beginEvent:@"home_play"];
    YunPlayPopStarViewController *play = [[YunPlayPopStarViewController alloc] init];
    [(UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController pushViewController:play animated:YES];
    [MobClick endEvent:@"home_play"];
}

-(void)clickRedEnvelopeButton:(UIButton*)button{
    [MobClick beginEvent:@"enchashment_redenvelope_click"];
    [self.say touchButton];
    [[YunRedEnvelopeView sharedSingleton] show];
    [MobClick endEvent:@"enchashment_redenvelope_click"];
}

-(void)clickFaceButton:(UIButton*)button{
    [self.say touchButton];
    YunMeViewController *me = [[YunMeViewController alloc] init];
    UINavigationController *nav = (UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController;
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];//将title 文字的颜色改为透明
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0)forBarMetrics:UIBarMetricsDefault];
    [nav pushViewController:me animated:YES];
}

-(void)clickMyGold{
    if ([YunConfig getUserIsOpenRedEnvelope]) {
        [MobClick beginEvent:@"enchashment_gold_click"];
        [self.say touchButton];
        YunEnchashmentViewController *enchashment = [[YunEnchashmentViewController alloc] initWithType:0];
        [(UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController pushViewController:enchashment animated:YES];
        [MobClick endEvent:@"enchashment_gold_click"];
    }
    
}

-(void)toolButtonAnimation:(UIButton*)bt{
    [bt.layer removeAllAnimations];
    //创建一个关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置关键帧
    keyAnimation.values = @[@(-M_PI_4 * 0.3 * 1), @(M_PI_4 * 0.3 * 1), @(-M_PI_4 * 0.3 * 1)];
    //设置重复
    keyAnimation.duration=0.2;      //执行时间
    keyAnimation.repeatCount = NSNotFound;
    keyAnimation.autoreverses= YES;    //完成动画后会回到执行动画之前的状态
    [bt.layer addAnimation:keyAnimation forKey:@"toolbutton_rotationAnimation"];
}

-(void)startRedEnvelopeAnimation:(UIButton*)bt{
    [bt.layer removeAllAnimations];
    //创建一个关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置关键帧
    keyAnimation.values = @[@(-M_PI_4 * 0.1 * 1), @(M_PI_4 * 0.1 * 1), @(-M_PI_4 * 0.1 * 1)];
    //设置重复
    keyAnimation.duration=1.1;      //执行时间
    keyAnimation.repeatCount = NSNotFound;
    keyAnimation.autoreverses= YES;    //完成动画后会回到执行动画之前的状态
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.removedOnCompletion = NO;
    [bt.layer addAnimation:keyAnimation forKey:@"redenvelope_rotationAnimation"];
    WEAKSELF
    [fn sleepSeconds:10 finishBlock:^{
        [__weakSelf startRedEnvelopeAnimation:bt];
    }];
}
// 红包提示，消灭一颗星星减少一个
-(void)updateRedenvelope_time:(int)num{
    // 如果用户屏蔽红包或者红包开关未打开就隐藏
    if ([YunConfig getUserShieldRedEnvelope] || ![YunConfig getUserIsOpenRedEnvelope]) {
        _balanceLb.superview.hidden = YES;
        _redenvelope_time.hidden = YES;
    }else{
        _balanceLb.superview.hidden = NO;
        _redenvelope_time.hidden = NO;
//        if (_redenvelope_num<=0) {
//            num = 0;
//        }
    }
    YunConfig *config = [YunConfig getConfig];
    if (config && [YunConfig getUserIsOpenRedEnvelope] && ![YunConfig getUserShieldRedEnvelope]) {
        if (num==0) {
            // 读取配置
            int levels = [YunConfig getUserPassNumber];
            NSDictionary *pass_open_redenvelope = [config.pass_open_redenvelope mj_JSONObject];
            int rv = 0;
            if (pass_open_redenvelope) {
                int maxkey = 0;
                for (NSString *key in pass_open_redenvelope.allKeys) {
                    int k = [key intValue];
                    if (levels>=k && k>=maxkey) {
                        maxkey = k;
                        rv = [pass_open_redenvelope[key] intValue];
                    }
                }
            }
            // 初始化
            int n = 10 + arc4random() % 60;
            n = (n/10) * 10;
            n += rv*100;
            [YunConfig seting:kConfig_User_clearance_redenvelope_time value:@(n).stringValue];
            _redenvelope_num = n;
            //[_redenvelope_time setTitle:@(n).stringValue forState:UIControlStateNormal];
            _redenvelope_time.hidden = NO;
            _redenvelope_time.progress = 0;
            _redenvelope_time_lb.text = @"0.00%";
            //_redenvelope_time.titleLabel.font = kFontBold(12);
            //[_redenvelope_time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //_redenvelope_time.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
            //_redenvelope_time.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
            //[self setupExplosion];
        }else{
            if (_redenvelope_num<=0) {
                return;
            }
            int total = [[YunConfig get:kConfig_User_clearance_redenvelope_time] intValue];
            _redenvelope_num -= num;
            // 占比
            float bi = 1.0-floorf(_redenvelope_num) / floorf(total);
            if (bi<=0) {
                bi = 0;
            }
            _redenvelope_time.progress = bi;
            _redenvelope_time_lb.text = [NSString stringWithFormat:@"%.1f%%",bi*100];
            //[_redenvelope_time setTitle:@(_redenvelope_num).stringValue forState:UIControlStateNormal];
            if (_redenvelope_num<=0) {
                _redenvelope_time_lb.text = @"已激活";
                //[_redenvelope_time setTitle:@"已激活" forState:UIControlStateNormal];
                //_redenvelope_time.titleLabel.font = kFont(8);
                //_redenvelope_time.backgroundColor = UIColorFromRGB(0xec5254);
                //_redenvelope_time.layer.borderColor = [UIColorFromRGB(0xec5254) colorWithAlphaComponent:0.8].CGColor;
                WEAKSELF
                
                [fn sleepSeconds:5 finishBlock:^{
                    __weakSelf.redenvelope_time.hidden = YES;
                }];
                [self setupExplosion:10];
                // 红包激活通知
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_RedEnvelope_Active object:nil];
                // 结束倒计时并显示红包
                if (self.redenvelopeTimeBlock) {
                    self.redenvelopeTimeBlock(YES);
                }
            }else{
               //[self setupExplosion:1];
            }
            //WEAKSELF
//            [UIView animateWithDuration:0.8 animations:^{
//                __weakSelf.redenvelope_time.alpha = 0.3;
//                [UIView animateWithDuration:0.8 animations:^{
//                    __weakSelf.redenvelope_time.alpha = 1;
//                }];
//            }];
        }
    }
    
}

// 通关失败，红包激活进程要回退
-(void)passFail:(NSNotification *)noti{
    //使用object处理消息
    NSNumber *info = [noti object];
    NSLog(@"通关失败回退：%@",info);
    [self updateRedenvelope_time:-[info intValue]];
}

- (void)setupExplosion:(int)num{
    
    // 爆炸
    CAEmitterCell * explodeCell = [CAEmitterCell emitterCell];
    explodeCell.name = @"explodeCell";
    explodeCell.contents = (id)[[UIImage imageNamed:@"lz_star"] CGImage];
    //explodeCell.birthRate = 1.f;
    explodeCell.lifetime = 0.1f;
    explodeCell.velocity = 0.f;
    explodeCell.scale = 0.3;
    explodeCell.redSpeed = -1.5;  //爆炸的时候变化颜色
    explodeCell.blueRange = 1.5; //爆炸的时候变化颜色
    explodeCell.greenRange = 1.f; //爆炸的时候变化颜色
    
    // 火花
    CAEmitterCell * sparkCell = [CAEmitterCell emitterCell];
    sparkCell.name = @"sparkCell";
    
    sparkCell.birthRate = 600.f;
    sparkCell.lifetime = 3.1f;
    sparkCell.velocity = 125.f;
    sparkCell.velocityRange = 500.f;
    sparkCell.yAcceleration = 175.f;  // 模拟重力影响
    sparkCell.emissionRange = M_PI * 2;  // 360度
    
    sparkCell.scale = 0.5f;
    sparkCell.contents = (id)[[UIImage imageNamed:@"lz_star"] CGImage];
    sparkCell.redSpeed = 0.4;
    sparkCell.greenSpeed = -0.1;
    sparkCell.blueSpeed = -0.1;
    sparkCell.alphaSpeed = -0.25;
    
    sparkCell.spin = M_PI * 2; // 自转
    
    
    
    

    // 2.发射源
    CAEmitterLayer * explosionLayer = [CAEmitterLayer layer];
    
    [self.layer addSublayer:explosionLayer];
    //开启三维效果
    //explosionLayer.preservesDepth = true;
    //发射源的尺寸大小
    //explosionLayer.emitterSize = _redenvelope_time.frame.size;
    explosionLayer.emitterPosition = CGPointMake(_redenvelope_time.frame.origin.x+_redenvelope_time.frame.size.width/2, _redenvelope_time.frame.origin.y+_redenvelope_time.frame.size.height/2);
    //发射源的形状
    explosionLayer.emitterShape = kCAEmitterLayerLine;
    //发射模式
    explosionLayer.emitterMode = kCAEmitterLayerOutline;
    //渲染模式
    explosionLayer.renderMode = kCAEmitterLayerAdditive;
    explosionLayer.repeatCount = 1;
    
    //添加动画
    explosionLayer.emitterCells = @[explodeCell];
    explodeCell.emitterCells = @[sparkCell];
    //explosionCell.emitterCells = @[sparkCell];
    self.explosionLayer = explosionLayer;
    
    [self startAnimation:num];
}

/**
 * 开始动画
 */
- (void)startAnimation:(int)num{
    [self.say peng];
    WEAKSELF
    [fn sleepSeconds:0.5 finishBlock:^{
        
        [__weakSelf.say say:@"hongbaoyijihuo.mp3"];
    }];
    
    // 用KVC设置颗粒个数
    [self.explosionLayer setValue:@(num) forKeyPath:@"emitterCells.explodeCell.birthRate"];
    
    // 开始动画
    self.explosionLayer.beginTime = CACurrentMediaTime();
    
    // 延迟停止动画
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.1];
    //[self borderDefault];
}

/**
 * 动画结束
 */
- (void)stopAnimation{
    // 用KVC设置颗粒个数
    [self.explosionLayer setValue:@0 forKeyPath:@"emitterCells.explodeCell.birthRate"];
    //[self.explosionLayer removeAllAnimations];
    //[self performSelector:@selector(clearSelf) withObject:nil afterDelay:0.15];

}
@end
