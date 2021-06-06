//
//  YunWebViewController.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/14.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunWebViewController.h"

@interface YunWebViewController ()<WKNavigationDelegate>

@end

@implementation YunWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

-(instancetype)initWithUrl:(NSString*)url{
    if (self=[super init]) {
        _url = url;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
//    self.navigationItem.title = @"提现";
//    float h = kNavigationHeight;
//    YunLabel *title = [[YunLabel alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, h) borderWidth:0 borderColor:UIColorFromRGB(0xdd8a21)];
//    title.font = kFontBold(22);
//    title.text = @"提现";
//    title.textColor = UIColorFromRGB(0x157efb);
//    title.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = title;
//
//    // 返回按钮
//    UIBarButtonItem *closeBt= [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"return_back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(clickCloseButton)];
//
//    self.navigationItem.backBarButtonItem = closeBt;
//
//    // 注释按钮
//    UIImage *icon = [[UIImage imageNamed:@"lz_note_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    icon = [UIImage scaleToSize:icon size:CGSizeMake(20, 20)];
//    UIBarButtonItem *noteBt= [[UIBarButtonItem alloc] initWithImage:icon style:UIBarButtonItemStyleDone target:self action:@selector(clickNoteButton)];
//
//    self.navigationItem.rightBarButtonItem = noteBt;
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
}
- (void)initView{
    [self initSay];
    [self initBackgroundView];
    [self initHeaderView];
    [self createWebView];

}

-(void)initHeaderView{
    if (!self.headerView) {
        UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, kStatusBarHeight)];
        statusbar.backgroundColor = [UIColor clearColor];
        [self.view addSubview:statusbar];
        
        float h = kNavigationHeight;
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, UIScreenWidth, h)];
        self.headerView.backgroundColor = [UIColor clearColor];
        
        YunLabel *title = [[YunLabel alloc] initWithFrame:self.headerView.bounds borderWidth:0 borderColor:UIColorFromRGB(0xdd8a21)];
        title.font = kFontBold(18);
        title.text = @"正在加载...";
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:title];
        _titleLb = title;
        // 返回按钮
        UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake(15, (h-20)/2 , 20, 20)];
        UIImage *closeicon = [UIImage imageNamed:@"return_back_icon"];
        //closeicon = [UIImage imageWithTintColor:[UIColor whiteColor] blendMode:kCGBlendModeDestinationIn WithImageObject:closeicon];
        [closeBt setImage:closeicon forState:UIControlStateNormal];
        [closeBt addTarget:self action:@selector(clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:closeBt];
        
//        // 注释按钮
//        UIButton *noteBt = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth - 25 - 15, (h-25)/2 , 25, 25)];
//        UIImage *noteicon = [UIImage imageNamed:@"lz_note_icon"];
//        [noteBt setImage:noteicon forState:UIControlStateNormal];
//        noteBt.tag = 1;
//        [noteBt addTarget:self action:@selector(clickNoteButton) forControlEvents:UIControlEventTouchUpInside];
//        //[self.headerView addSubview:noteBt];
//
        [self.view addSubview:self.headerView];
    }
}

-(void)createWebView{
    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavigationHeight, UIScreenWidth, UIScreenHeight-kStatusBarHeight-kNavigationHeight) configuration:webConfiguration];
    _webView.navigationDelegate = self;
    //_webView.layer.cornerRadius = 10;
    //_webView.layer.masksToBounds = YES;
    //_webView.scrollView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:_webView];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self loadUrl];
}

-(void)loadUrl{
    NSString *urlStr = _url;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
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

// 点击返回按钮
-(void)clickCloseButton{
    [self.say touchButton];
    [self.navigationController popViewControllerAnimated:YES];
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
