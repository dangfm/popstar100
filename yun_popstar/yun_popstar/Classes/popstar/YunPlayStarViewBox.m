//
//  YunPlayStarViewBox.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/24.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPlayStarViewBox.h"

@implementation YunPlayStarViewBox
// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunPlayStarViewBox *_sharedSingleton = nil;
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

-(void)show:(NSMutableDictionary *)cmds{
    _shareBt.hidden = YES;
    // 先拍照
    self.alpha = 1;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    
    _titleLb.text = [NSString stringWithFormat:@"第%@关回放",cmds[@"levels"]];
    _cmds = cmds;//[NSMutableDictionary dictionaryWithDictionary:[fn checkNullWithDictionary:[NSDictionary dictionaryWithDictionary:cmds]]];
    _picurl = _cmds[@"pic_gif"];
    _play.playBt.hidden = YES;
    [_loveBt setTitle:@"1.2w" forState:UIControlStateNormal];
    _userTitleLb.text = [NSString stringWithFormat:@"第%@关 分数%@",_cmds[@"levels"],_cmds[@"fraction"]];
    [_popBt setTitle:[NSString stringWithFormat:@"消灭星星 %@",_cmds[@"pop_num"]] forState:UIControlStateNormal];
    _popBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
//    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    anima2.fromValue = [NSNumber numberWithFloat:0];
//    anima2.toValue = [NSNumber numberWithFloat:1];
//    anima2.duration = 0.1;
//    [self.mainView.layer addAnimation:anima2 forKey:nil];
    WEAKSELF
    [fn sleepSeconds:0.2 finishBlock:^{
        UIImage *mainviewimg = [UIImage snapshot:__weakSelf.mainView scale:[UIScreen mainScreen].scale];
        __weakSelf.play.mainViewImg = mainviewimg;
        [fn sleepSeconds:0.2 finishBlock:^{
            __weakSelf.play.playBt.hidden = NO;
            __weakSelf.shareBt.hidden = NO;
            [__weakSelf.play play:cmds];
        }];
    }];
    [self updateMainView];
}
-(void)initViews{
    _gifImgs = [NSMutableArray new];
    self.alpha = 1;
    [self initSay];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [[AppDelegate sharedSingleton].window addSubview:self];
    
    float w = UIScreenWidth-60;
    float h = UIScreenHeight/3*2;
    float x = 30;
    float y = (UIScreenHeight-h)/2;
    float corner = 30;
    //float padding = 20;
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.8;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//    [self.maskView addGestureRecognizer:tap];
//    [self.maskView setUserInteractionEnabled:YES];
    [self addSubview:self.maskView];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.mainView.backgroundColor = [[UIColor colorWithPatternImage:FMDefaultBackgroundImage] colorWithAlphaComponent:1];
    self.mainView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    self.mainView.layer.borderWidth = 3;
    self.mainView.layer.cornerRadius = corner;
    [self addSubview:self.mainView];
    
    FBGlowLabel *titleLb = [[FBGlowLabel alloc] initWithFrame:CGRectMake(0, 0, w, 80)];
    titleLb.text = @"关卡回放";
    titleLb.font = kFontBold(35);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor whiteColor];
    titleLb.glowSize = 20;
    titleLb.innerGlowSize = 4;
    titleLb.textColor = UIColor.whiteColor;
    titleLb.glowColor = UIColorFromRGB(0x5832b9);
    titleLb.innerGlowColor = UIColorFromRGB(0xc44c4e);
    [self.mainView addSubview:titleLb];
    _titleLb = titleLb;
    
    // 关闭按钮
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake((UIScreenWidth-20)/2, y+h + kNavigationHeight, 20, 20)];
    [closeBt setImage:[UIImage imageNamed:@"lz_close_bt"] forState:UIControlStateNormal];
    closeBt.tag = 2;
    [closeBt addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBt];
    _closeBt = closeBt;

    [self createPlayViews];
    
    [self createUserInfo];
}

-(void)createUserInfo{
    float x = 30;
    float w = (self.mainView.frame.size.width-2*x);
    float h = 50;
    float y = _play.frame.origin.y + _play.frame.size.height + 10;
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [self.mainView addSubview:box];
    UIImageView *face = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    NSString *facesrc = [YunConfig getUserFace];
    [face sd_setImageWithURL:[NSURL URLWithString:facesrc] placeholderImage:[UIImage imageNamed:@"logo180"]];
    face.layer.cornerRadius = face.frame.size.height/2;
    face.layer.masksToBounds = YES;
    face.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    face.layer.borderWidth = 2;
    [box addSubview:face];
    
    // 关卡
    UILabel *levels = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, w - 40, 30)];
    levels.font = kFont(14);
    levels.textColor = [UIColor whiteColor];
    [box addSubview:levels];
    _userTitleLb = levels;
    
    // 消灭星星数量
    UIImage *popicon = [UIImage imageNamed:@"more_star_icon"];
    popicon = [UIImage scaleToSize:popicon size:CGSizeMake(35, popicon.size.height/popicon.size.width * 35)];
    UIButton *popbt = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 200, 30)];
    [popbt setImage:popicon forState:UIControlStateNormal];
    //popbt.imageView.contentMode = UIViewContentModeScaleAspectFit;
    popbt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //popbt.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    popbt.titleLabel.font = kFont(14);
    [popbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //popbt.backgroundColor = FMBlackColor;
    [box addSubview:popbt];
    _popBt = popbt;
    
    // 点赞数量
    UIImage *loveicon = [UIImage imageNamed:@"love_icon"];
    loveicon = [UIImage scaleToSize:loveicon size:CGSizeMake(40, loveicon.size.height/loveicon.size.width * 40)];
    UIButton *lovebt = [[UIButton alloc] initWithFrame:CGRectMake(w-loveicon.size.width, 0, loveicon.size.width, loveicon.size.height+20)];
    [lovebt setImage:loveicon forState:UIControlStateNormal];
    //popbt.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //lovebt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //popbt.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    lovebt.titleLabel.font = kFont(14);
    [lovebt setTitle:@"0" forState:UIControlStateNormal];
    [lovebt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //popbt.backgroundColor = FMBlackColor;
    lovebt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [lovebt setTitleEdgeInsets:UIEdgeInsetsMake(lovebt.imageView.frame.size.height+20 ,-lovebt.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [lovebt setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -lovebt.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    lovebt.alpha = 0.8;
    //[box addSubview:lovebt];
    _loveBt = lovebt;
    // 分享
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    w = 140;
    h = bg.size.height/bg.size.width * w;
    x = (self.mainView.frame.size.width - w) / 2;
    y = box.frame.size.height + box.frame.origin.y + 50;
//    y += 5;
    UIButton *bt2 = [UIButton createDefaultButton:@"分享" frame:CGRectMake(x, y, w, h)];
    //[self startButtonAnimation:bt2];
    [bt2 addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    bt2.tag = 1;
    [self.mainView addSubview:bt2];
    _shareBt = bt2;
    bt2 = nil;
    
}

-(void)updateMainView{
    UIView *lastView = self.mainView.subviews.lastObject;
    CGRect frame = self.mainView.frame;
    frame.size.height = lastView.frame.size.height + lastView.frame.origin.y + 15;
    frame.origin.y = (UIScreenHeight - frame.size.height) / 2;
    self.mainView.frame = frame;
}

-(void)createPlayViews{
    float x = 30;
    float w = (self.mainView.frame.size.width-2*x);
    float h = w;
    float y = 80;

    _play = [[YunStarPlayView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    _play.isRecordGif = YES;
    WEAKSELF
    _play.stopBlock = ^(NSString* picurl){
        if (picurl) {
            __weakSelf.picurl = picurl;
        }
    };
    _play.startplayBlock = ^{

    };
    
    [_mainView addSubview:_play];
    
}


-(void)hide{
    [self.say touchButton];
    WEAKSELF
     [UIView animateWithDuration:0.8 animations:^{
           __weakSelf.alpha = 0;
       } completion:^(BOOL finished) {
           __weakSelf.hidden = YES;
       }];
    
    [_play stop];
    [_play clear];
}

-(void)clickShareButton:(UIButton*)bt{
    // 消灭90个星星以上才能分享
    int pop_num = [_cmds[@"pop_num"] intValue];
    if (pop_num<90) {
        
        [[YunShowMsg sharedSingleton]show:@"消灭90个星星以上才可以分享哦！"];
        return;
    }
    _shareBt.enabled = NO;
    _picurl = _cmds[@"pic_gif"];
    if (!_picurl || [_picurl isEqual:[NSNull null]]) {
        _picurl = @"";
    }
    if (![_picurl isEqualToString:@""]) {
        // 已经存在的gif直接分享
        [self shareImageAndTextToPlatformType];
        self.shareBt.enabled = YES;
    }else{
        // 不存在的要播放一次
        if (_play.playOver) {
            WEAKSELF
            [_play shareAction:^(NSString * _Nonnull gif_url) {
                __weakSelf.shareBt.enabled = YES;
                if (gif_url) {
                    __weakSelf.picurl = gif_url;
                    //__weakSelf.play.playOver = NO;
                    __weakSelf.cmds[@"pic_gif"] = gif_url;
                    [__weakSelf shareImageAndTextToPlatformType];
                }
                
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"先播放一次，才能分享哦"];
            _shareBt.enabled = YES;
        }
        
        
    }
    
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
         NSString *des = [NSString stringWithFormat:@"第%@关，分数%@,消灭%@个星星，快来一起闯关吧！",__weakSelf.cmds[@"levels"],__weakSelf.cmds[@"fraction"],__weakSelf.cmds[@"pop_num"]];
         UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@恋上了消消消",[YunConfig getUserNickName]] descr:des thumImage:[UIImage imageNamed:@"logo180"]];
         //设置网页地址
         shareObject.webpageUrl = [NSString stringWithFormat:@"%@/user/share?uid=%@&gif=%@",kBaseURL,[YunConfig getUserId],__weakSelf.cmds[@"id"]];
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
