//
//  YunPlayCell.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/22.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPlayCell.h"

@implementation YunPlayCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

-(void)initViews{
    self.backgroundColor = [UIColor clearColor];
    
    float x = 15;
    float y = 15;
    float w = UIScreenWidth - 2*y;
    float h = kYunPlayCellHeight - y;
    _box = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w, h)];
    _box.backgroundColor = [UIColor whiteColor];
    _box.layer.cornerRadius = 10;
    _box.layer.masksToBounds = YES;
    [self addSubview:_box];
    
    UIView *selectView = [[UIView alloc] initWithFrame:_box.frame];
    selectView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.selectedBackgroundView = selectView;
    
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w-2*x, 17)];
    _titleLb.font = kFontBold(16);
    _titleLb.textColor = FMBlackColor;
    [_box addSubview:_titleLb];
    
    _timeLb = [[UILabel alloc] initWithFrame:CGRectMake(x, y+17+5, w-2*x, 13)];
    _timeLb.font = kFont(12);
    _timeLb.textColor = FMGreyColor;
    _timeLb.textAlignment = NSTextAlignmentLeft;
    [_box addSubview:_timeLb];
    
    _statusLb = [[UILabel alloc] initWithFrame:CGRectMake(x, y+17+5+13+5, w-2*x, 13)];
    _statusLb.font = kFont(12);
    _statusLb.textColor = FMGreyColor;
    _statusLb.textAlignment = NSTextAlignmentLeft;
    [_box addSubview:_statusLb];
    
    _popLb = [[UILabel alloc] initWithFrame:CGRectMake(w/2, (h-16)/2, w-2*x, 16)];
    _popLb.font = kFont(16);
    _popLb.textColor = FMBlackColor;
    _popLb.textAlignment = NSTextAlignmentLeft;
    [_box addSubview:_popLb];
    
    _popIcon = [[UIImageView alloc] initWithFrame:CGRectMake(w/2-30, (h-25)/2-2, 25, 25)];
    _popIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"more_star_icon"]];
    [_box addSubview:_popIcon];
    
    _playBt = [[UIButton alloc] initWithFrame:CGRectMake(w - 30 - 15, (h-30)/2, 30, 30)];
    [_playBt setImage:[UIImage imageNamed:@"play_list_play_icon"] forState:UIControlStateNormal];
    [_box addSubview:_playBt];
    
}

-(void)setContentWithDic:(NSDictionary *)dic{
    dic = [fn checkNullWithDictionary:dic];
    NSString *title = [NSString stringWithFormat:@"第 %@ 关",dic[@"levels"]];
    NSString *time = dic[@"created_at"];
    time = [time replaceAll:@"T" target:@" "];
    time = [time replaceAll:@".000000Z" target:@""];
    NSString *status = [NSString stringWithFormat:@"分数 %@",dic[@"fraction"]];
    NSString *cmds = dic[@"cmds"];
    NSString *pop_num = [NSString stringWithFormat:@"消灭%@星星",dic[@"pop_num"]];
    if (cmds) {
        _playBt.hidden = NO;
    }else{
        _playBt.hidden = YES;
    }
    _titleLb.text = title;
    _statusLb.text = status;
    _timeLb.text = time;
    _popLb.text = pop_num;
}

@end
