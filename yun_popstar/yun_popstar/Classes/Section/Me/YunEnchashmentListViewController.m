//
//  YunEnchashmentListViewController.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/14.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunEnchashmentListViewController.h"

@interface YunEnchashmentListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YunEnchashmentListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
}
- (void)initView{
    _datas = [NSMutableArray new];
    [self initSay];
    [self initBackgroundView];
    [self initHeaderView];
    [self createTableView];
}
-(void)initHeaderView{
    if (!self.headerView) {
        float h = kNavigationHeight;
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, UIScreenWidth, h)];
        self.headerView.backgroundColor = [UIColor clearColor];
        
        YunLabel *title = [[YunLabel alloc] initWithFrame:self.headerView.bounds borderWidth:0 borderColor:UIColorFromRGB(0xdd8a21)];
        title.font = kFontBold(22);
        title.text = @"提现记录";
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
    
    [self addMJHeader];
}


-(void)initBackgroundView{
    if (!self.backgroundView) {
        self.backgroundView = [[YunPopstarBackgroundImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight)];
        //self.backgroundView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.backgroundView];
    }
}

-(void)initSay{
    self.say = [YunPopstarSay new];
}

// 点击返回按钮
-(void)clickCloseButton{
    [self.say touchButton];
    if (_backtop) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kYunEnchashmentCellHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifier = [NSString stringWithFormat:@"cell_%d_%d",(int)indexPath.section,(int)indexPath.row];
    YunEnchashmentCell *cell = [[YunEnchashmentCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIndentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setContentWithDic:_datas[indexPath.row]];
    
    return cell;
}

-(void)getHttpEnchashmentList{
    WEAKSELF
    _page ++;
    [http sendPostRequestWithParams:@{@"page":@(_page).stringValue} api:kAPI_Users_EnchashmentList start:^{
        
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
                [__weakSelf.datas addObjectsFromArray:list];
                if (data.count<per_page || __weakSelf.page>=last_page) {
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

@end
