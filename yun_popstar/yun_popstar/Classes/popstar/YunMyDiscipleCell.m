//
//  YunMyDiscipleCell.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/18.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunMyDiscipleCell.h"

@implementation YunMyDiscipleCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

-(void)initViews{
    self.backgroundColor = [UIColor clearColor];
    UIView *selectView = [[UIView alloc] initWithFrame:self.frame];
    selectView.backgroundColor = [UIColor clearColor];;
    self.selectedBackgroundView = selectView;
    
    float x = 0;
    float y = 15;
    float w = UIScreenWidth - 60 - 60;
    float h = kYunMyDiscipleCellHeight - y;
    _box = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w, h)];
    _box.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    _box.layer.cornerRadius = 10;
    _box.layer.masksToBounds = YES;
    [self addSubview:_box];
    
    _face = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 35, 35)];
    [_face setImage:[UIImage imageNamed:@"logo180"]];
    _face.layer.cornerRadius = _face.frame.size.height/2;
    _face.layer.masksToBounds = YES;
    [_box addSubview:_face];
    
    //UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    float gw = 80;
    float gh = 30;
    _goldbt = [[UIButton alloc] initWithFrame:CGRectMake(w-15-gw, (h-gh)/2, gw, gh)];
    _goldbt.layer.cornerRadius = gh/2;
    _goldbt.layer.masksToBounds = YES;
    [_goldbt setTitle:@"拜师学艺" forState:UIControlStateNormal];
    [_goldbt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _goldbt.titleLabel.font = kFont(12);
    [_goldbt setBackgroundImage:[UIImage imageNamed:@"leaderboard-title-red-bg-highlights"] forState:UIControlStateNormal];
    [_box addSubview:_goldbt];
    [_goldbt addTarget:self action:@selector(clickBt:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(_face.frame.size.width+_face.frame.origin.x+15, y, w-_goldbt.frame.size.width, 17)];
    _titleLb.font = kFontBold(16);
    _titleLb.textColor = [UIColor whiteColor];
    _titleLb.adjustsFontSizeToFitWidth = YES;
    [_box addSubview:_titleLb];
    
    
    _introLb = [[UILabel alloc] initWithFrame:CGRectMake(_titleLb.frame.origin.x, y+17+5, _titleLb.frame.size.width, 15)];
    _introLb.font = kFont(12);
    _introLb.textColor = [UIColor whiteColor];
    [_box addSubview:_introLb];
    
    _goldLb = [[UILabel alloc] initWithFrame:CGRectMake(_titleLb.frame.origin.x, (h-15)/2, _titleLb.frame.size.width, 15)];
    _goldLb.font = kFont(14);
    _goldLb.textColor = [UIColor whiteColor];
    _goldLb.textAlignment = NSTextAlignmentRight;
    _goldLb.hidden = YES;
    [_box addSubview:_goldLb];
    
}

-(void)setContentWithDic:(NSDictionary *)dic type:(int)type{
    _type = type;
    dic = [fn checkNullWithDictionary:dic];
    _dic = dic;
    NSString *nick_name = dic[@"nick_name"];
    NSString *face = dic[@"face"];
    int clearance_number = [dic[@"clearance_number"] intValue];
    int accept = [dic[@"accept"] intValue];
    int gold_balance = [dic[@"gold_balance"] intValue];

    if (face && ![face isEqualToString:@""]) {
        [_face sd_setImageWithURL:[NSURL URLWithString:face]];
    }
    
    _titleLb.text = nick_name;
    _introLb.text = [NSString stringWithFormat:@"已完成%d关卡",clearance_number];
    
    if (accept==0) {
        [_goldbt setBackgroundImage:nil forState:UIControlStateNormal];
        [_goldbt setTitle:@"正在拜师" forState:UIControlStateNormal];
        _goldbt.userInteractionEnabled = NO;
        if (_type==0) {
            _goldbt.hidden = NO;
            [_goldbt setBackgroundImage:[UIImage imageNamed:@"leaderboard-title-red-bg-highlights"] forState:UIControlStateNormal];
            [_goldbt setTitle:@"收徒验证" forState:UIControlStateNormal];
            _goldbt.userInteractionEnabled = YES;
        }
    }
    if (accept==1) {
        [_goldbt setBackgroundImage:nil forState:UIControlStateNormal];
        [_goldbt setTitle:@"师傅" forState:UIControlStateNormal];
        _goldbt.userInteractionEnabled = NO;
        if (_type==0) {
            _goldbt.hidden = YES;
        }
    }
    
    if (accept==2) {
        [_goldbt setBackgroundImage:nil forState:UIControlStateNormal];
        [_goldbt setTitle:@"徒弟" forState:UIControlStateNormal];
        _goldbt.userInteractionEnabled = NO;
        if (_type==0) {
            _goldbt.hidden = YES;
        }
    }
    
    if (_type<=0) {
        _goldLb.hidden = NO;
        //gold_balance = gold_balance*[[YunConfig getConfig].master_get_disciple_gold intValue]/100;
        _goldLb.text = [NSString stringWithFormat:@"贡献金币 %d",gold_balance];
    }else{
        _goldLb.hidden = YES;
    }
    
}

-(void)clickBt:(UIButton*)bt{
    if (_type==1) {
        [self sendHttpDiscipleAsk:bt];
    }else{
        [self sendHttpDiscipleAccept:bt];
    }
}

-(void)sendHttpDiscipleAsk:(UIButton*)bt{
    [bt setBackgroundImage:nil forState:UIControlStateNormal];
    [bt setTitle:@"正在拜师" forState:UIControlStateNormal];
    bt.userInteractionEnabled = NO;
    // 点击拜师学艺
    NSLog(@"拜师学艺");
    // 师傅ID
    NSString *master_user_id = [NSString stringWithFormat:@"%@",_dic[@"id"]];
    [http sendPostRequestWithParams:@{@"master_user_id":master_user_id} api:kAPI_Users_DiscipleAsk start:^{
        [SVProgressHUD show];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"拜师失败，网络不给力啦！"];
        [bt setBackgroundImage:[UIImage imageNamed:@"leaderboard-title-red-bg-highlights"] forState:UIControlStateNormal];
        [bt setTitle:@"拜师学艺" forState:UIControlStateNormal];
        bt.userInteractionEnabled = YES;
    } success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        int code = [dic[@"code"] intValue];
        if (code==200) {
            // 拜师请求成功
            [bt setTitle:@"已发送" forState:UIControlStateNormal];
        }else{
            FMHttpShowError(dic)
            [bt setBackgroundImage:[UIImage imageNamed:@"leaderboard-title-red-bg-highlights"] forState:UIControlStateNormal];
            [bt setTitle:@"拜师学艺" forState:UIControlStateNormal];
            bt.userInteractionEnabled = YES;
        }
    }];
}

-(void)sendHttpDiscipleAccept:(UIButton*)bt{
    [bt setBackgroundImage:nil forState:UIControlStateNormal];
    [bt setTitle:@"正在收徒" forState:UIControlStateNormal];
    bt.userInteractionEnabled = NO;
    // 点击收徒
    NSLog(@"收徒学艺");
    // 拜师ID
    NSString *disciple_id = [NSString stringWithFormat:@"%@",_dic[@"id"]];
    [http sendPostRequestWithParams:@{@"disciple_id":disciple_id} api:kAPI_Users_DiscipleAccept start:^{
        [SVProgressHUD show];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"收徒失败，网络不给力啦！"];
        [bt setBackgroundImage:[UIImage imageNamed:@"leaderboard-title-red-bg-highlights"] forState:UIControlStateNormal];
        [bt setTitle:@"收徒验证" forState:UIControlStateNormal];
        bt.userInteractionEnabled = YES;
    } success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        int code = [dic[@"code"] intValue];
        if (code==200) {
            // 收徒请求成功
            [bt setTitle:@"收徒成功" forState:UIControlStateNormal];
        }else{
            FMHttpShowError(dic)
            [bt setBackgroundImage:[UIImage imageNamed:@"leaderboard-title-red-bg-highlights"] forState:UIControlStateNormal];
            [bt setTitle:@"收徒验证" forState:UIControlStateNormal];
            bt.userInteractionEnabled = YES;
        }
    }];
}
@end
