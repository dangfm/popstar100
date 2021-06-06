//
//  YunTasksView.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/18.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunTasksView.h"
#import "EverydaySignInView.h"
@implementation YunTasksView

// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunTasksView *_sharedSingleton = nil;
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
    _datas = [NSMutableArray new];
    self.alpha = 1;
    [self initSay];
    self.frame = CGRectMake(0, 0, UIScreenWidth, UIScreenHeight);
    [[AppDelegate sharedSingleton].window addSubview:self];
    
    float w = UIScreenWidth-60;
    float h = 10 * 44 + 55 + 30;
    float x = 30;
    float y = (UIScreenHeight-h)/2;
    float corner = 30;
    float padding = 20;
    
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
    self.mainView.layer.masksToBounds = YES;
    [self addSubview:self.mainView];
    
    // 关闭按钮
    UIButton *closeBt = [[UIButton alloc] initWithFrame:CGRectMake((UIScreenWidth-20)/2, y+h + 30, 20, 20)];
    [closeBt setImage:[UIImage imageNamed:@"lz_close_bt"] forState:UIControlStateNormal];
    closeBt.tag = 2;
    [closeBt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBt];
    _closeBt = closeBt;
    
    //self.transform = CGAffineTransformScale(self.transform, 0, 0);
    UIImage *headerbg = [UIImage imageNamed:@"leaderboard-header-bg"];
    float hw = w - 30;
    float hh = headerbg.size.height/headerbg.size.width * hw;
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(x + 15, y - hh/2 , hw, hh)];
    header.image = headerbg;
    [self addSubview:header];
    UIImage *headertitle = [UIImage imageNamed:@"header-title-rwjl"];
    hh = 20;
    hw = headertitle.size.width/headertitle.size.height * hh;
    UIImageView *phb = [[UIImageView alloc] initWithFrame:CGRectMake((header.frame.size.width-hw)/2, (header.frame.size.height-hh)/2, hw, hh)];
    phb.image = headertitle;
    [header addSubview:phb];
    
    // 两个排行榜按钮 关卡排行，金币排行
    UIImage *titlebg = [UIImage imageNamed:@"leaderboard-title-bg-highlights"];
    float tw = (w-60-60)/2;
    float th = titlebg.size.height/titlebg.size.width * tw * 1.2;
    float tx = (w - 2*tw)/2;
    float ty = 40;
    UIButton *gkbt = [[UIButton alloc] initWithFrame:CGRectMake(tx, ty, tw, th)];
    gkbt.tag = 0;
    [gkbt setBackgroundImage:titlebg forState:UIControlStateNormal];
    UIImage *gkicon = [UIImage imageNamed:@"title-rcrw-icon"];
    gkicon = [UIImage scaleToSize:gkicon size:CGSizeMake(tw/3*2, gkicon.size.height/gkicon.size.width*(tw/3*2))];
    [gkbt setImage:gkicon forState:UIControlStateNormal];
    [gkbt addTarget:self action:@selector(clickOrderButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:gkbt];
    _passOrderBt = gkbt;
    
    UIButton *jbbt = [[UIButton alloc] initWithFrame:CGRectMake(tx+tw, ty, tw, th)];
    jbbt.tag = 1;
    [jbbt setBackgroundImage:[UIImage imageNamed:@"leaderboard-title-bg-default"] forState:UIControlStateNormal];
    UIImage *jbicon = [UIImage imageNamed:@"title-yxrw-icon"];
    jbicon = [UIImage scaleToSize:jbicon size:CGSizeMake(tw/3*2, jbicon.size.height/jbicon.size.width*(tw/3*2))];
    [jbbt setImage:jbicon forState:UIControlStateNormal];
    [jbbt addTarget:self action:@selector(clickOrderButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:jbbt];
    _goldOrderBt = jbbt;
    
    [self createTableViews];
}

-(void)createTableViews{
    if (!_tableView) {
        float x = 30;
        float y = _passOrderBt.frame.size.height+_passOrderBt.frame.origin.y+15;
        float w = self.mainView.frame.size.width - 60;
        float h = self.mainView.frame.size.height - y - 15;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.mainView addSubview:_tableView];
        [self addMJHeader];
    }
}

-(void)clickOrderButton:(UIButton*)bt{
    [self.say touchButton];
    [_datas removeAllObjects];
    [_tableView reloadData];
    if (bt.tag==0) {
        _type = 0;
        // 点击关卡排行
        [self updateOrderButtonHighlihgts:0];
    }else{
        _type = 1;
        // 点击金币排行
        [self updateOrderButtonHighlihgts:1];
    }
    [self.tableView.mj_header beginRefreshing];
}

-(void)updateOrderButtonHighlihgts:(int)tag{

    UIImage *titlebg = [UIImage imageNamed:@"leaderboard-title-bg-highlights"];
    UIImage *defaultbg = [UIImage imageNamed:@"leaderboard-title-bg-default"];
    
    if (tag==_passOrderBt.tag) {
        [_passOrderBt setBackgroundImage:titlebg forState:UIControlStateNormal];
        [_goldOrderBt setBackgroundImage:defaultbg forState:UIControlStateNormal];
    }else{
        defaultbg = [UIImage imageWithCGImage:defaultbg.CGImage scale:defaultbg.scale orientation:UIImageOrientationUpMirrored];
        titlebg = [UIImage imageWithCGImage:titlebg.CGImage scale:titlebg.scale orientation:UIImageOrientationUpMirrored];
        
        [_passOrderBt setBackgroundImage:defaultbg forState:UIControlStateNormal];
        [_goldOrderBt setBackgroundImage:titlebg forState:UIControlStateNormal];
    }
    
}


-(void)hide{
    self.hidden = YES;
}

-(void)clickButton:(UIButton*)button{
    [self.say touchButton];
    WEAKSELF
    
    [UIView animateWithDuration:0.8 animations:^{
        __weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        __weakSelf.hidden = YES;
    }];
    if (button.tag==1) {
        
    }
    if (button.tag==0) {
        // 马上评论
       

    }
    if (button.tag==2) {
        // 关闭
        
    }
   
    if (self.magicBlock) {
        self.magicBlock(button,(int)button.tag);
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kYunTasksCellHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifier = [NSString stringWithFormat:@"cell_%d_%d",(int)indexPath.section,(int)indexPath.row];
    YunTasksCell *cell = [[YunTasksCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIndentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setContentWithDic:_datas[indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = _datas[indexPath.row];
    NSString *push = item[@"push"];
    
    if ([push isEqualToString:@"everydaysign"]) {
        // 打开签到
        [[EverydaySignInView sharedSingleton] show];
    }
}


-(void)getHttpLeaderList{
    WEAKSELF
    _page ++;
    [http sendPostRequestWithParams:@{@"page":@(_page).stringValue,@"type":@(_type).stringValue} api:kAPI_Tasks start:^{
        
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
        [__weakSelf getHttpLeaderList];
       
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    header.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _tableView.mj_header = header;
    [_tableView.mj_header beginRefreshing];
    [self addMJFooter];
}
-(void)addMJFooter{
//    WEAKSELF
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [__weakSelf getHttpLeaderList];
//    }];
//    footer.hidden = YES;
//    footer.stateLabel.hidden = YES;
//    _tableView.mj_footer = footer;
}

@end
