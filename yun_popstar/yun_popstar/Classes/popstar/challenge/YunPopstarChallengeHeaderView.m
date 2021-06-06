//
//  YunPopstarChallengeHeaderView.m
//  yun_popstar
//
//  Created by dangfm on 2020/10/4.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPopstarChallengeHeaderView.h"

@implementation YunPopstarChallengeHeaderView

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
-(instancetype)initWithFrame:(CGRect)frame isChallenge:(BOOL)isChallenge challenger:(NSDictionary*)challenger{
    if([super initWithFrame:frame]){
        _challenger = [fn checkNullWithDictionary:challenger];;
        _isChallenge = isChallenge;
        [self initToolAmount];
        [self initSay];
        [self initView];
        [[YunChallengeReadyGo sharedSingleton] show:challenger];
        WEAKSELF
        [YunChallengeReadyGo sharedSingleton].hideBlock = ^(){
            // 游戏开始通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_ChallengeStartPlay object:nil];
            [__weakSelf setupExplosion:10];
            [fn sleepSeconds:1.0 finishBlock:^{
                [__weakSelf countdown_start];
            }];
            
        };
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
    
    // 被挑战者
    NSString *face = _challenger[@"face"];
    NSString *title = [NSString stringWithFormat:@"%@",_challenger[@"nick_name"]];
    NSString *status = [NSString stringWithFormat:@"被挑战第%@关卡",_challenger[@"levels"]];
    
    _face = [[UIImageView alloc] initWithFrame:CGRectMake(x, y+6, 35, 35)];
    [_face setImage:[UIImage imageNamed:@"logo180"]];
    _face.layer.cornerRadius = _face.frame.size.height/2;
    _face.layer.masksToBounds = YES;
    [self addSubview:_face];
    
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(x+35+5, y+6, w-2*x-40, 17)];
    _titleLb.font = kFontBold(14);
    _titleLb.textColor = [UIColor whiteColor];
    _titleLb.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_titleLb];
    
    _statusLb = [[UILabel alloc] initWithFrame:CGRectMake(x+35+5, y+6+17+5, w-2*x-40, 13)];
    _statusLb.font = kFont(12);
    _statusLb.textColor = FMGreyColor;
    _statusLb.textAlignment = NSTextAlignmentLeft;
    _statusLb.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_statusLb];

    _titleLb.text = title;
    _statusLb.text = status;
    [_face sd_setImageWithURL:[NSURL URLWithString:face] placeholderImage:[UIImage imageNamed:@"logo180"]];
    
    // 我
    _meface = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-5-35, y+6, 35, 35)];
    [_meface setImage:[UIImage imageNamed:@"logo180"]];
    _meface.layer.cornerRadius = _meface.frame.size.height/2;
    _meface.layer.masksToBounds = YES;
    [self addSubview:_meface];
    
    _metitleLb = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth-w, y+6, w-x-40, 17)];
    _metitleLb.font = kFontBold(14);
    _metitleLb.textColor = [UIColor whiteColor];
    _metitleLb.adjustsFontSizeToFitWidth = YES;
    _metitleLb.textAlignment = NSTextAlignmentRight;
    [self addSubview:_metitleLb];
    
    
    _mestatusLb = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenWidth-w, y+6+17+5, w-x-40, 13)];
    _mestatusLb.font = kFont(12);
    _mestatusLb.textColor = FMGreyColor;
    _mestatusLb.textAlignment = NSTextAlignmentRight;
    _mestatusLb.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_mestatusLb];
    

    _metitleLb.text = [YunConfig getUserNickName];
    _mestatusLb.text = @"我是挑战者";
    [_meface sd_setImageWithURL:[NSURL URLWithString:[YunConfig getUserFace]] placeholderImage:[UIImage imageNamed:@"logo180"]];
    
    
    // 倒计时
    _countdownLb = [[UILabel alloc] initWithFrame:CGRectMake(0, y, UIScreenWidth, 50)];
    _countdownLb.font = kFontBold(40);
    _countdownLb.textAlignment = NSTextAlignmentCenter;
    _countdownLb.textColor = [UIColor whiteColor];
    _countdownLb.text = [NSString stringWithFormat:@"%.f",[_challenger[@"milliseconds"] floatValue]/1000];
    //[_countdownLb sizeToFit];
    [self addSubview:_countdownLb];
    UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, y+50, UIScreenWidth, 15)];
    tip.font = kFont(12);
    tip.textColor = [UIColor whiteColor];
    tip.text = @"倒计时(秒)";
    tip.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tip];
    
    LDProgressView *progressView=[[LDProgressView alloc]initWithFrame:CGRectMake((UIScreenWidth-300)/2, y+h+20+25, 300, 25)];
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
    _redenvelope_time_lb.font = kFontBold(12);
    _redenvelope_time_lb.textAlignment = NSTextAlignmentCenter;
    _redenvelope_time_lb.textColor = [UIColor whiteColor];
    [_redenvelope_time addSubview:_redenvelope_time_lb];
    
    
    // 播放按钮
    UIButton *playbt = [[UIButton alloc] init];
    UIImage *image = [UIImage imageNamed:@"lz_play_icon"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [playbt setImage:image forState:UIControlStateNormal] ;
    [playbt setTintColor:[UIColor whiteColor]];
    playbt.frame = CGRectMake(self.frame.size.width-5-h-5, y+h+39, h+5, image.size.height/image.size.width * (h+5));
    [playbt addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    //playbt.alpha = 0.8;
    [self addSubview:playbt];
    
    UIImageView *playbt_megic_bg = [[UIImageView alloc] initWithFrame:CGRectMake(playbt.frame.origin.x-1, playbt.frame.origin.y-1, playbt.frame.size.width+2, playbt.frame.size.height+2)];
    playbt_megic_bg.image = [UIImage imageNamed:@"megic_tool_bg"];
    [self addSubview:playbt_megic_bg];
    
    // 回放按钮
    UIImage *backplayimage = [UIImage imageNamed:@"back_play_icon"];
    backplayimage = [UIImage scaleToSize:backplayimage size:CGSizeMake(backplayimage.size.width/backplayimage.size.height * 35, 35)];
    UIButton *backplaybt = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-5-h-5, playbt.frame.size.height + playbt.frame.origin.y+ 10, backplayimage.size.width/backplayimage.size.height * 35,35)];
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
    y += 10;
    
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
    // 挑战开始
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(challengePlayStartNotification:) name:kNSNotificationName_ChallengeStartPlay object:nil];
    // 游戏结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameOverNotification) name:kNSNotificationName_GameOver object:nil];
    // 工具完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolFinished:) name:kNSNotificationName_ToolFinished object:nil];
    
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
 
}
// 用了多少个道具
-(void)initToolAmount{
    NSArray *cmds = [_challenger[@"cmds"] mj_JSONObject];
    if (cmds) {
        for (NSDictionary*item in cmds) {
            NSString *name = item[@"name"];
            if ([name isEqualToString:@"bomb"]) {
                _totalBomb ++;
            }
            if ([name isEqualToString:@"refresh"]) {
                _totalRefresh ++;
            }
            if ([name isEqualToString:@"magic"]) {
                _totalMagic ++;
            }
        }
    }
}

-(void)clickBomb:(UIButton*)button{
    [self.say touchButton];
    if (_totalBomb>0) {
       _remarkLb.text = @"爆破：消除3x3范围内的星星";
       button.transform = CGAffineTransformMakeScale(1, 1);
       [self clearToolAction];
       [YunConfig setUserIsUseBomb:YES];
       [self toolButtonAnimation:button];
    }else{
        _remarkLb.text = @"";
        button.transform = CGAffineTransformMakeScale(1, 1);
        [self clearToolAction];
    }
}
// 按炸弹
-(void)touchInBomb:(UIButton*)button{
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformScale(button.transform, 1.2, 1.2);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)clickRefresh:(UIButton*)button{
    if (_totalRefresh>0) {
        _remarkLb.text = @"";
        [self.say say:@"lz_tool_bg_xuanzhuan.wav"];
        button.transform = CGAffineTransformMakeScale(1, 1);
        //button.transform = CGAffineTransformRotate(button.transform, 0);
        //[button.layer removeAllAnimations];
        [self clearToolAction];
        [YunConfig setUserIsUseRefresh:YES];
        
        // 游戏开始通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GameChangeAllButtonColor object:nil];
    }else{
        _remarkLb.text = @"";
        button.transform = CGAffineTransformMakeScale(1, 1);
        [self clearToolAction];
    }
    
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
    if (_totalMagic>0) {
        _remarkLb.text = @"变色：改变一个星星的颜色";
        button.transform = CGAffineTransformMakeScale(1, 1);
        [self clearToolAction];
        [YunConfig setUserIsUseMagic:YES];
        [self toolButtonAnimation:button];
    }else{
        _remarkLb.text = @"";
        button.transform = CGAffineTransformMakeScale(1, 1);
        [self clearToolAction];
    }
    
}
// 按刷子
-(void)touchInMagic:(UIButton*)button{
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformScale(button.transform, 1.2, 1.2);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)toolFinished:(NSNotification*)noti{
    NSObject *type = noti.object;
    if ([type isEqual:@"0"]) {
        // 刷新减1
        _totalRefresh --;
    }
    if ([type isEqual:@"1"]) {
        // 爆炸减1
        _totalBomb --;
    }
    if ([type isEqual:@"2"]) {
        // 魔术笔减1
        _totalMagic --;
    }
    [self clearSpaceAction];
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
    int refresh_amount = _totalRefresh;
    int bomb_amount = _totalBomb;
    int magic_amount = _totalMagic;
    
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
    [[YunPopstarPlayView sharedSingleton] showChallenge];
}

-(void)clickBackPlayButton:(UIButton*)button{
    [self.say touchButton];
    [MobClick beginEvent:@"home_play"];
    YunPlayPopStarViewController *play = [[YunPlayPopStarViewController alloc] init];
    [(UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController pushViewController:play animated:YES];
    [MobClick endEvent:@"home_play"];
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
    if (num==0) {
        // 初始化
        int n = [_challenger[@"pop_num"] intValue];
        //[YunConfig seting:kConfig_User_clearance_redenvelope_time value:@(n).stringValue];
        _redenvelope_num = n;
        //[_redenvelope_time setTitle:@(n).stringValue forState:UIControlStateNormal];
        _redenvelope_time.hidden = NO;
        _redenvelope_time.progress = 0;
        _redenvelope_time_lb.text = [NSString stringWithFormat:@"消除%d颗星星",_redenvelope_num];
        //_redenvelope_time.titleLabel.font = kFontBold(12);
        //[_redenvelope_time setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //_redenvelope_time.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8].CGColor;
        //_redenvelope_time.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        //[self setupExplosion];
    }else{
        if (_redenvelope_num<=0) {
            return;
        }
        int total = 100;
        _redenvelope_num -= num;
        // 占比
        float bi = 1.0-floorf(_redenvelope_num) / floorf(total);
        if (bi<=0) {
            bi = 0;
        }
        _redenvelope_time.progress = bi;
        _redenvelope_time_lb.text = [NSString stringWithFormat:@"剩余%d颗星星",_redenvelope_num];
        //[_redenvelope_time setTitle:@(_redenvelope_num).stringValue forState:UIControlStateNormal];
        if (_redenvelope_num<=0) {
            _redenvelope_time_lb.text = @"消除完毕";
            //[_redenvelope_time setTitle:@"已激活" forState:UIControlStateNormal];
            //_redenvelope_time.titleLabel.font = kFont(8);
            //_redenvelope_time.backgroundColor = UIColorFromRGB(0xec5254);
            //_redenvelope_time.layer.borderColor = [UIColorFromRGB(0xec5254) colorWithAlphaComponent:0.8].CGColor;
//            WEAKSELF
//
//            [fn sleepSeconds:5 finishBlock:^{
//                __weakSelf.redenvelope_time.hidden = YES;
//            }];
            [self setupExplosion:10];
            // 红包激活通知
            //[[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_RedEnvelope_Active object:nil];
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
-(void)gameOverNotification{
    _gameOver = YES;
}
-(void)challengePlayStartNotification:(NSNotification*)noti{
    _gameOver = NO;
}
// 启动倒计时
-(void)countdown_start{
    if (_gameOver) {
        return;
    }
    float v = [_countdownLb.text floatValue];
    v -= 1;
    _countdownLb.text = [NSString stringWithFormat:@"%.f",v];
    if (v<=0) {
        // 倒计时结束
        _countdownLb.text = @"0.00";
        
        // 红包激活通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_ChallengeEndPlay object:nil];
        
    }else{
        WEAKSELF
        [fn sleepSeconds:1.0 finishBlock:^{
            [__weakSelf countdown_start];
        }];
    }
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
//    [fn sleepSeconds:0.5 finishBlock:^{
//
//        [__weakSelf.say say:@"hongbaoyijihuo.mp3"];
//    }];
    
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
