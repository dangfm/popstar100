//
//  YunPlayPopStarViewController.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/22.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPlayPopStarViewController.h"

@interface YunPlayPopStarViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YunPlayPopStarViewController
-(void)dealloc{

    NSLog(@"YunPlayPopStarViewController dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}
-(instancetype)initWityCmds:(NSArray*)cmds{
    if (self=[super init]) {
        _cmds = cmds;
    }
    return self;
}
- (void)initView{
    _datas = [NSMutableArray new];
    [self initBackgroundView];
    [self initSay];
    [self initHeaderView];
    [self createTableView];
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
        float h = kNavigationHeight;
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, UIScreenWidth, h)];
        self.headerView.backgroundColor = [UIColor clearColor];
        
        YunLabel *title = [[YunLabel alloc] initWithFrame:self.headerView.bounds borderWidth:0 borderColor:UIColorFromRGB(0xdd8a21)];
        title.font = kFontBold(22);
        title.text = @"回放";
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:title];
        
        // 返回按钮
        UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake(15, (h-25)/2 , 25, 25)];
        UIImage *closeicon = [UIImage imageNamed:@"return_back_icon"];
        [closeBt setImage:closeicon forState:UIControlStateNormal];
        [closeBt addTarget:self action:@selector(clickCloseButton) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:closeBt];
        
  
        [self.view addSubview:self.headerView];
    }
}
-(void)initSay{
    self.say = [YunPopstarSay new];
}
// 点击返回按钮
-(void)clickCloseButton{
    [self.say touchButton];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavigationHeight+15, UIScreenWidth, UIScreenHeight-kStatusBarHeight-kNavigationHeight-15)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    _tableView.clickBackgroundViewBlock = ^{
//        NSLog(@"ffff");
//    };
    [self.view addSubview:_tableView];
    [self loadFeedAds];
    [self addMJHeader];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kYunPlayCellHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifier = @"cell";//[NSString stringWithFormat:@"cell_%d_%d",(int)indexPath.section,(int)indexPath.row];
//    YunPlayCell *cell = [[YunPlayCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                  reuseIdentifier:cellIndentifier];
    YunPlayCell *cell = (YunPlayCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil) {
        cell = [[YunPlayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setContentWithDic:_datas[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.say touchButton];
    NSMutableDictionary *item = _datas[indexPath.row];
    if(item){
        NSArray *cmds = [item[@"cmds"] mj_JSONObject];
        if (cmds) {
            [[YunPlayStarViewBox sharedSingleton] show:item];
        }
        
    }
}

-(void)getHttpEnchashmentList{
    WEAKSELF
    _page ++;
    [http sendPostRequestWithParams:@{@"page":@(_page).stringValue} api:kAPI_Users_LevelsList start:^{
        
    } failure:^{
        [__weakSelf.tableView.mj_header endRefreshing];
        [__weakSelf.tableView.mj_footer endRefreshing];
        __weakSelf.page --;
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        [__weakSelf.tableView showDataCount:0 msg:@"网络不给力" block:^{
            // 点击
            NSLog(@"点击。。。");
        }];
    } success:^(NSDictionary *dic) {
        [__weakSelf.tableView.mj_header endRefreshing];
        [__weakSelf.tableView.mj_footer endRefreshing];
        int code=[dic[@"code"] intValue];
        if (code==200) {
            NSDictionary *data = dic[@"data"];
            if (data) {
                int last_page = [data[@"last_page"] intValue];
                int per_page = [data[@"per_page"] intValue];
                NSArray *list = data[@"data"];
                if (__weakSelf.page<=1) {
                    [__weakSelf.datas removeAllObjects];
                }
                for (NSDictionary *item in list) {
                    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:item];
                    [__weakSelf.datas addObject:d];
                    d = nil;
                }
                
                if (list.count<per_page || __weakSelf.page>=last_page) {
                    [__weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    __weakSelf.tableView.mj_footer.hidden = NO;
                    [__weakSelf.tableView.mj_footer resetNoMoreData];
                }
                [__weakSelf.tableView reloadData];
                
                
            }
        }else{
            __weakSelf.page --;
            FMHttpShowError(dic)
        }
        
        [__weakSelf.tableView showDataCount:__weakSelf.datas.count msg:@"暂无数据" block:^{
            // 点击
            NSLog(@"点击。。。");
            [__weakSelf.tableView.mj_header beginRefreshing];
        }];
    }];
}
-(void)addMJHeader{
    WEAKSELF
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __weakSelf.page = 0;
        [__weakSelf getHttpEnchashmentList];
       
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = [UIColor whiteColor];
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];
    [self addMJFooter];
}
-(void)addMJFooter{
    WEAKSELF
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [__weakSelf getHttpEnchashmentList];
    }];
    footer.hidden = YES;
    footer.stateLabel.textColor = [UIColor whiteColor];
    _tableView.mj_footer = footer;
}

// 信息流广告
- (void)loadFeedAds {
    YunConfig *config = [YunConfig getConfig];
    if (config) {
        if([config.open_ads indexOf:kCsj_sloteid_945515121]!=NSNotFound){
            if (!_expressViewBox) {
                float bili = 690.0/388.0;
                float x = 0;
                float w = self.tableView.frame.size.width-30;
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
                _tableView.tableHeaderView = box;
            }
            self.expressAdViews = [NSMutableArray new];
            BUAdSlot *slot1 = [[BUAdSlot alloc] init];
            slot1.ID = kCsj_sloteid_945515121;
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
