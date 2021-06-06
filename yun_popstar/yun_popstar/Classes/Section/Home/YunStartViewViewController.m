//
//  YunStartViewViewController.m
//  yun_popstar
//
//  Created by dangfm on 2020/8/20.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunStartViewViewController.h"
#import "YunHomeViewController.h"
#import "YunPlayPopStarViewController.h"
//#define kStartHomeTools @[@{@"title":@"排行",@"icon":@"home_icon_leaderboard",@"push":@"leaderboard"},@{@"title":@"任务",@"icon":@"home_icon_task",@"push":@"task"},@{@"title":@"免费奖励",@"icon":@"home_icon_freead",@"push":@"freead"},@{@"title":@"收徒赚钱",@"icon":@"home_icon_apprentice",@"push":@"apprentice"}]

//#define kStartHomeTools @[@{@"title":@"任务",@"icon":@"home_icon_task",@"push":@"task"},@{@"title":@"免费奖励",@"icon":@"home_icon_freead",@"push":@"freead"}]

@interface YunStartViewViewController ()

@end

@implementation YunStartViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    [self applicationEnterForeground];
    _startButton.enabled = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    //[self applicationDidEnterBackground];
    
}

-(void)applicationEnterForeground{
    [self createBgViews];
    //[self startButtonAnimation];
    //[self startLogoAnimation];
    //[self startLightingAnimation];
    //[self startLightingAnimation_2];
    [self notificationGetCoin];
    if ([self.navigationController.visibleViewController isEqual:self]) {
        [self.say playBackgroundMusic];
    }
    
    [self getHttpShortCut];
    [self updateCanGetRedenvelope];
    
    // 左右摆动动画
    [self startBlackBoardAnimation];
    [self getHttpBlackBoard];
    
}

-(void)applicationDidEnterBackground{
    [self.say stop];
}

- (void)initView{
    //[YunConfig setUserGold:100000];
    //[self showprivacy];
    if (![YunConfig isAgreePrivacy]) {
        // 隐私条款
        [self showprivacy];
    }else{
        [self showversion];
    }
    [self initSay];
    [self initBackgroundView];
    [self createBgViews];
    [self initHeaderView];
    [self createHomeLogoView];
    [self createLightingView];
   
    [self createStartButtonView];
    //[self createCommunityButtonView];
    [self getHttpShortCut];
    [self updateCanGetRedenvelope];
    
    [self startLightingAnimation];
    [self startLightingAnimation_2];
    [self startLogoAnimation];
    [self startButtonAnimation];
    [self createBlackBoard];
    
    // 进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:kNSNotificationName_applicationWillEnterForeground object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:kNSNotificationName_applicationDidEnterBackground object:nil];
    
    // 获得金币
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationGetCoin) name:kNSNotificationName_GetCoin object:nil];
    
    // 登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationUserLoginSuccess) name:kNSNotificationName_UserLoginSuccess object:nil];
    // 配置成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getConfigSuccess) name:kNSNotificationName_GetConfigSuccess object:nil];
    // 推送成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSuccess:) name:kNSNotificationName_PushSuccess object:nil];
  
}

-(void)pushSuccess:(NSNotification*)noti{
    NSString *content_type = noti.object;
    if ([content_type isEqualToString:@"blackboard"]) {
        [self showBlackBoard:nil];
    }
}

-(void)showprivacy{

    NSString *title = @"温馨提示";
    NSString *message = @"感谢使用恋上消消消APP!在您使用时，需要连接数据网络或WLAN网络，产生的流量费用请咨询当地运营商。我们非常重视您的隐私保护，在您使用恋上消消消服务前，请您仔细阅读、充分理解《用户服务协议》、《隐私政策》的各项条款。您点击“同意并继续”视为您已同意上述协议的全部内容。";
    
    NSMutableAttributedString *msg = [[NSMutableAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName:kFont(18),NSForegroundColorAttributeName:FMGreyColor}];
    
    NSMutableParagraphStyle *
    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 10;//增加行高
    //style.headIndent = 10;//头部缩进，相当于左padding
    //style.tailIndent = -10;//相当于右padding
    //style.lineHeightMultiple = 1.5;//行间距是多少倍
    style.alignment = NSTextAlignmentJustified;//对齐方式
    //style.firstLineHeadIndent = 20;//首行头缩进
    //style.paragraphSpacing = 10;//段落后面的间距
    //style.paragraphSpacingBefore = 20;//段落之前的间距
    [msg addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, msg.length)];
    
    [msg addAttribute:NSLinkAttributeName
                                value:kAPI_Xieyi
                                range:[[msg string] rangeOfString:@"《用户服务协议》"]];
    [msg addAttribute:NSLinkAttributeName
                                value:kAPI_ProcyTip
                                range:[[msg string] rangeOfString:@"《隐私政策》"]];
    [msg addAttribute:NSForegroundColorAttributeName
                                value:FMBlueColor
                                range:[[msg string] rangeOfString:@"《用户服务协议》"]];
    [msg addAttribute:NSForegroundColorAttributeName
                                value:FMBlueColor
                                range:[[msg string] rangeOfString:@"《隐私政策》"]];
  

    IBConfigration *configration = [[IBConfigration alloc] init];
    configration.title = title;
    configration.message = msg;
    configration.cancelTitle = @"退出";
    configration.confirmTitle = @"同意并继续";
    configration.tintColor = [UIColor redColor];
    configration.messageAlignment = NSTextAlignmentLeft;
    WEAKSELF
    IBAlertView *alerView = [IBAlertView alertWithConfigration:configration block:^(NSUInteger index,NSString * url) {
        [__weakSelf.say touchButton];
        if (index==-1) {
            NSLog(@"%@",url);
            [[YunWebView sharedSingleton] show:url];
        }
        if (index==1) {
            exit(0);//是正常退出;
        }
        if (index == 2) {
            NSLog(@"点击确定了");
            [YunConfig setAgreePrivacy:YES];
        }
    }];
    [alerView show];
}

-(void)showversion{
    NSDictionary *versioninfo = [[YunConfig getConfig].ios_app_version mj_JSONObject];
    versioninfo = [fn checkNullWithDictionary:versioninfo];
    NSString *v = versioninfo[@"v"];
    v = [v replaceAll:@"." target:@""];
    if(v.length<=2){
        v = [v append:@"0"];
    }
    NSString *version = [fn getVersion];
    version = [version replaceAll:@"." target:@""];
    if(version.length<=2){
        version = [version append:@"0"];
    }
    NSString *title = @"版本更新";
    NSString *message = versioninfo[@"intro"];
    int ispop = [versioninfo[@"ispop"] intValue];// 是否强制弹出下载
    // 版本不一致就弹出升级提示
    if ([v intValue]>[version intValue]) {
        NSMutableAttributedString *msg = [[NSMutableAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName:kFont(18),NSForegroundColorAttributeName:FMGreyColor}];
         
         NSMutableParagraphStyle *
         style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
         style.lineSpacing = 10;//增加行高
         style.alignment = NSTextAlignmentJustified;//对齐方式
         [msg addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, msg.length)];
        
         IBConfigration *configration = [[IBConfigration alloc] init];
         configration.title = title;
         configration.message = msg;
         configration.cancelTitle = @"跳过";
         configration.confirmTitle = @"更新";
         configration.tintColor = [UIColor redColor];
         configration.messageAlignment = NSTextAlignmentLeft;
//        if (ispop) {
//            configration.cancelTitle = @"";
//        }
         WEAKSELF
         IBAlertView *alerView = [IBAlertView alertWithConfigration:configration block:^(NSUInteger index,NSString * url) {
             [__weakSelf.say touchButton];
             if (index==-1) {
                 NSLog(@"%@",url);
                 
             }
             if (index==1) {
                 // 跳过
             }
             if (index == 2) {
                 // 确定安装更新
                 NSString *itunesurl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@",kAppStore_Id];
                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl] options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success) {
                      
                  }];
             }
         }];
         [alerView show];
    }
    
    
}

-(void)showEverydaySignView{
    if ([YunConfig isAgreePrivacy]) {
        if ([YunConfig getUserFirstGold]>0) {
            //WEAKSELF
            [http sendPostRequestWithParams:nil api:kAPI_Users_SignList start:^{
                //[SVProgressHUD show];
            } failure:^{
                //[SVProgressHUD showErrorWithStatus:@"签到历史获取失败，网络不给力"];
            } success:^(NSDictionary *dic) {
                //[SVProgressHUD dismiss];
                int code = [dic[@"code"] intValue];
                if (code==200) {
                    // 已签到数据
                    NSArray *list = dic[@"data"];
                    NSMutableArray *dates = [NSMutableArray new];
                    for (NSDictionary*item in list) {
                        NSString *created_at = item[@"created_at"];
                        created_at = [created_at substringToIndex:10];
                        if ([dates indexOfObject:created_at]==NSNotFound) {
                            [dates addObject:created_at];
                        }
                        
                    }
//                    if (dates.count>=7) {
//                        [dates removeAllObjects];
//                    }
                    [YunConfig seting:kConfig_User_EverydaySign value:[dates mj_JSONString]];
                    // 已签到数据
                    // 如果当天没有签到就弹出签到页面
                    NSMutableArray *signeds = [YunConfig getUserEverydaySign];
                    NSString *today = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
                    BOOL hasday = NO;
                    for (NSString*date in signeds) {
                        if ([date isEqualToString:today]) {
                            hasday = YES;
                        }
                    }
                    if (!hasday) {
                        [[EverydaySignInView sharedSingleton] show];
                    }
                    
                }else{
                    FMHttpShowError(dic)
                    //[__weakSelf hide];
                }
            }];
            
            
          
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

-(void)initHeaderView{
    if (!self.headerView) {
        float h = 200;
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h)];
        self.headerView.backgroundColor = [UIColor clearColor];
        float x = 20;
        float y = 22;
        float w = (UIScreenWidth - 20) / 3;
        if (w<120) {
            w = 120;
        }
        UIFont *font = kFontBold(14);
        float add_w = 25;
        h = 30;
        if (iPhoneX || iPhoneXsMax || iPhoneXR) {
            y = 44;
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
        [bt addTarget:self action:@selector(clickMyGoldAtion) forControlEvents:UIControlEventTouchUpInside];

        //bt.alpha = 0.8;
        [self.headerView addSubview:bt];
        
        UILabel *jb_title = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 40, h-4)];
        jb_title.text = @"金币";
        jb_title.textColor = UIColorFromRGB(0x5832b9);//[UIColor colorWithPatternImage:[UIImage imageNamed:[YunConfig getUserBackgroundImageName]]];
        jb_title.font = [UIFont systemFontOfSize:12 weight:200];;
        jb_title.textAlignment = NSTextAlignmentCenter;
        jb_title.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        jb_title.layer.cornerRadius = h/2-2;
        jb_title.layer.masksToBounds = YES;
        [bt addSubview:jb_title];

        
        UILabel *xx = [[UILabel alloc] initWithFrame:CGRectMake(jb_title.frame.size.width+5, 0, w-jb_title.frame.size.width-add_w-10, h)];
        xx.text = @"0";
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
        [self.headerView addSubview:xx_add];
        
        
        // 播放按钮
        UIButton *playbt = [[UIButton alloc] init];
        UIImage *image = [UIImage imageNamed:@"lz_play_icon"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [playbt setImage:image forState:UIControlStateNormal] ;
        [playbt setTintColor:[UIColor whiteColor]];
        float pw = 44;
        playbt.frame = CGRectMake(UIScreenWidth-15-pw, y-5, pw, image.size.height/image.size.width * (pw));
        [playbt addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        //playbt.alpha = 0.8;
        [self.headerView addSubview:playbt];
        
        UIImageView *playbt_megic_bg = [[UIImageView alloc] initWithFrame:CGRectMake(playbt.frame.origin.x-1, playbt.frame.origin.y-1, playbt.frame.size.width+2, playbt.frame.size.height+2)];
        playbt_megic_bg.image = [UIImage imageNamed:@"megic_tool_bg"];
        [self.headerView addSubview:playbt_megic_bg];
        
        // 分享按钮
        UIButton *share = [[UIButton alloc] initWithFrame:CGRectMake(playbt.frame.origin.x+3, playbt.frame.origin.y+playbt.frame.size.height + 15, pw, pw)];
        [share setImage:[UIImage imageNamed:@"share-icon"] forState:UIControlStateNormal];
        [share addTarget:self action:@selector(shareImageAndTextToPlatformType) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:share];
        
        
        [self.view addSubview:self.headerView];
    }
    [self notificationGetCoin];
}

// 获得金币
-(void)notificationGetCoin{
    _userGold.text = [NSString stringWithFormat:@"%d",[YunConfig getUserGold]];
}

-(void)clickMyGoldAtion{
    //[[YunBuyToolStoreView sharedSingleton] show];
}

-(void)createHomeLogoView{
    if (!self.logoView) {
        UIImage *home_logo = [UIImage imageNamed:@"star_logo_3"];
        float x = 10;
        float y = kStatusBarHeight + 1.5*kNavigationHeight;
        float w = UIScreenWidth - 2*x;
        float h = home_logo.size.height/home_logo.size.width * w;
        self.logoView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.logoView.image = home_logo;
        //self.backgroundView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.logoView];
        [self.view bringSubviewToFront:self.headerView];
//        MCSteamView *steamView = [[MCSteamView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, y+h)];
//        [self.view addSubview:steamView];
        
    }
    
}

-(void)createLightingView{
    if (!self.lightingView) {
        UIImage *lighting = [UIImage imageNamed:@"flash_light"];
        float x = 10;
        float y = self.logoView.frame.origin.y-20;
        float w = UIScreenWidth/3*2;
        float h = lighting.size.height/lighting.size.width * w;
        self.lightingView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.lightingView.image = lighting;
        //self.backgroundView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.lightingView];
    }
    
    if (!self.lightingView_2) {
        UIImage *lighting = [UIImage imageNamed:@"flash_light"];
        float x = 130;
        float y = self.logoView.frame.origin.y-100;
        float w = UIScreenWidth/4*3;
        float h = lighting.size.height/lighting.size.width * w;
        self.lightingView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.lightingView_2.image = lighting;
        //self.backgroundView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.lightingView_2];
    }
    
    
}

-(void)createStartButtonView{
    if (!self.startButton) {
        UIImage *home_logo = [UIImage imageNamed:@"home_button_bg"];
        float x = UIScreenWidth/4;
        float w = UIScreenWidth/2;
        float h = home_logo.size.height/home_logo.size.width * w;
        float y = UIScreenHeight-kTabBarNavigationHeight - h;
        self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [self.startButton setBackgroundImage:home_logo forState:UIControlStateNormal];
        [self.startButton addTarget:self action:@selector(clickStartButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.startButton];
    }
}

-(void)createCommunityButtonView{
    YunConfig *config = [YunConfig getConfig];
    if (config.community_challenge_is_open) {
        NSArray *vs = [config.community_challenge_is_open mj_JSONObject];
        if ([vs indexOfObject:[fn getVersion]]!=NSNotFound) {
            if (!self.communityButton) {
                UIImage *home_logo = [UIImage imageNamed:@"home_button_community_bg"];
                float x = UIScreenWidth/4+10;
                float w = UIScreenWidth/2 - 20;
                float h = home_logo.size.height/home_logo.size.width * w;
                float y = UIScreenHeight-kTabBarNavigationHeight - h - self.startButton.frame.size.height - 20;
                self.communityButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
                [self.communityButton setBackgroundImage:home_logo forState:UIControlStateNormal];
                [self.communityButton addTarget:self action:@selector(clickCommunityButton) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.communityButton];
            }
        }
    }
}

// 配置获取成功通知
-(void)getConfigSuccess{
    [self createCommunityButtonView];
    [self updateCanGetRedenvelope];
}

-(void)updateCanGetRedenvelope{
    YunConfig *config = [YunConfig getConfig];
    if (config && [YunConfig getUserIsOpenRedEnvelope]) {
        float tx = [config.enchashment_min floatValue];
        float price = tx - [YunConfig getUserRedEnvelope];
        float w = self.startButton.frame.size.width-20;
        float h = 20;
        float y = self.startButton.frame.size.height+self.startButton.frame.origin.y+ 10;
        float x = (UIScreenWidth-w)/2;
        NSString *str = [NSString stringWithFormat:@"距离%.f元提现还差%.2f元",tx,price];
        if (price<=0) {
            str = [NSString stringWithFormat:@"恭喜您快去提现吧！"];
        }
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xfde659)} range:[str rangeOfString:[NSString stringWithFormat:@"%.2f",price]]];
    
        if (!_redenvelope_progress) {
            
            _redenvelope_progress=[[LDProgressView alloc]initWithFrame:CGRectMake(x,y, w, h)];
            _redenvelope_progress.color = UIColorFromRGB(0xd45c47);
            
            _redenvelope_progress.animate = @NO;
            _redenvelope_progress.showText = @NO;
            //progressView.flat = @YES;
            _redenvelope_progress.type = LDProgressStripes;
            _redenvelope_progress.background = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            //progressView.outerStrokeWidth = @1;
            [self.view addSubview:_redenvelope_progress];
        }
        
        // 还有多少关可以领红包
        CGRect frame = CGRectMake(0, 0, w, h);
        if (!_canGetRedenvelopeTip) {
            _canGetRedenvelopeTip = [[UILabel alloc] initWithFrame:frame];
            _canGetRedenvelopeTip.textAlignment = NSTextAlignmentCenter;
            _canGetRedenvelopeTip.textColor = UIColorFromRGB(0xf9dfa6);
    //        _canGetRedenvelopeTip.layer.borderColor = FMRedColor.CGColor;
    //        _canGetRedenvelopeTip.layer.borderWidth = 1;
    //        _canGetRedenvelopeTip.layer.cornerRadius = h/2;
    //        _canGetRedenvelopeTip.backgroundColor = [FMRedColor colorWithAlphaComponent:0.2];
            _canGetRedenvelopeTip.font = kFont(12);
            _canGetRedenvelopeTip.layer.masksToBounds = YES;
            
            [_redenvelope_progress addSubview:_canGetRedenvelopeTip];
        }
        _redenvelope_progress.progress = [YunConfig getUserRedEnvelope]/tx;
        _canGetRedenvelopeTip.attributedText = attr;
        
    //    [_canGetRedenvelopeTip sizeToFit];
    //    frame = _canGetRedenvelopeTip.frame;
    //    w = frame.size.width + 20;
    //    h = frame.size.height + 10;
    //    _canGetRedenvelopeTip.frame = CGRectMake((UIScreenWidth-w)/2, frame.origin.y, w, h);
    }
}

-(void)createToolView:(NSArray*)datas{
    if (!self.toolView) {
        //float x = 0;
        float w = UIScreenWidth/4;
        float h = 60;
        float y = UIScreenHeight-datas.count*(h+30);
       
        float lx = 0;
        float rx = UIScreenWidth-w;
        self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, y, UIScreenWidth, datas.count*(h+30))];
        
        int tag = 0;
        // 从下到上排列
        float ly = self.toolView.frame.size.height - (kTabBarNavigationHeight + _startButton.frame.size.height/2);
        ly = ly - h;
        float ry = ly;
        float bx = lx;
        float by = 0;
        for (NSDictionary *item in datas) {
            int direction_type = [item[@"direction_type"] intValue];
            NSString *icon = item[@"icon"];
            NSString *iconname = @"home_icon_task";// 默认图标
            if ([icon indexOf:@"http"]==NSNotFound) {
                iconname = icon;
            }
            // 图标
            UIImage *iconimg = [UIImage imageNamed:iconname];
            NSString *push = item[@"push"];
            float tw = h;
            float th = iconimg.size.height/iconimg.size.width * tw;
            if (direction_type==0) {
                bx = lx+(w-tw)/2;
                by = ly;
            }
            if (direction_type==1) {
                bx = rx+(w-tw)/2;
                by = ry;
            }
            UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(bx, by, tw, th)];
     
            bt.tag =tag;
           if ([icon indexOf:@"http"]==NSNotFound) {
               [bt setImage:iconimg forState:UIControlStateNormal];
           }else{
               [bt sd_setImageWithURL:[NSURL URLWithString:iconname] forState:UIControlStateNormal];
           }
            
            
            [self.toolView addSubview:bt];
            
            // 如果是激励视频，看看有没有倒计时
            if ([push isEqualToString:@"freead"]) {
                // 每隔十分钟才能看广告
                [self createFreeAdTime:bt];
            }
            
            // 按钮抖动效果
            int t = 1 +  (arc4random() % 10);
            WEAKSELF
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [__weakSelf startToolAnimaition:bt];
            });
            
            if (direction_type==0) {
                ly -= h+30;
            }
            if (direction_type==1) {
                ry -= h+30;
            }
            tag ++;
            
            [bt addTarget:self action:@selector(clickToolButton:) forControlEvents:UIControlEventTouchUpInside];
        }
      
        
        //self.backgroundView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.toolView];

    }
    [self.view bringSubviewToFront:_blackboardView];
    [self.view bringSubviewToFront:self.startButton];
    [self.view bringSubviewToFront:self.communityButton];
    //[self startButtonAnimation];
}

-(void)createFreeAdTime:(UIButton*)bt{
    if (!_freeAdTime) {
        _freeAdTime = [[UILabel alloc] initWithFrame:CGRectMake(-2, bt.frame.size.height-18-2, bt.frame.size.width+4, 18+4)];
        _freeAdTime.text = @"10:00";
        _freeAdTime.font = kFont(14);
        _freeAdTime.textAlignment = NSTextAlignmentCenter;
        _freeAdTime.backgroundColor = UIColorFromRGB(0xab4841);
        _freeAdTime.layer.cornerRadius = _freeAdTime.frame.size.height/2;
        _freeAdTime.layer.masksToBounds = YES;
        _freeAdTime.layer.borderWidth = 1;
        _freeAdTime.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
        _freeAdTime.textColor = [UIColor whiteColor];
        [bt addSubview:_freeAdTime];
    }
    
    // 每隔十分钟才能看广告
    NSString *last_show_ad_time = [YunConfig get:kConfig_User_last_show_ad_time];
    long long t = [[NSDate date] timeIntervalSince1970];
    long long tt = t-[last_show_ad_time longLongValue];
    long long chaoshi = 10*60;
    YunConfig *config = [YunConfig getConfig];
    if (config) {
        chaoshi = [config.home_vedio_ad_timeout longLongValue];
    }
    if (tt<chaoshi && tt>=0 && [last_show_ad_time longLongValue]>0) {
        // 倒计时
        _freeAdTime.hidden = NO;
        int min = (int)tt/60;
        int sec = tt % 60;
        min = min<1?1:min;
        sec = 59 - sec;
        min = (int)(chaoshi/60) - min;
        NSString *minstr = [NSString stringWithFormat:@"%@%d:%@%d",min<10?@"0":@"",min,sec<10?@"0":@"",sec];
        _freeAdTime.text = minstr;
    }else{
        _freeAdTime.hidden = YES;
    }
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [__weakSelf createFreeAdTime:bt];
    });
}

// 各种云朵背景
-(void)createBgViews{
 
    if (!_bgViews) {
        _bgViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        [self.view addSubview:_bgViews];
    }
    [_bgViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
    float y = 130;
    if (iPhoneX || iPhoneXsMax || iPhoneXR) {
        y += 29;
    }
    float w = 100;
    float alpha = 0.2;

    //float h = 150;

    w = UIScreenWidth;
    UIImage *fx = [UIImage imageNamed:@"home_bg_fanxing"];
    fx = [UIImage imageWithTintColor:[UIColor whiteColor] blendMode:kCGBlendModeDestinationIn WithImageObject:fx];
    y = 0;
    UIImageView *fangxing = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, w, fx.size.height/fx.size.width*w)];
    fangxing.image = fx;
    fangxing.alpha = 0.5;
    [_bgViews addSubview:fangxing];

    // 很多圆点
    w = UIScreenWidth;
    UIImage *yd = [UIImage imageNamed:@"home_bg_yuandian"];
    y = 0;
    UIImageView *yuandian = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, w, yd.size.height/yd.size.width*w)];
    yuandian.image = yd;
    yuandian.alpha = 0.3;
    //[_bgViews addSubview:yuandian];
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.3];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.1];
    opacityAnimation.duration=1.3;      //执行时间
    opacityAnimation.repeatCount=NSNotFound;      //执行次数
    opacityAnimation.autoreverses=YES;    //完成动画后会回到执行动画之前的状态
    [yuandian.layer addAnimation:opacityAnimation forKey:nil];


    // 太阳1
//    UIImage *sun1 = [UIImage imageNamed:@"home_bg_sun1"];
//    UIImageView *taiyang1 = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-100, y, 100, sun1.size.width/sun1.size.height*100)];
//    taiyang1.image = sun1;
    //[_bgViews addSubview:taiyang1];

    // 云朵2
    w = 300;
    UIImage *yun2 = [UIImage imageNamed:@"home_bg_yun2"];
    UIImageView *yun2v = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreenWidth-w, y, w, yun2.size.height/yun2.size.width*w)];
    yun2v.image = yun2;
    yun2v.alpha = alpha;
    [_bgViews addSubview:yun2v];
    [self startBgViewsAnimation:yun2v toValue:-yun2v.frame.size.width duration:50];

    // 云朵1
    w = 150;
    UIImage *yun1 = [UIImage imageNamed:@"home_bg_yun1"];
    y = UIScreenHeight/2 - yun1.size.height/yun1.size.width*w;
    UIImageView *yun1v = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, w, yun1.size.height/yun1.size.width*w)];
    yun1v.image = yun1;
    yun1v.alpha = alpha;
    [_bgViews addSubview:yun1v];
    [self startBgViewsAnimation:yun1v toValue:UIScreenWidth/2 duration:30];

    // 云朵3
    w = 300;
    UIImage *yun3 = [UIImage imageNamed:@"home_bg_yun3"];
    y = UIScreenHeight/2+50;
    UIImageView *yun3v = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenWidth-w)/2, y, w, yun3.size.height/yun3.size.width*w)];
    yun3v.image = yun3;
    yun3v.alpha = alpha;
    [_bgViews addSubview:yun3v];

    [self startBgViewsAnimation:yun3v toValue:-30 duration:10];

    // 云朵4
    w = UIScreenWidth+50;
    UIImage *yun4 = [UIImage imageNamed:@"home_bg_yun4"];
    y = UIScreenHeight - yun4.size.height/yun4.size.width*w;
    UIImageView *yun4v = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, w, yun4.size.height/yun4.size.width*w)];
    yun4v.image = yun4;
    yun4v.alpha = alpha;
    [_bgViews addSubview:yun4v];

    [self startBgViewsAnimation:yun4v toValue:-30 duration:20];

        
    
}
-(void)createBlackBoard{
    if(!_blackboardView){
        UIImage *bg = [UIImage imageNamed:@"blackboard-bg-icon"];
        float x = 10;
        float y = self.logoView.frame.origin.y - 60;
        //y = y/2 - 30;
        float w = UIScreenWidth-2*x;
        float h = bg.size.height/bg.size.width * w;
        _blackboardView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _blackboardView.image = bg;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBlackboardView)];
        [_blackboardView addGestureRecognizer:tap];
        _blackboardView.userInteractionEnabled = YES;
        [self.view addSubview:_blackboardView];
        
        YunLabel *l = [[YunLabel alloc] initWithFrame:CGRectMake(70, h/3-10, w - 140, h/3*2) borderWidth:3 borderColor:UIColorFromRGB(0x333333)];
        l.text = @"小黑板\n\n 小编正在写日志...";
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor whiteColor];
        l.numberOfLines = 0;
        l.adjustsFontSizeToFitWidth = YES;
        [l sizeToFit];
        l.tag = 110;
        float maxh = h/5*2;
        l.frame = CGRectMake(l.frame.origin.x, l.frame.origin.y, w-140, MIN(l.frame.size.height,maxh));
        //l.backgroundColor = FMBlueColor;
        
        [_blackboardView addSubview:l];
        // 日期
        YunLabel *t = [[YunLabel alloc] initWithFrame:CGRectMake(70+10, h - 60 - 14-3, w - 140, 14) borderWidth:3 borderColor:UIColorFromRGB(0x333333)];
        t.text = @"";
        t.font = kFont(12);
        t.textColor = [UIColor whiteColor];
        t.tag = 111;
        [_blackboardView addSubview:t];
        
        // 分享按钮
        UIImage *sbg = [UIImage imageNamed:@"yellow_button_bg"];
        float sw = 80;
        float sh = sbg.size.height/sbg.size.width * sw;
        x = w-70-sw;
        y = h - 60 - sh;
        UIButton *bt = [UIButton createDefaultButton:@"分享一下" frame:CGRectMake(x, y, sw, sh) size:12];
        [bt addTarget:self action:@selector(shareTextToPlatformType) forControlEvents:UIControlEventTouchUpInside];
        [_blackboardView addSubview:bt];
        
        // 关闭按钮
        UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake(w-60-15, h/3-10, 15, 15)];
        UIImage *closeIcon = [UIImage imageNamed:@"lz_close_black_bt"];
        closeIcon = [UIImage imageWithTintColor:[UIColor whiteColor] blendMode:kCGBlendModeDestinationIn WithImageObject:closeIcon];
        [closeBt setImage:closeIcon forState:UIControlStateNormal];
        [closeBt addTarget:self action:@selector(hideBlackBoard) forControlEvents:UIControlEventTouchUpInside];
        [_blackboardView addSubview:closeBt];
        
        _blackboardView.alpha = 0;
        _blackboardView.layer.anchorPoint = CGPointMake(0.5, 0);
        [self.view bringSubviewToFront:_blackboardView];
    }
}

-(void)showBlackBoard:(UIButton*)bt{
    // 检查内容
    NSString *content = [YunConfig get:kConfig_User_BlackBoard_Content];
    if (content) {
        if ([content indexOf:@"|"]!=NSNotFound) {
            NSString *date = [content split:@"|"].firstObject;
            content = [content split:@"|"].lastObject;
            YunLabel *l = [_blackboardView viewWithTag:110];
            YunLabel *d = [_blackboardView viewWithTag:111];
            l.text = content;
            d.text = date;
            [l sizeToFit];
            float maxh = _blackboardView.frame.size.height/5*2;
            l.frame = CGRectMake(l.frame.origin.x, l.frame.origin.y, _blackboardView.frame.size.width-140, MIN(l.frame.size.height,maxh));
        }
        
    }
    WEAKSELF
    if (_blackboardView.alpha<1) {
        [self startBlackBoardAnimation];
        _blackboardView.alpha = 0;
        _blackboardView.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.6 animations:^{
            __weakSelf.blackboardView.transform = CGAffineTransformMakeScale(1, 1);;
            __weakSelf.blackboardView.alpha = 1;
        } completion:^(BOOL finished) {
            //[__weakSelf startBlackBoardAnimation];
        }];
        
        //[self getHttpBlackBoard];
    }else{
        
        [self hideBlackBoard];
    }
}
-(void)getHttpBlackBoard{
    WEAKSELF
    [http sendPostRequestWithParams:nil api:kAPI_Sentences start:^{
        
    } failure:^{
        
    } success:^(NSDictionary *dic) {
        int code = [dic[@"code"]intValue];
        if (code==200) {
            NSDictionary *data = dic[@"data"];
            if (data) {
                NSDictionary *item = ((NSArray*)data[@"data"]).firstObject;
                item = [fn checkNullWithDictionary:item];
                NSString *push_at = item[@"push_at"];
                NSString *text = item[@"text"];
                if ([push_at length]>10) {
                    push_at = [push_at substringToIndex:10];
                }
                // 小黑板内容
                [YunConfig seting:kConfig_User_BlackBoard_Content value:[NSString stringWithFormat:@"%@|小黑板\n\n%@",push_at,text]];
                //NSString *today = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd"];
                NSString *lastShowDate = [YunConfig get:kConfig_User_BlackBoard_LastShowDate];
                if (![lastShowDate isEqualToString: text]) {
                    [__weakSelf showBlackBoard:nil];
                    [YunConfig seting:kConfig_User_BlackBoard_LastShowDate value:text];
                }
            }
        }
    }];
}
-(void)hideBlackBoard{
    WEAKSELF
    [UIView animateWithDuration:0.6 animations:^{
        //__weakSelf.blackboardView.transform = CGAffineTransformMakeScale(0, 0);;
        __weakSelf.blackboardView.alpha = 0;
    } completion:^(BOOL finished) {
        [__weakSelf.blackboardView.layer removeAllAnimations];
    }];
}

-(void)startBlackBoardAnimation{
    _blackboardView.tag = 0;
    //_blackboardView.userInteractionEnabled = YES;
    [_blackboardView.layer removeAllAnimations];
    [self AnimaRepeatCount:0 animatype:2 animaduration:3 animaView:_blackboardView];
    
}

-(void)clickBlackboardView{
    _blackboardView.tag = _blackboardView.tag + 1;
    if (_blackboardView.tag==1) {
        [_blackboardView.layer removeAllAnimations];
    }
    if (_blackboardView.tag>=2) {
        [self hideBlackBoard];
        _blackboardView.tag = 0;
    }
    //_blackboardView.userInteractionEnabled = NO;
}

-(void)AnimaRepeatCount:(NSInteger)count animatype:(int)type animaduration:(float)duration animaView:(UIView*)View{
    CABasicAnimation *baseAnimation = [CABasicAnimation animation];
    //动画运动的方式，现在指定的是围绕Z轴旋转
    baseAnimation.keyPath = @"transform.rotation.z";
    //动画持续时间
    baseAnimation.duration = duration;
    //开始的角度
    baseAnimation.fromValue = [NSNumber numberWithFloat:-M_PI_4/4];
    //结束的角度
    baseAnimation.toValue = [NSNumber numberWithFloat:M_PI_4/4];
    //动画的运动方式
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //是否反向移动动画
    baseAnimation.autoreverses = YES;
    baseAnimation.removedOnCompletion = NO;
    //动画重复次数
    if (count==0) {
           baseAnimation.repeatCount  = MAXFLOAT;
    }else{
          baseAnimation.repeatCount  = count;
    }
    //动画的代理
    //baseAnimation.delegate = self;
    //动画结束后的状态
    baseAnimation.fillMode = kCAFillModeForwards;
    
    [baseAnimation setValue:@"RightandLeft" forKey:@"Animation"];
    
    [View.layer addAnimation:baseAnimation forKey:@"Animation"];
    switch (type) {
        case 0:{
            View.layer.anchorPoint = CGPointMake(0.5, 0.5);//中间摆动
        }
            break;
        case 1:{
            View.layer.anchorPoint = CGPointMake(0.5, 1);//上面摆动
        }
            break;
        default:{
             View.layer.anchorPoint = CGPointMake(0.5, 0);//下面摆动
        }
            break;
    }
}


// 背景动起来
-(void)startBgViewsAnimation:(UIImageView*)iv toValue:(float)toValue duration:(float)duration{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///.y的话就向下移动。
    animation.toValue = [NSNumber numberWithFloat:toValue];
    animation.duration = duration;
    animation.autoreverses = YES;//yes的话，又返回原位置了。
    animation.repeatCount = MAXFLOAT;
    //animation.fillMode = kCAFillModeForwards;
    
    [iv.layer addAnimation:animation forKey:nil];
}

-(void)clickToolButton:(UIButton*)bt{
    int tag = (int)bt.tag;
    NSArray *datas = _datas;
    NSDictionary *item = datas[tag];
    [self.say touchButton];
    if (item) {
        NSString *push = item[@"push"];
        if ([push indexOf:@"http"]!=NSNotFound) {
            // 打开网页
            YunWebViewController *web = [[YunWebViewController alloc] initWithUrl:push];
            [self.navigationController pushViewController:web animated:YES];
            
        }
        if ([push isEqualToString:@"task"]) {
            [MobClick beginEvent:@"home_task"];
//            [[EverydaySignInView sharedSingleton] show];
            [[YunTasksView sharedSingleton] show];
            [MobClick endEvent:@"home_task"];
        }
        
        if ([push isEqualToString:@"play"]) {
            [MobClick beginEvent:@"home_play"];
            YunPlayPopStarViewController *v = [[YunPlayPopStarViewController alloc] init];
            [self.navigationController pushViewController:v animated:YES];
            [MobClick endEvent:@"home_play"];
        }
        
        if ([push isEqualToString:@"leaderboard"]) {
            [MobClick beginEvent:@"home_leaderboard"];
            [[YunWinerListView sharedSingleton] show];
            [MobClick endEvent:@"home_leaderboard"];
        }
        if ([push isEqualToString:@"disciple"]) {
            [MobClick beginEvent:@"home_disciple"];
            [[YunMyDiscipleView sharedSingleton] show];
            [MobClick endEvent:@"home_disciple"];
        }
        
        if ([push isEqualToString:@"blackboard"]) {
            [MobClick beginEvent:@"home_blackboard"];
            [self showBlackBoard:bt];
            [MobClick endEvent:@"home_blackboard"];
        }
        
        if ([push isEqualToString:@"freead"]) {
            // 每隔十分钟才能看广告
            NSString *last_show_ad_time = [YunConfig get:kConfig_User_last_show_ad_time];
            long long t = [[NSDate date] timeIntervalSince1970];
            long long chaoshi = 10*60;
            YunConfig *config = [YunConfig getConfig];
            if (config) {
                chaoshi = [config.home_vedio_ad_timeout longLongValue];
            }
            long long tt = (t-[last_show_ad_time longLongValue]);
            if (tt>chaoshi) {
                // 看广告
                [YunConfig seting:kConfig_User_last_show_ad_time value:@(t).stringValue];
                BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
                model.userId = [YunConfig getUserId];
                self.rewardedVideoAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:kCsj_sloteid_945440297 rewardedVideoModel:model];
                self.rewardedVideoAd.delegate = self;
                [self.rewardedVideoAd loadAdData];
                [MobClick beginEvent:@"home_video_ad"];
                self.ad_start_time = [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
                self.requestid = [fn getTimestamp];
                [http sendApiUserAd:@"点击首页激励视频广告" type:0 ad:kCsj_sloteid_945440297 start_time:self.ad_start_time end_time:@"" requestid:self.requestid];
                
            }else{
                [[YunShowMsg sharedSingleton] show:@"非常感谢您的支持，要稍微等等哦！"];
            }
            
        }
    }
}

-(void)startToolAnimaition:(UIButton*)bt{
    //创建一个关键帧动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    //设置关键帧
    keyAnimation.values = @[@(-M_PI_4 * 0.1 * 1), @(M_PI_4 * 0.1 * 1), @(-M_PI_4 * 0.1 * 1)];
    //设置重复
    keyAnimation.repeatCount = 10;
    //把核心动画添加到layer上
    [bt.layer addAnimation:keyAnimation forKey:@"keyAnimation"];
    int t = 1 +  (arc4random() % 10);
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [__weakSelf startToolAnimaition:bt];
    });
    
}

-(void)startLogoAnimation{
    if(self.logoView){
        //放大效果，并回到原位
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //速度控制函数，控制动画运行的节奏
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration=1.5;      //执行时间
        animation.repeatCount=0;      //执行次数
        animation.autoreverses=NO;    //完成动画后会回到执行动画之前的状态
        animation.fromValue= [NSNumber numberWithFloat:0.2];  //初始伸缩倍数
        animation.toValue= [NSNumber numberWithFloat:1.0];    //结束伸缩倍数
        [[self.logoView layer] addAnimation:animation forKey:nil];
        
        [self startLogoAnimationJump:1.5];
    }
    
}

-(void)startLogoAnimationJump:(int)t{
    
    // 顺便更新金币，因为第一次启动的时候可能会没有网络，金币为0
    [self notificationGetCoin];
    [self updateCanGetRedenvelope];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //创建一个关键帧动画
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        //设置关键帧
        keyAnimation.values = @[@(-M_PI_4 * 0.1 * 1), @(M_PI_4 * 0.1 * 1), @(-M_PI_4 * 0.1 * 1)];
        //设置重复
        keyAnimation.duration=0.1;      //执行时间
        keyAnimation.repeatCount = 1;
        keyAnimation.autoreverses=NO;    //完成动画后会回到执行动画之前的状态
        //把核心动画添加到layer上
        [[__weakSelf.logoView layer] addAnimation:keyAnimation forKey:@"keyAnimation"];
        
        int tt = 10 +  (arc4random() % 20);
        
        [__weakSelf startLogoAnimationJump:tt];
    });
    
}

-(void)startLightingAnimation{
    if(self.lightingView){
        self.lightingView.alpha = 0;
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //放大效果，并回到原位
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            //速度控制函数，控制动画运行的节奏
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            //animation.duration=1.3;      //执行时间
            //animation.repeatCount=1;      //执行次数
            //animation.autoreverses=YES;    //完成动画后会回到执行动画之前的状态
            animation.fromValue= [NSNumber numberWithFloat:0.5];  //初始伸缩倍数
            animation.toValue= [NSNumber numberWithFloat:1.5];    //结束伸缩倍数
            
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.fromValue = [NSNumber numberWithFloat:0];
            opacityAnimation.toValue = [NSNumber numberWithFloat:0.8];
            //animation.duration=1.3;      //执行时间
            //animation.repeatCount=1;      //执行次数
            //animation.autoreverses=YES;    //完成动画后会回到执行动画之前的状态
            
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            animationGroup.duration = 1.5f;
            animationGroup.autoreverses = YES;   //是否重播，原动画的倒播
            animationGroup.repeatCount = 0;//HUGE_VALF;     //HUGE_VALF,源自math.h
            [animationGroup setAnimations:[NSArray arrayWithObjects:animation, opacityAnimation, nil]];


            //将上述两个动画编组
            [[__weakSelf.lightingView layer] addAnimation:animationGroup forKey:@"animationGroup"];
           [__weakSelf startLightingAnimation];
        });

        
    }
    
}

-(void)startLightingAnimation_2{
    if(self.lightingView_2){
        self.lightingView_2.alpha = 0;
        self.lightingView_2.transform = CGAffineTransformMakeScale(0.8, 0.8);
        WEAKSELF
        [UIView animateWithDuration:2.5 animations:^{
            __weakSelf.lightingView_2.alpha = 0.5;
            
            
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //放大效果，并回到原位
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                //速度控制函数，控制动画运行的节奏
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                //animation.duration=1.3;      //执行时间
                animation.repeatCount= 0 ;      //执行次数
                animation.autoreverses=NO;    //完成动画后会回到执行动画之前的状态
                animation.fromValue= [NSNumber numberWithFloat:0.8];  //初始伸缩倍数
                animation.toValue= [NSNumber numberWithFloat:1.2];    //结束伸缩倍数
                
                CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                opacityAnimation.fromValue = [NSNumber numberWithFloat:0.5];
                opacityAnimation.toValue = [NSNumber numberWithFloat:0.8];
                //animation.duration=1.3;      //执行时间
                animation.repeatCount=0;      //执行次数
                animation.autoreverses=NO;    //完成动画后会回到执行动画之前的状态
                
                CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
                animationGroup.duration = 30.5f;
                animationGroup.autoreverses = YES;   //是否重播，原动画的倒播
                animationGroup.repeatCount = NSNotFound;     //HUGE_VALF,源自math.h
                [animationGroup setAnimations:[NSArray arrayWithObjects:animation, opacityAnimation, nil]];


                //将上述两个动画编组
                [[__weakSelf.lightingView_2 layer] addAnimation:animationGroup forKey:@"animationGroup2"];
                
                //[[self.lightingView layer] addAnimation:animation forKey:nil];
                //[__weakSelf startLightingAnimation_2];
            });
        }];
        
        

        
    }
    
}

-(void)startButtonAnimation{
    if(self.startButton){
        
        //[[self.startButton layer] removeAllAnimations];
        //放大效果，并回到原位
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //速度控制函数，控制动画运行的节奏
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration=0.5;      //执行时间
        animation.repeatCount=4;      //执行次数
        animation.autoreverses=YES;    //完成动画后会回到执行动画之前的状态
        animation.fromValue= [NSNumber numberWithFloat:1.0];  //初始伸缩倍数
        animation.toValue= [NSNumber numberWithFloat:1.1];    //结束伸缩倍数
        [[self.startButton layer] addAnimation:animation forKey:nil];
        
        WEAKSELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [__weakSelf startButtonAnimation];
        });
    }
    
}

-(void)clickPlayButton:(UIButton*)button{
    [self.say say:@"lz_touch_on.wav"];
    [[YunSetingView sharedSingleton] show];
}

/**
 空心字体

 @param str 文本
 @param textColor 文本颜色
 @param textBorderColor 文本边框颜色
 @param strokeWidth 文件边框宽度
 @return 文本
 */
-(NSMutableAttributedString *)textHollow:(NSString *)str textColor:(UIColor *)textColor textBorderColor:(UIColor *)textBorderColor strokeWidth:(CGFloat)strokeWidth
{
    NSDictionary *dict = @{
                           NSStrokeColorAttributeName:textBorderColor,
                           NSStrokeWidthAttributeName : [NSNumber numberWithFloat:strokeWidth],
                           NSForegroundColorAttributeName:textColor
                           };
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:str attributes:dict];
    return attribtStr;
}

- (void)setBackground{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"lz_background_big"]]];
}
-(void)initSay{
    self.say = [YunPopstarSay new];
}
// 用户自动登录成功通知
-(void)notificationUserLoginSuccess{
    [self showEverydaySignView];
}

-(void)clickStartButton{
    _startButton.enabled = NO;
    [self.say touchButton];
    WEAKSELF
    if (![AppDelegate sharedSingleton].isDownloadUserInfo) {
        // 还没下载用户信息，继续等待
        [[YunShowMsg sharedSingleton] show:@"正在卖力加载，稍微等等哦！"];
        // 自动登录
        [http autologinWithStart:^{
            
        } failure:^{
            [[YunShowMsg sharedSingleton] show:@"网络不给力，重新试试！"];
            __weakSelf.startButton.enabled = YES;
        } success:^(NSDictionary *dic) {
            [[YunShowMsg sharedSingleton] hide];
            int code = [dic[@"code"] intValue];
            NSDictionary *data = dic[@"data"];
            if (code==200 && data) {
                NSDictionary *user = data[@"user"];
                NSString *token = data[@"token"];
                [YunConfig setUserId:[NSString stringWithFormat:@"%@",user[@"id"]]];
                [YunConfig setUserToken:token];
                if (user) {
                    user = [fn checkNullWithDictionary:user];
                    NSLog(@"%@",user);
                    [YunConfig setUserInfoWithData:user];
                }
                
                [__weakSelf jumpToHome];
            }else{
                __weakSelf.startButton.enabled = YES;
                NSString *msg = dic[@"msg"];
                if (msg==nil) {
                    msg = @"服务器有误，请稍后再试";
                }
                [[YunShowMsg sharedSingleton] show:msg];
            }
        }];
    }else{
        [self jumpToHome];
    }
    
    
}

-(void)clickCommunityButton{
    _communityButton.enabled = NO;
    [self.say touchButton];
    WEAKSELF
    [fn sleepSeconds:0.1 finishBlock:^{
        [__weakSelf.say stop];
        YunCommunityViewController *v = [[YunCommunityViewController alloc] init];
        [__weakSelf.navigationController pushViewController:v animated:YES];
        __weakSelf.communityButton.enabled = YES;
    }];
   
}

-(void)jumpToHome{
    
    WEAKSELF
    [fn sleepSeconds:0.1 finishBlock:^{
        [__weakSelf.say stop];
        YunHomeViewController *home = [[YunHomeViewController alloc] init];
        [__weakSelf.navigationController pushViewController:home animated:YES];
    }];
}

-(void)getHttpShortCut{
    WEAKSELF
    [http sendPostRequestWithParams:nil api:kAPI_Shortcut start:^{
        
    } failure:^{
        [fn sleepSeconds:5 finishBlock:^{
            [__weakSelf getHttpShortCut];
        }];
    } success:^(NSDictionary *dic) {
        int code = [dic[@"code"] intValue];
        if (code==200) {
            NSArray *data = dic[@"data"];
            if (data) {
                __weakSelf.datas = data;
                [__weakSelf createToolView:data];
            }
            
        }else{
            FMHttpShowError(dic)
        }
    }];
}





- (void)shareImageAndTextToPlatformType
{
    WEAKSELF
    [self.say touchButton];
     [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]];
     [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
         [__weakSelf.say touchButton];
        // 根据获取的platformType确定所选平台进行下一步操作
         //创建分享消息对象
         UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
         //创建网页内容对象
         UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"恋上消消消好玩" descr:@"经典消灭星星无限关卡小游戏，容易爱上的苹果手机休闲益智游戏" thumImage:[UIImage imageNamed:@"logo180"]];
         //设置网页地址
         shareObject.webpageUrl = [NSString stringWithFormat:@"%@/user/share?uid=%@",kBaseURL,[YunConfig getUserId]];
         //分享消息对象设置分享内容对象
         messageObject.shareObject = shareObject;
         //调用分享接口
         [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
             if (error) {
                 NSLog(@"************Share fail with error %@*********",error);
             }else{
                 NSLog(@"response data is %@",data);
                 // 分享成功，调用分享接口，保存分享记录
                 [http sendPostRequestWithParams:nil api:kAPI_Users_Share start:^{
                     [SVProgressHUD show];
                 } failure:^{
                     [SVProgressHUD showErrorWithStatus:@"很抱歉,分享出现网络问题，请重新分享哦,谢谢！"];
                 } success:^(NSDictionary *dic) {
                     int code = [dic[@"code"]intValue];
                     if (code==200) {
                         [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                     }else{
                         FMHttpShowError(dic)
                     }
                 }];
             }
         }];
    }];
    
    
    
}

- (void)shareTextToPlatformType
{
    [MobClick beginEvent:@"home_share_blackboard"];
    //WEAKSELF
    YunLabel *l = [_blackboardView viewWithTag:110];
    NSString *content = l.text;
    
    [self.say touchButton];
     
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.title = @"恋上消消消好玩";
    messageObject.text = content;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            [MobClick endEvent:@"home_share_blackboard"];
            UMSocialShareResponse *d = (UMSocialShareResponse*)data;
            NSLog(@"response data is %@",[d mj_JSONString]);
            // 分享成功，调用分享接口，保存分享记录
//            [http sendPostRequestWithParams:nil api:kAPI_Users_Share start:^{
//                [SVProgressHUD show];
//            } failure:^{
//                [SVProgressHUD showErrorWithStatus:@"很抱歉,分享出现网络问题，请重新分享哦,谢谢！"];
//            } success:^(NSDictionary *dic) {
//                int code = [dic[@"code"]intValue];
//                if (code==200) {
//                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
//                }else{
//                    FMHttpShowError(dic)
//                }
//            }];
        }
    }];
    
    
    
}


// 广告回调

#pragma mark - BUNativeExpressRewardedVideoAdDelegate
//加载广告的时候，delegate 传的是self，广告事件发生后会自动回调回来，我们只需要重新实现这些方法即可
- (void)nativeExpressRewardedVideoAdDidLoad:
(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
    NSLog(@"展示奖励视频广告");
    if(self.rewardedVideoAd.isAdValid){
        UINavigationController *n = (UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController;
        [self.rewardedVideoAd showAdFromRootViewController:n];
        // 更新广告弹出时间
        //[YunConfig seting:kConfig_User_clearance_show_ad_lasttime value:@([fn getTimestamp]).stringValue];
    }
}

- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    NSLog(@"%s",__func__);
    NSLog(@"error code : %ld , error message : %@",(long)error.code,error.description);
}

- (void)nativeExpressRewardedVideoAdCallback:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd withType:(BUNativeExpressRewardedVideoAdType)nativeExpressVideoType{
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdViewRenderSuccess:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {
    NSLog(@"%s",__func__);
    NSLog(@"视频广告渲染错误");
  
}

- (void)nativeExpressRewardedVideoAdWillVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdWillClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
    NSLog(@"看完广告返回 发放奖励");
    [MobClick endEvent:@"home_video_ad"];
    YunConfig *config = [YunConfig getConfig];
    // 奖励金币
    [[YunGetGoldView sharedSingleton] show:[config.free_reward_amount intValue] intro:@"首页免费奖励金币" type:2];
    [YunGetGoldView sharedSingleton].hideBlock = ^{
       
    };
    
    [http sendApiUserAd:@"点击首页激励视频广告" type:0 ad:kCsj_sloteid_945440297 start_time:self.ad_start_time end_time: [NSString stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"] requestid:self.requestid];
    
    

}

- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
    NSLog(@"加载激励视频错误");
    
}

- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"%s",__func__);
}

- (void)nativeExpressRewardedVideoAdDidCloseOtherController:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd interactionType:(BUInteractionType)interactionType {
    NSString *str = nil;
    if (interactionType == BUInteractionTypePage) {
        str = @"ladingpage";
    } else if (interactionType == BUInteractionTypeVideoAdDetail) {
        str = @"videoDetail";
    } else {
        str = @"appstoreInApp";
    }
    NSLog(@"%s __ %@",__func__,str);
}
@end
