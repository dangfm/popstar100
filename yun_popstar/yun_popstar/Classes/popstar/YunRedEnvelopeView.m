//
//  YunRedEnvelopeView.m
//  yun_popstar
//
//  Created by dangfm on 2020/7/1.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunRedEnvelopeView.h"

@implementation YunRedEnvelopeView

+ (instancetype)sharedSingleton {
    static YunRedEnvelopeView *_sharedSingleton = nil;
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

-(void)show{
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
    [self updateView];
    [self getHttpUserInfo];
}
-(void)initViews{
    [self initSay];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [[AppDelegate sharedSingleton].window addSubview:self];
    
    float w = UIScreenWidth-60;
    float h = w;
    float x = 30;
    float padding = 20;
    
    UIImage *mbg = [UIImage imageNamed:@"redbox_bg"];
    h = mbg.size.height/mbg.size.width * w;
    float y = (UIScreenHeight-h)/2;
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.8;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.maskView addGestureRecognizer:tap];
    [self.maskView setUserInteractionEnabled:YES];
    [self addSubview:self.maskView];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:self.mainView.bounds];
    iv.image = mbg;
    [self.mainView addSubview:iv];
    //self.mainView.backgroundColor = [[UIColor colorWithPatternImage:bg] colorWithAlphaComponent:1];
//    self.mainView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
//    self.mainView.layer.borderWidth = 3;
//    self.mainView.layer.cornerRadius = corner;
    [self addSubview:self.mainView];
    
    FBGlowLabel *titleLb = [[FBGlowLabel alloc] initWithFrame:CGRectMake(0, 0, w, 60)];
    titleLb.text = @"红包提现";
    titleLb.font = kFontBold(22);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = UIColorFromRGB(0x7a5e1a);
    //titleLb.textColor = FMBlackColor;
    
    [titleLb sizeToFit];
    float tw = titleLb.frame.size.width + 40;
    float th = titleLb.frame.size.height + 10;
    titleLb.frame = CGRectMake((w - tw)/2, 15, tw, th);
    titleLb.layer.cornerRadius = titleLb.frame.size.height/2;
    titleLb.backgroundColor = UIColorFromRGB(0xd6b461);
    titleLb.layer.masksToBounds = YES;
//    titleLb.glowSize = 20;
//    titleLb.innerGlowSize = 4;
//    titleLb.glowColor = UIColorFromRGB(0x5832b9);
//    titleLb.innerGlowColor = UIColorFromRGB(0xc44c4e);

    [self.mainView addSubview:titleLb];
    
    UILabel *blancelb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.mainView.frame.size.height/4-20, w, 50)];
    blancelb.font = kFontBold(28);
    blancelb.textAlignment = NSTextAlignmentCenter;
    blancelb.textColor = UIColorFromRGB(0xb52d18);
    blancelb.text = [NSString stringWithFormat:@"余额：%.2f元",[YunConfig getUserRedEnvelope]];
    [self.mainView addSubview:blancelb];
    _balanceLb = blancelb;
    
    // 关闭按钮
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake(w-15-25, 15, 25, 25)];
    UIImage *closeIcon = [UIImage imageNamed:@"lz_close_black_bt"];
    [closeBt setImage:closeIcon forState:UIControlStateNormal];
    closeBt.tag = 2;
    [closeBt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:closeBt];
    
    // 注释按钮
    UIButton *noteBt = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 25, 25)];
    UIImage *noteicon = [UIImage imageNamed:@"lz_note_icon"];
    [noteBt setImage:noteicon forState:UIControlStateNormal];
    noteBt.tag = 1;
    [noteBt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:noteBt];
    
    
    // 提现按钮
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    w = 80;
    h = 30;
    x = self.mainView.frame.size.width - w - 30;
    y = self.mainView.frame.size.height/2-50;
    
    UIButton *bt = [UIButton createDefaultButton:@"提现" frame:CGRectMake(x, y, w, h)];
    [bt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    bt.tag = 0;
//    bt.alpha = 0.9;
    bt.layer.cornerRadius = h/2;
    [self.mainView addSubview:bt];
    
    LDProgressView *progressView=[[LDProgressView alloc]initWithFrame:CGRectMake(30,y, self.mainView.frame.size.width-60-w-5, 30)];
    progressView.color = UIColorFromRGB(0xd45c47);
    progressView.progress = 0;
    progressView.animate = @NO;
    progressView.showText = @NO;
    //progressView.flat = @YES;
    progressView.type = LDProgressStripes;
    progressView.background = [[UIColor blackColor] colorWithAlphaComponent:1.0];
    //progressView.outerStrokeWidth = @1;
    _redenvelope_progress = progressView;
    [self.mainView addSubview:_redenvelope_progress];
    _redenvelope_progress_lable = [[UILabel alloc] initWithFrame:_redenvelope_progress.bounds];
    _redenvelope_progress_lable.font = kFontBold(14);
    _redenvelope_progress_lable.textAlignment = NSTextAlignmentCenter;
    _redenvelope_progress_lable.textColor = UIColorFromRGB(0xf9dfa6);
    [_redenvelope_progress addSubview:_redenvelope_progress_lable];
    
    // 邀请按钮
    NSArray *titles = @[@"邀请好友加速"];
    
    w = 180;
    h = bg.size.height/bg.size.width * w;
    x = (self.mainView.frame.size.width - w) / 2;
    y = self.mainView.frame.size.height - titles.count*(h+padding) - padding;
    
    for (int i=0; i<titles.count; i++) {
        UIButton *bt = [UIButton createDefaultButton:titles[i] frame:CGRectMake(x, y, w, h)];
        [bt addTarget:self action:@selector(shareImageAndTextToPlatformType) forControlEvents:UIControlEventTouchUpInside];
        bt.tag = 3;
        _yaoqingBt = bt;
        [self.mainView addSubview:bt];
        y += h + padding;
        bt = nil;
        
    }
    
    // 微信邀请好友加入游戏即可加速
    _introLb = [[YunLabel alloc] initWithFrame:CGRectMake(15, _redenvelope_progress.frame.origin.y+_redenvelope_progress.frame.size.height+10, self.mainView.frame.size.width-30, 20) borderWidth:1 borderColor:UIColorFromRGB(0xdd8a21)] ;
    _introLb.text = @"微信邀请好友加入游戏即可加速";
    _introLb.textColor = _redenvelope_progress.color;
    _introLb.font = kFont(14);
    _introLb.textAlignment = NSTextAlignmentCenter;
    [self.mainView addSubview:_introLb];
    //self.transform = CGAffineTransformScale(self.transform, 0, 0);
    
    // 活动倒计时
    _activityLb = [[YunLabel alloc] initWithFrame:CGRectMake(15, y-10, self.mainView.frame.size.width-30, 20) borderWidth:1 borderColor:UIColorFromRGB(0xdd8a21)] ;
    _activityLb.text = @"活动结束还有350天";
    _activityLb.textColor = [UIColor whiteColor];
    _activityLb.font = kFont(14);
    _activityLb.textAlignment = NSTextAlignmentCenter;
    [self.mainView addSubview:_activityLb];
    
    
}

// 生成用户分享的朋友列表
-(void)createUserListView:(NSArray*)list{
    YunConfig *config = [YunConfig getConfig];
    float w = 50;
    float h = 50;
    float y = self.mainView.frame.size.height/3*2 - h/2;
    if (!_userListView) {
        _userListView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, y, self.mainView.frame.size.width - 60, h+20)];
        _userListView.showsHorizontalScrollIndicator = YES;
        _userListView.showsVerticalScrollIndicator = NO;
        [self.mainView addSubview:_userListView];
        _userViews = [NSMutableArray new];
    }
    
    [_userViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_userViews removeAllObjects];
    
    UIImage *face = [UIImage imageNamed:@"wechat_icon"];
    NSString*userfacename = [YunConfig getUserFace];
    NSString*wxopenid = [YunConfig getUserWXOpenID];
    NSString *title = @"绑定微信";
    
    // 如果没有绑定微信，就显示一个绑定微信的图标和文字
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h+20)];
    // 头像
    UIButton *wx = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    if (![wxopenid isEqualToString:@""]) {
        if (![userfacename isEqualToString:@""]) {
            [wx sd_setImageWithURL:[NSURL URLWithString:userfacename] forState:UIControlStateNormal];
        }
        title = [NSString stringWithFormat:@"已加速%@元",config.bind_wechat_money];
    }else{
        [wx setImage:face forState:UIControlStateNormal];
    }
    
    
    wx.backgroundColor = [UIColor whiteColor];
    wx.layer.borderWidth = 2;
    wx.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    wx.layer.cornerRadius = h/2;
    wx.layer.masksToBounds = YES;
    if ([wxopenid isEqualToString:@""]) {
        [wx addTarget:self action:@selector(getAuthWithUserInfoFromWechat) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 文本
    UILabel *t = [[YunLabel alloc] initWithFrame:CGRectMake(0, h, w, 20) borderWidth:1 borderColor:UIColorFromRGB(0xdd8a21)];
    t.text = title;
    t.textAlignment = NSTextAlignmentCenter;
    t.font = kFont(12);
    t.adjustsFontSizeToFitWidth = YES;
    t.textColor = [UIColor whiteColor];
    
    [bg addSubview:wx];
    [bg addSubview:t];
    [_userViews addObject:bg];
    [_userListView addSubview:bg];
    
    if (list) {
        float x = bg.frame.size.width + bg.frame.origin.x + 10;
        y = bg.frame.origin.y;
        
        for (NSDictionary*item in list) {
            userfacename = item[@"face"];
            
            // 如果没有绑定微信，就显示一个绑定微信的图标和文字
            UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h+20)];
            // 头像
            UIButton *wx = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, h)];
            if (![userfacename isEqualToString:@""]) {
                [wx sd_setImageWithURL:[NSURL URLWithString:userfacename] forState:UIControlStateNormal];
            }else{
                [wx setImage:[UIImage imageNamed:@"logo180"] forState:UIControlStateNormal];
            }
            title = [NSString stringWithFormat:@"已加速%@元",config.bind_wechat_money];
            
            wx.backgroundColor = [UIColor whiteColor];
            wx.layer.borderWidth = 2;
            wx.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
            wx.layer.cornerRadius = h/2;
            wx.layer.masksToBounds = YES;
          
            // 文本
            UILabel *t = [[YunLabel alloc] initWithFrame:CGRectMake(0, h, w, 20) borderWidth:1 borderColor:UIColorFromRGB(0xdd8a21)];
            t.text = title;
            t.textAlignment = NSTextAlignmentCenter;
            t.font = kFont(12);
            t.adjustsFontSizeToFitWidth = YES;
            t.textColor = [UIColor whiteColor];
            
            [bg addSubview:wx];
            [bg addSubview:t];
            [_userViews addObject:bg];
            [_userListView addSubview:bg];
            x += w + 10;
        }
    }
}

-(void)updateView{
    YunConfig *config = [YunConfig getConfig];
    if (config) {
        float balance = [YunConfig getUserRedEnvelope];
        float enchashment_min = [config.enchashment_min floatValue];
        float bi = balance / enchashment_min;
        _redenvelope_progress.progress = bi;
        _redenvelope_progress_lable.text = [NSString stringWithFormat:@"%.1f%% 满%.f元可提现",(bi*100),enchashment_min];
        if (balance>=enchashment_min) {
            _redenvelope_progress_lable.text = [NSString stringWithFormat:@"恭喜您快去提现吧！"];
        }
        _balanceLb.text = [NSString stringWithFormat:@"余额：%.2f 元",balance];
        
        // 活动时间
        NSString *created_at = [YunConfig getUserCreatedAt];
        if (![created_at isEqualToString:@""]) {
            created_at = [created_at substringToIndex:10];
            // 活动有效天数
            int activity_day = [config.redenvelope_activity_time intValue];
            // 用户注册时间
            long createat = [[created_at stringToDateWithFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
            long now = [fn getTimestamp]/1000;
            long balance_at = activity_day * 24 * 60 * 60 + createat - now;
            int day = ceill(balance_at / (24 * 60 * 60));
            _activityLb.text = [NSString stringWithFormat:@"活动结束还有%d天",day];
            if (day<=0) {
                _activityLb.text = [NSString stringWithFormat:@"活动已结束"];
            }
        }else{
            _activityLb.text = [NSString stringWithFormat:@"活动已结束"];
        }
        
        // 是否绑定微信
        [self createUserListView:nil];
    }
    
}

-(void)hide{
    self.hidden = YES;
}

-(void)clickButton:(UIButton*)button{
    [self.say touchButton];
    if (button.tag==1) {
        // 注释
        [[YunWebView sharedSingleton] show:kAPI_RedenvelopeRule];;
        return;
    }
    if (button.tag==0) {
        // 提现
        YunEnchashmentViewController *enchashment = [[YunEnchashmentViewController alloc] initWithType:1];
        [(UINavigationController*)[AppDelegate sharedSingleton].window.rootViewController pushViewController:enchashment animated:YES];
        
    }
    if (button.tag==2) {
        // 关闭
    }
    
    
    if (self.magicBlock) {
        self.magicBlock(button,(int)button.tag);
    }
    [self hide];
}

-(void)getHttpFriendList{
    NSString *url = kAPI_Users_ShareFriends;
    WEAKSELF
    [http sendPostRequestWithParams:@{@"type":@"1"} api:url start:^{
        
    } failure:^{
       
    } success:^(NSDictionary *dic) {
        int code=[dic[@"code"] intValue];
        if (code==200) {
            NSDictionary *data = dic[@"data"];
            if (data) {
                NSArray *list = data[@"data"];
                if (list) {
                    [__weakSelf updateView];
                    [__weakSelf createUserListView:list];
                }
            }
            
        }
        
    }];
}

-(void)getHttpUserInfo{
    NSString *url = kAPI_Users_UserInfo;
    WEAKSELF
    [http sendPostRequestWithParams:nil api:url start:^{
        
    } failure:^{
       
    } success:^(NSDictionary *dic) {
        int code = [dic[@"code"] intValue];
        NSDictionary *data = dic[@"data"];
        if (code==200 && data) {
            NSDictionary *user = data[@"user"];
            [YunConfig setUserId:[NSString stringWithFormat:@"%@",user[@"id"]]];
            if (user) {
                user = [fn checkNullWithDictionary:user];
                NSLog(@"%@",user);
                //[YunConfig setUserInfoWithData:user];
                // 红包总的金额
                float redenvelope_amount = [user[@"redenvelope_amount"] floatValue];
                [YunConfig setUserRedEnvelope:redenvelope_amount];
            }
            [__weakSelf getHttpFriendList];
            //[[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_UserLoginSuccess object:nil];
        }else{
            FMHttpShowError(dic)
        }
        
    }];
}

// 绑定微信
- (void)getAuthWithUserInfoFromWechat
{
    [self.say touchButton];
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
                        // 绑定微信
                        //[BDAutoTrack accessAccountEventByType:@"wechat" isSuccess:YES];
                        // 更新
                        [__weakSelf updateView];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_GetRedEnvelope object:nil];
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


- (void)shareImageAndTextToPlatformType
{
    [self.say touchButton];
    WEAKSELF
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

@end
