//
//  YunCommunityListCell.m
//  yun_popstar
//
//  Created by dangfm on 2020/10/2.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunCommunityListCell.h"

@implementation YunCommunityListCell
-(void)dealloc{
    NSLog(@"YunCommunityListCell dealloc");
    [_playView stop];
    [_playView free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

-(void)initViews{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay:) name:kNSNotificationName_LevesStartBackPlay object:nil];
    self.backgroundColor = [UIColor clearColor];
    float x = 15;
    float y = 15;
    float w = UIScreenWidth - 2*y;
    float h = kYunCommunityListCellHeight - y;
    _box = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w, h)];
    _box.backgroundColor = [UIColor whiteColor];
    _box.layer.cornerRadius = 10;
    _box.layer.masksToBounds = YES;
    [self addSubview:_box];
    
    UIView *selectView = [[UIView alloc] initWithFrame:_box.frame];
    selectView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.selectedBackgroundView = selectView;
    
    _face = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 35, 35)];
    [_face setImage:[UIImage imageNamed:@"logo180"]];
    _face.layer.cornerRadius = _face.frame.size.height/2;
    _face.layer.masksToBounds = YES;
    [_box addSubview:_face];
    
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(x+35+5, y, w-2*x-40, 17)];
    _titleLb.font = kFontBold(16);
    _titleLb.textColor = FMBlackColor;
    [_box addSubview:_titleLb];
    
    _timeLb = [[UILabel alloc] initWithFrame:CGRectMake(x+35+5, y+17+5, w-2*x-40, 13)];
    _timeLb.font = kFont(12);
    _timeLb.textColor = FMGreyColor;
    _timeLb.textAlignment = NSTextAlignmentLeft;
    [_box addSubview:_timeLb];
    
    _statusLb = [[UILabel alloc] initWithFrame:CGRectMake(x+35+5, y+17+5+13+5, w-2*x-40, 13)];
    _statusLb.font = kFont(12);
    _statusLb.textColor = FMGreyColor;
    _statusLb.textAlignment = NSTextAlignmentLeft;
    [_box addSubview:_statusLb];
    
    _secondLb = [[UILabel alloc] initWithFrame:CGRectMake(x+35+5, _statusLb.frame.size.height+_statusLb.frame.origin.y+5, w-2*x-40, 13)];
    _secondLb.font = kFont(12);
    _secondLb.textColor = FMGreyColor;
    _secondLb.textAlignment = NSTextAlignmentLeft;
    [_box addSubview:_secondLb];
    
    _popLb = [[UILabel alloc] initWithFrame:CGRectMake(x+35+5+25+5, _secondLb.frame.size.height+_secondLb.frame.origin.y+10, w-2*x, 16)];
    _popLb.font = kFont(16);
    _popLb.textColor = FMBlackColor;
    _popLb.textAlignment = NSTextAlignmentLeft;
    [_box addSubview:_popLb];
    
    _popIcon = [[UIImageView alloc] initWithFrame:CGRectMake(x+35+5, _popLb.frame.origin.y-6, 25, 25)];
    _popIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"more_star_icon"]];
    [_box addSubview:_popIcon];
    
    // 播放
    _playView = [[YunStarPlayView alloc] initWithFrame:CGRectMake(x+35+5, _popIcon.frame.size.height+_popIcon.frame.origin.y+5, 202, 202)];
    [_box addSubview:_playView];
    
    _playBt = [[UIButton alloc] initWithFrame:CGRectMake(w - 30 - 15, (h-30)/2, 30, 30)];
    [_playBt setImage:[UIImage imageNamed:@"play_list_play_icon"] forState:UIControlStateNormal];
    //[_box addSubview:_playBt];
    
    // 挑战按钮
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    w = 100;
    h = bg.size.height/bg.size.width * w;
    x = _box.frame.size.width - w - 15;
//    y += 5;
    UIButton *bt2 = [UIButton createDefaultButton:@"挑战Ta" frame:CGRectMake(x, y, w, h)];
    [bt2 addTarget:self action:@selector(clickChallengeButton:) forControlEvents:UIControlEventTouchUpInside];
    bt2.tag = 1;
    [_box addSubview:bt2];
    _challengeBt = bt2;

}

-(void)setContentWithDic:(NSDictionary *)dic{
    dic = [fn checkNullWithDictionary:dic];
    NSString *face = dic[@"face"];
    NSString *title = [NSString stringWithFormat:@"%@ 第 %@ 关",dic[@"nick_name"],dic[@"levels"]];
    NSString *time = dic[@"created_at"];
    time = [time replaceAll:@"T" target:@" "];
    time = [time replaceAll:@".000000Z" target:@""];
    NSString *status = [NSString stringWithFormat:@"分数 %@",dic[@"fraction"]];
    NSString *pop_num = [NSString stringWithFormat:@"消灭%@星星",dic[@"pop_num"]];
    NSString *second = [NSString stringWithFormat:@"时间 %d秒",(int)[dic[@"milliseconds"] floatValue]/1000];
    _titleLb.text = title;
    _statusLb.text = status;
    _timeLb.text = time;
    _popLb.text = pop_num;
    _secondLb.text = second;
    [_face sd_setImageWithURL:[NSURL URLWithString:face] placeholderImage:[UIImage imageNamed:@"logo180"]];
    //[_playView stop];
    [_playView play:[NSMutableDictionary dictionaryWithDictionary:dic]];
    
    // 是否挑战过
    BOOL ischallenge = [dic[@"ischallenge"] boolValue];
    if (ischallenge) {
        _challengeBt.enabled = NO;
    }else{
        _challengeBt.enabled = YES;
    }
}

-(void)clickChallengeButton:(UIButton*)bt{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_LevesStartBackPlay object:nil userInfo:@{@"me":@""}];
    if (_clickChallengeBlock) {
        _clickChallengeBlock();
    }
}

-(void)stopPlay:(NSNotification*)noti{
    NSDictionary *userinfo = noti.userInfo;
    YunStarPlayView *p = userinfo[@"me"];
    if (![p isEqual:_playView]) {
        [_playView pause];
    }
    
}
@end
