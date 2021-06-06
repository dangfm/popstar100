//
//  YunEnchashmentViewController.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/12.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunEnchashmentViewController.h"
#import <BUAdSDK/BUNativeExpressInterstitialAd.h>

@interface YunEnchashmentViewController ()<BUNativeExpressBannerViewDelegate>

@end

@implementation YunEnchashmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

-(instancetype)initWithType:(int)type{
    if (self=[super init]) {
        _type = type;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
}
- (void)initView{
    
    [self initSay];
    [self initBackgroundView];
    [self initHeaderView];
    [self createMainView];
    [self loadFeedAds];
    [self createdMyGoldView];
    [self createdEnchashmentTypeView];
    
    [self updateMainView];
    [self createEnchashmentButton];
    
}

-(void)createMainView{
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavigationHeight, UIScreenWidth, UIScreenHeight-kStatusBarHeight-kNavigationHeight-kTabBarNavigationHeight)];
    [self.view addSubview:_mainView];
}
-(void)updateMainView{
    UIView *lastView = [self.mainView.subviews lastObject];
    CGRect frame = self.mainView.frame;
    float h = lastView.frame.origin.y + lastView.frame.size.height + 10;
    if (h<frame.size.height) {
        h = frame.size.height;
    }
    self.mainView.frame = CGRectMake(0, kStatusBarHeight+kNavigationHeight, UIScreenWidth, UIScreenHeight-kStatusBarHeight-kNavigationHeight-kTabBarNavigationHeight);
    self.mainView.contentSize = CGSizeMake(frame.size.width, h);
}

-(void)initHeaderView{
    if (!self.headerView) {
        float h = kNavigationHeight;
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, UIScreenWidth, h)];
        self.headerView.backgroundColor = [UIColor clearColor];
        
        YunLabel *title = [[YunLabel alloc] initWithFrame:self.headerView.bounds borderWidth:0 borderColor:UIColorFromRGB(0xdd8a21)];
        title.font = kFontBold(22);
        title.text = @"提现";
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:title];
        
        // 返回按钮
        UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake(15, (h-25)/2 , 25, 25)];
        UIImage *closeicon = [UIImage imageNamed:@"return_back_icon"];
        [closeBt setImage:closeicon forState:UIControlStateNormal];
        [closeBt addTarget:self action:@selector(clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:closeBt];
        
        // 注释按钮
        UIButton *noteBt = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth - 25 - 15, (h-25)/2 , 25, 25)];
        UIImage *noteicon = [UIImage imageNamed:@"lz_note_icon"];
        [noteBt setImage:noteicon forState:UIControlStateNormal];
        noteBt.tag = 1;
        [noteBt addTarget:self action:@selector(clickNoteButton) forControlEvents:UIControlEventTouchUpInside];
        //[self.headerView addSubview:noteBt];
       
        [self.view addSubview:self.headerView];
    }
}
// 我的金币
-(void)createdMyGoldView{
    float x = 15;
    float y = 15+_expressViewBox.frame.size.height;
    float w = UIScreenWidth - 2*x;
    float h = 100;
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(x, y , w , h)];
    box.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    box.layer.cornerRadius = 10;
    box.layer.borderColor = [UIColor whiteColor].CGColor;
    box.layer.borderWidth = 1;
    [_mainView addSubview:box];
    
    // 我的金币
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, w-30, 20)];
    l.font = kFont(16);
    l.text = @"我的金币";
    l.textColor = FMBlackColor;
    [box addSubview:l];
    
    UILabel *c = [[UILabel alloc] initWithFrame:CGRectMake(15, 15+20, w-30, 50)];
    c.font = kFontBold(30);
    c.text = @([YunConfig getUserGold]).stringValue;
    c.textColor = FMRedColor;
    [box addSubview:c];
    _mygold = c;
    if (_type==1) {
        l.text = @"我的红包";
         c.text = @([YunConfig getUserRedEnvelope]).stringValue;
    }
    // 提现记录按钮
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    w = 100;
    h = 35;
    x = box.frame.size.width - w - 15;
    y = box.frame.size.height/2-h/2;
    
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [bt setTitle:@"提现记录" forState:UIControlStateNormal];
    [bt setTitleColor:UIColorFromRGB(0xfc4152) forState:UIControlStateNormal];
    bt.titleLabel.font = kFont(16);
    bt.backgroundColor = [UIColor clearColor];
    bt.layer.cornerRadius = h/2;
    bt.layer.borderColor = UIColorFromRGB(0xfc4152).CGColor;
    bt.layer.borderWidth = 1;
    [bt addTarget:self action:@selector(clickEnchashmentLogButton:) forControlEvents:UIControlEventTouchUpInside];
    bt.layer.cornerRadius = h/2;
    [box addSubview:bt];
}
// 提现方式
-(void)createdEnchashmentTypeView{
    float x = 15;
    float y = 15+100+15+_expressViewBox.frame.size.height;
    float w = UIScreenWidth - 2*x;
    float h = 500;
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(x, y , w , h)];
    box.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    box.layer.cornerRadius = 10;
    box.layer.borderColor = [UIColor whiteColor].CGColor;
    box.layer.borderWidth = 1;
    [_mainView addSubview:box];
    
    // 提现方式
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, w-30, 20)];
    l.font = kFont(16);
    l.text = @"提现方式";
    l.textColor = FMBlackColor;
    [box addSubview:l];
    
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, 50, w/2 , 44)];
    [bt setTitle:@"微信" forState:UIControlStateNormal];
    bt.titleLabel.font = kFontBold(18);
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bt.layer.cornerRadius = 8;
    bt.layer.borderColor = UIColorFromRGB(0x27d06d).CGColor;
    bt.layer.borderWidth = 1;
    bt.backgroundColor = UIColorFromRGB(0x27d06d);
    //bt.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 0);
    UIImage *icon = [UIImage imageNamed:@"gouxuan"];
    //icon = [UIImage imageWithTintColor:UIColorFromRGB(0x27d06d) blendMode:kCGBlendModeDestinationIn WithImageObject:icon];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(bt.frame.size.width-30, bt.frame.size.height-30, 30, 30)];
    img.image = icon;
    img.tag = 102;
    [bt addSubview:img];
    [box addSubview:bt];
    
    UIButton *face = [[UIButton alloc] initWithFrame:CGRectMake(15, 110+(44-20)/2, 20, 20)];
    [face setImage:[UIImage imageNamed:@"wechat_icon"] forState:UIControlStateNormal];
    face.layer.cornerRadius = 10;
    face.layer.masksToBounds = YES;
    [box addSubview:face];
    _wxface = face;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40, 110, w-55, 44)];
    title.font = kFont(14);
    title.textColor = FMBlackColor;
    title.text = @"未绑定微信";
    _nickname = title;
    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(w-15-15, 110+(44-15)/2, 15, 15)];
    [more setImage:[UIImage imageNamed:@"more-icon"] forState:UIControlStateNormal];
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, w-35, 44)];
    detail.font = kFont(14);
    detail.textColor = FMRedColor;
    detail.text = @"绑定微信";
    detail.textAlignment = NSTextAlignmentRight;
    _detail = detail;
    [box addSubview:title];
    [box addSubview:more];
    [box addSubview:detail];
    
    
    [self updateView];
    
    // 提现金额
    UILabel *lm = [[UILabel alloc] initWithFrame:CGRectMake(15, 110+44+15, w-30, 20)];
    lm.font = kFont(16);
    lm.text = @"提现金额";
    lm.textColor = FMBlackColor;
    [box addSubview:lm];
    
    [self createEnchashmentMoneyBts:box];
}

-(void)updateView{
    if (![[YunConfig getUserWXOpenID] isEqualToString:@""]) {
        _nickname.text = [YunConfig getUserNickName];
        _detail.text = @"已绑定微信";
        //[_wxface setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:]] forState:UIControlStateNormal];
        [_wxface sd_setImageWithURL:[NSURL URLWithString:[YunConfig getUserFace]] forState:UIControlStateNormal];
        _detail.enabled = NO;
        
    }else{
        // 绑定微信动作
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getAuthWithUserInfoFromWechat)];
        [_detail addGestureRecognizer:tap];
        _detail.userInteractionEnabled = YES;
    }
    _mygold.text = @([YunConfig getUserGold]).stringValue;
    if (_type==1) {
         _mygold.text = @([YunConfig getUserRedEnvelope]).stringValue;
    }
}

// 绑定微信
- (void)getAuthWithUserInfoFromWechat
{
    //[SVProgressHUD show];
    WEAKSELF
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:@"绑定出错"];
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            NSString *province = resp.originalResponse[@"province"];
            NSString *country = resp.originalResponse[@"country"];
            NSString *city = resp.originalResponse[@"city"];
            if (!province) {
                province = @"";
            }
            if (!country) {
                country = @"";
            }
            if (!city) {
                city = @"";
            }
            
            NSDictionary *p = @{
                @"openid":resp.openid,
                @"unionid":resp.unionId,
                @"nickname":resp.name,
                @"province":province,
                @"country":country,
                @"city":city,
                @"sex":resp.unionGender,
                @"headimgurl":resp.iconurl,
            };
            [http sendPostRequestWithParams:p api:kAPI_Users_WxLogin start:^{
                [SVProgressHUD show];
            } failure:^{
                [SVProgressHUD showErrorWithStatus:@"网络不给力，绑定失败"];
            } success:^(NSDictionary *dic) {
                int code = [dic[@"code"] intValue];
                if (code==200) {
                    [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
                    NSDictionary *data = dic[@"data"];
                    if (data) {
                        // 绑定成功
                        NSDictionary *user = data[@"user"];
                        NSString *token = data[@"token"];
                        [YunConfig setUserId:[NSString stringWithFormat:@"%@",user[@"id"]]];
                        [YunConfig setUserToken:token];
                        if (user) {
                            user = [fn checkNullWithDictionary:user];
                            NSLog(@"%@",user);
                            [YunConfig setUserInfoWithData:user];
                        }
                        
                        // 更新
                        [__weakSelf updateView];
                        
                    }
                    
                }else{
                    FMHttpShowError(dic)
                }
            }];
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}

-(void)createEnchashmentMoneyBts:(UIView*)box{
    
    float x = 15;
    float y = 15+110+44+20+15;
    float w = box.frame.size.width - 2*x;
    float h = 70;
    
    if(!self.enchashmentMoneyBts){
        float padding = 8;
        float bw = (w - 2*padding) / 3;
        NSArray *t = (NSArray*)[[YunConfig getConfig].enchashment_money_list mj_JSONObject];
        if (_type==1) {
            t = (NSArray*)[[YunConfig getConfig].redenvelope_money_list mj_JSONObject];
        }
//        NSMutableArray *t = [NSMutableArray new];
//        for (NSDictionary* item in _datas) {
//            int type = [item[@"type"] intValue];
//            if (type==_type) {
//                [t addObject:item];
//            }
//        }
        
        int row = (int)t.count/3;
        if ((int)t.count % 3>0 || row==0) {
            row ++;
        }
        self.enchashmentMoneyBts = [[UIView alloc] initWithFrame:CGRectMake(0,y ,w, row*(h+padding))];
        [box addSubview:_enchashmentMoneyBts];
        y = 0;
        for (int i=0; i<t.count; i++) {
            NSDictionary *d = t[i];
            UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, y, bw , h)];
            [bt setTitle:[NSString stringWithFormat:@"%@元",d[@"price"]] forState:UIControlStateNormal];
            bt.titleLabel.font = kFontBold(21);
            [bt setTitleColor:FMRedColor forState:UIControlStateNormal];
            bt.layer.cornerRadius = 8;
            bt.layer.borderColor = UIColorFromRGB(0xfd7581).CGColor;
            bt.layer.borderWidth = 1;
            bt.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 0);
            bt.layer.masksToBounds = YES;
            //bt.backgroundColor = [UIColor whiteColor];
            bt.tag = i;
            [self.enchashmentMoneyBts addSubview:bt];
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, h/2, bw, 20)];
            l.font = kFont(10);
            l.tag = 101;
            l.textColor = UIColorFromRGB(0xfd7581);
            l.text = [NSString stringWithFormat:@"%@",d[@"intro"]];
            l.textAlignment = NSTextAlignmentCenter;
            [bt addSubview:l];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(bw-30, h-30, 30, 30)];
            img.image = [UIImage imageNamed:@"gouxuan"];
            img.tag = 102;
            img.hidden = YES;
            [bt addSubview:img];
            
            //是否新人专享
            int isnew = [d[@"isnew"] intValue];
            if (isnew) {
                UILabel *n = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 16)];
                n.font = kFont(10);
                n.tag = 103;
                n.textColor = UIColorFromRGB(0xfd7581);
                n.text = [NSString stringWithFormat:@"新人专享"];
                n.textAlignment = NSTextAlignmentCenter;
                n.layer.cornerRadius = 8;
                n.backgroundColor = [UIColor whiteColor];
                n.layer.masksToBounds = YES;
                [bt addSubview:n];
            }
            
            
            [bt addTarget:self action:@selector(clickEnchashmentMoneyButton:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i==0) {
                [self clickEnchashmentMoneyButton:bt];
            }
            
            x += bw+padding;
            if ((i+1) % 3 == 0) {
                y += h+padding;
                x = 15;
            }
        }
        
        
    }
    
    [self createTip: box];
}

-(void)createTip:(UIView*)box{
    float x = 15;
    float y = box.subviews.lastObject.frame.size.height + box.subviews.lastObject.frame.origin.y +15;
    float w = box.frame.size.width - 2*x;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, 20)];
    title.font = kFontBold(14);
    title.textColor = FMBlackColor;
    title.text = @"提现说明";
    [box addSubview:title];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, title.frame.size.height+title.frame.origin.y+8, box.frame.size.width-2*x, 44)];
    label.font = kFont(12);
    label.textColor = FMBlackColor;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    float lineSpacing = 8;
    NSString *text = [YunConfig getConfig].enchashment_intro;
    if (_type==1) {
        text = [YunConfig getConfig].redenvelope_intro;
    }
    //text = [text replaceAll:@"@n" target:@"\\n"];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:(lineSpacing-(label.font.lineHeight - label.font.pointSize))];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    //[attributedString addAttribute:NSForegroundColorAttributeName value:FMBlueColor range:[text rangeOfString:@"4008215751"]];
    label.attributedText = attributedString;
    [label sizeToFit];
    [box addSubview:label];

    
    UIView *lastView = [box.subviews lastObject];
    CGRect frame = box.frame;
    float h = lastView.frame.origin.y + lastView.frame.size.height + 10;
    box.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, h);
    
}

-(void)createEnchashmentButton{
    // 立即提现按钮
    UIImage *bg = [UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xfd7581),UIColorFromRGB(0xfc4152)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(UIScreenWidth-30, 55)];
    
    float h = 55;
    float w = bg.size.width/bg.size.height * h;
    float x = (UIScreenWidth-w)/2;
    float y = UIScreenHeight - h - 15;
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [bt setTitle:@"立即提现" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bt.titleLabel.font = kFontBold(22);
    bt.backgroundColor = [UIColor colorWithPatternImage:bg];
    bt.layer.cornerRadius = h/2;
    [bt addTarget:self action:@selector(clickEnchashmentButton:) forControlEvents:UIControlEventTouchUpInside];
    bt.tag = 0;
    bt.layer.cornerRadius = h/2;
    [self.view addSubview:bt];
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

// 点击提现规则
-(void)clickNoteButton{
    [self.say touchButton];
}
// 点击返回按钮
-(void)clickCloseButton{
    [self.say touchButton];
    [self.navigationController popViewControllerAnimated:YES];
}
// 点击提现记录
-(void)clickEnchashmentLogButton:(UIButton*)bt{
    [self.say touchButton];
    YunEnchashmentListViewController *l = [[YunEnchashmentListViewController alloc] init];
    [self.navigationController pushViewController:l animated:YES];
}
// 点击提现金额
-(void)clickEnchashmentMoneyButton:(UIButton*)bt{
    if (bt) {
        for (UIButton*bt in self.enchashmentMoneyBts.subviews) {
            bt.backgroundColor = [UIColor clearColor];
            [bt setTitleColor:FMRedColor forState:UIControlStateNormal];
            UILabel *l = [bt viewWithTag:101];
            l.textColor = UIColorFromRGB(0xfd7581);
            UIImageView *iv = [bt viewWithTag:102];
            iv.hidden = YES;
            
        }
        UIImage *img = [UIImage gradientColorImageFromColors:@[UIColorFromRGB(0xfd7581),UIColorFromRGB(0xfc4152)] gradientType:GradientTypeLeftToRight imgSize:bt.frame.size];
        bt.backgroundColor = [UIColor colorWithPatternImage:img];
        [bt setTitleColor:FMWhiteColor forState:UIControlStateNormal];
        UILabel *l = [bt viewWithTag:101];
        l.textColor = FMWhiteColor;
        UIImageView *iv = [bt viewWithTag:102];
        iv.hidden = NO;
        // 当前选中的值
        int tag = (int)bt.tag;
        NSArray *t = (NSArray*)[[YunConfig getConfig].enchashment_money_list mj_JSONObject];
        if (_type==1) {
            t = (NSArray*)[[YunConfig getConfig].redenvelope_money_list mj_JSONObject];
        }
        if (tag<t.count) {
            NSDictionary *item = t[tag];
            if (item) {
                _money = [NSString stringWithFormat:@"%@",item[@"price"]];
            }
        }
        
    }
}
// 立即提现按钮
-(void)clickEnchashmentButton:(UIButton*)bt{
    WEAKSELF
    [self.say touchButton];
    if ([_money floatValue]<=0) {
        [SVProgressHUD showErrorWithStatus:@"请选择提现金额"];
        return;
    }
    
    bt.enabled = NO;
    [http sendPostRequestWithParams:@{@"money":_money,@"levels":@([YunConfig getUserPassNumber]).stringValue,@"type":@(_type).stringValue} api:kAPI_Users_Enchashment start:^{
        [SVProgressHUD show];
    } failure:^{
        bt.enabled = YES;
        [SVProgressHUD showErrorWithStatus:@"提现失败，网络不给力"];
    } success:^(NSDictionary *dic) {
        bt.enabled = YES;
        int code = [dic[@"code"]intValue];
        NSString *msg = dic[@"msg"];
        if (code==200) {
            [SVProgressHUD showSuccessWithStatus:msg];
            // 金币相应减少,返回总金币
            NSDictionary*data = dic[@"data"];
            if (data) {
                int amount = [data[@"amount"] intValue];
                if (__weakSelf.type==0) {
                    [YunConfig setUserGold:amount];
                }else{
                    [YunConfig setUserRedEnvelope:amount];
                }
                
            }
            [__weakSelf updateView];
            // 跳转到提现记录列表
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GetRedEnvelope object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GetCoin object:nil];
            
            YunEnchashmentListViewController *l = [[YunEnchashmentListViewController alloc] init];
            l.backtop = YES;
            [__weakSelf.navigationController pushViewController:l animated:YES];
            
        }else{
            FMHttpShowError(dic)
        }
    }];
}

// 信息流广告
- (void)loadFeedAds {
    YunConfig *config = [YunConfig getConfig];
    if (config) {
        if([config.open_ads indexOf:kCsj_sloteid_945515431]!=NSNotFound){
            if (!_expressViewBox) {
                float bili = 690.0/388.0;
                float x = 0;
                float w = self.mainView.frame.size.width-30;
                float y = 0;
                float h = w/bili+70;
                UIView *box = [[UIView alloc] initWithFrame:CGRectMake(x, y , w+30 , h+15)];
                box.layer.cornerRadius = 10;
                box.layer.masksToBounds = YES;
                box.backgroundColor = [UIColor clearColor];
                _expressViewBox = [[UIView alloc] initWithFrame:CGRectMake(15, 0, w, h)];
                _expressViewBox.layer.cornerRadius = 10;
                _expressViewBox.layer.masksToBounds = YES;
                _expressViewBox.backgroundColor = [UIColor whiteColor];
                [box addSubview:_expressViewBox];
                [_mainView addSubview:box];
            }
            self.expressAdViews = [NSMutableArray new];
            BUAdSlot *slot1 = [[BUAdSlot alloc] init];
            slot1.ID = kCsj_sloteid_945515431;
            slot1.AdType = BUAdSlotAdTypeFeed;
            BUSize *imgSize = [BUSize sizeBy:BUProposalSize_Feed690_388];
            slot1.imgSize = imgSize;
            slot1.position = BUAdSlotPositionFeed;
            slot1.isSupportDeepLink = YES;
            
            float w = self.expressViewBox.frame.size.width;
            float h = self.expressViewBox.frame.size.height;

            self.nativeExpressAdManager = [[BUNativeExpressAdManager alloc] initWithSlot:slot1 adSize:CGSizeMake(w, h)];
            self.nativeExpressAdManager.delegate = self;
            [self.nativeExpressAdManager loadAd:1];
        }
        
    }
    

}
- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAd views:(NSArray<__kindof BUNativeExpressAdView *> *)views {
    [self.expressAdViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.expressAdViews removeAllObjects];//【重要】不能保存太多view，需要在合适的时机手动释放不用的，否则内存会过大
    if (views.count) {
        [self.expressViewBox.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.expressAdViews addObjectsFromArray:views];
        WEAKSELF
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BUNativeExpressAdView *expressView = (BUNativeExpressAdView *)obj;
            expressView.rootViewController = [AppDelegate sharedSingleton].window.rootViewController;
            [expressView render];
            [__weakSelf.expressViewBox addSubview:expressView];
        }];
    }
    NSLog(@"【BytedanceUnion】个性化模板拉取广告成功回调");
}

-(void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView{
    // 点击
    if (iPhone4 || iPhone6 || iPhone5) {
        [[AppDelegate sharedSingleton].window sendSubviewToBack:self.view];
    }
    
    
}
- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAd error:(NSError *)error {

}

- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView {
    
}

- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords{
    //【重要】需要在点击叉以后 在这个回调中移除视图，否则，会出现用户点击叉无效的情况
    [self.expressAdViews removeObject:nativeExpressAdView];

}

@end
