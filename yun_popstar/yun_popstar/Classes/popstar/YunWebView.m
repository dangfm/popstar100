//
//  YunWebView.m
//  yun_popstar
//
//  Created by dangfm on 2020/8/28.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunWebView.h"

@implementation YunWebView

// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunWebView *_sharedSingleton = nil;
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
-(void)showPrivate:(NSString *)url{
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    float h = 44;
    float w = bg.size.width/bg.size.height * h;
    float x = (self.mainView.frame.size.width - w) / 2;
    float y = self.mainView.frame.size.height - 2*(h + 15);
    _sureBt.frame = CGRectMake(x, y, w, h);
    _noBt.frame = CGRectMake(x, y+h + 15, w, h);
    YunLabel *l = [_sureBt viewWithTag:101];
    l.text = @"同意";
    _noBt.hidden = NO;
    
    _url = url;
    _webView.frame = CGRectMake(10, 74, self.mainView.frame.size.width - 20, self.mainView.frame.size.height-44-30 -44-30 - 44 -15);
    [self loadUrl];
    self.alpha = 1;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
}
-(void)show:(NSString *)url{
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    float h = 44;
    float w = bg.size.width/bg.size.height * h;
    float x = (self.mainView.frame.size.width - w) / 2;
    float y = self.mainView.frame.size.height - (h + 15);
    _sureBt.frame = CGRectMake(x, y, w, h);
    YunLabel *l = [_sureBt viewWithTag:101];
    l.text = @"关闭";
    _noBt.hidden = YES;
    _url = url;
    _webView.frame = CGRectMake(10, 74, self.mainView.frame.size.width - 20, self.mainView.frame.size.height-44-30 -44-30);
    [self loadUrl];
    self.alpha = 1;
    [[AppDelegate sharedSingleton].window bringSubviewToFront:self];
    self.hidden = NO;
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0];
    anima2.toValue = [NSNumber numberWithFloat:1];
    anima2.duration = 0.1;
    [self.mainView.layer addAnimation:anima2 forKey:nil];
}
-(void)initViews{
    self.alpha = 1;
    [self initSay];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [[AppDelegate sharedSingleton].window addSubview:self];
    
    float w = UIScreenWidth-60;
    float h = UIScreenHeight/3*2;
    float x = 30;
    float y = (UIScreenHeight-h)/2;
    float corner = 30;
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.8;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.maskView addGestureRecognizer:tap];
    [self.maskView setUserInteractionEnabled:YES];
    [self addSubview:self.maskView];
    
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.mainView.backgroundColor = [[UIColor colorWithPatternImage:FMDefaultBackgroundImage] colorWithAlphaComponent:1];
    self.mainView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
    self.mainView.layer.borderWidth = 3;
    self.mainView.layer.cornerRadius = corner;
    [self addSubview:self.mainView];
    
    FBGlowLabel *titleLb = [[FBGlowLabel alloc] initWithFrame:CGRectMake(0, 0, w, 74)];
    titleLb.text = @"正在加载...";
    titleLb.font = kFontBold(20);
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.textColor = [UIColor whiteColor];
    titleLb.glowSize = 10;
    titleLb.innerGlowSize = 4;
    titleLb.textColor = UIColor.whiteColor;
    titleLb.glowColor = UIColorFromRGB(0x5832b9);
    titleLb.innerGlowColor = UIColorFromRGB(0xc44c4e);
    _titleLb = titleLb;
    [self.mainView addSubview:titleLb];
    
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    h = 44;
    w = bg.size.width/bg.size.height * h;
    x = (self.mainView.frame.size.width - w) / 2;
    y = self.mainView.frame.size.height - h - 15;
    
    UIButton *bt = [UIButton createDefaultButton:@"关闭" frame:CGRectMake(x, y, w, h)];
    [bt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    bt.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bt.tag = 0;
    [self.mainView addSubview:bt];
    _sureBt = bt;
    
    UIButton *no = [[UIButton alloc] initWithFrame:CGRectMake(x, y+h+15, w, h)];
    [no setTitle:@"不同意，退出" forState:UIControlStateNormal];
    [no setImage:nil forState:UIControlStateNormal];
    [no addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    no.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [no setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    no.tag = 1;
    [self.mainView addSubview:no];
    _noBt = no;
    [self createWebView];
    
  
}

-(void)createWebView{
    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 74, self.mainView.frame.size.width - 20, self.mainView.frame.size.height-44-30 -44-30) configuration:webConfiguration];
    _webView.navigationDelegate = self;
    _webView.layer.cornerRadius = 10;
    _webView.layer.masksToBounds = YES;
    _webView.scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.mainView addSubview:_webView];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)loadUrl{
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView evaluateJavaScript:@"document.body.innerHTML='';" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        //do anything
    }];
    NSString *urlStr = _url;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
}

-(void)hide{
    self.hidden = YES;
}

-(void)clickButton:(UIButton*)bt{
    [self.say touchButton];
    [self hide];
    if (self.buttonBlock) {
        self.buttonBlock(bt, bt.tag);
    }
}

// 加载出错
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;{
    
}

// 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
  
}

// 根据监听 实时修改title
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView)
        {
            _titleLb.text = self.webView.title;
        }
        else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }
    
}

//移除监听
- (void)dealloc{
        [_webView removeObserver:self forKeyPath:@"title" context:nil];
}
@end
