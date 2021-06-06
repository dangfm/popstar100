//
//  YunWinerListCell.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/17.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunWinerListCell.h"

@implementation YunWinerListCell

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
    float h = kYunWinerListCellHeight - y;
    _box = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w, h)];
    _box.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    _box.layer.cornerRadius = 10;
    _box.layer.masksToBounds = YES;
    [self addSubview:_box];
    
    _ordericon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 35, 35)];
    [_ordericon setImage:[UIImage imageNamed:@"leader-1-icon"]];
    _ordericon.layer.cornerRadius = _ordericon.frame.size.height/2;
    _ordericon.layer.masksToBounds = YES;
    [_box addSubview:_ordericon];
    
    _face = [[UIImageView alloc] initWithFrame:CGRectMake(15+35+15, 15, 35, 35)];
    [_face setImage:[UIImage imageNamed:@"logo180"]];
    _face.layer.cornerRadius = _face.frame.size.height/2;
    _face.layer.masksToBounds = YES;
    [_box addSubview:_face];
    
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(_face.frame.size.width+_face.frame.origin.x+15, y, w-(_face.frame.size.width+_face.frame.origin.x+30), 17)];
    _titleLb.font = kFont(16);
    _titleLb.textColor = [UIColor whiteColor];
    [_box addSubview:_titleLb];
    
    _statusLb = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 35, 35)];
    _statusLb.font = kFontBold(18);
    _statusLb.textColor = [UIColor whiteColor];
    _statusLb.textAlignment = NSTextAlignmentCenter;
//    _statusLb.layer.cornerRadius = _statusLb.frame.size.height/2;
//    _statusLb.layer.masksToBounds = YES;
   // _statusLb.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
//    _statusLb.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5].CGColor;
//    _statusLb.layer.borderWidth = 1;
    [_box addSubview:_statusLb];
    
    _timeLb = [[UILabel alloc] initWithFrame:CGRectMake(_titleLb.frame.origin.x, y+17+5, _titleLb.frame.size.width, 15)];
    _timeLb.font = kFontBold(14);
    _timeLb.textColor = [UIColor whiteColor];
    [_box addSubview:_timeLb];
    
}

-(void)setContentWithDic:(NSDictionary *)dic order:(int)order type:(int)type{
    dic = [fn checkNullWithDictionary:dic];
    NSString *nick_name = dic[@"nick_name"];
    NSString *face = dic[@"face"];
    int clearance_number = [dic[@"clearance_number"] intValue];
    int gold_balance = [dic[@"gold_balance"] intValue];
    NSString *status = [NSString stringWithFormat:@"%d",order+1];
    
    if (order<3) {
        _ordericon.hidden = NO;
        _statusLb.hidden = YES;
        [_ordericon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leader-%d-icon",(order+1)]]];
    }else{
        _ordericon.hidden = YES;
        _statusLb.hidden = NO;
        _statusLb.text = status;
    }
    if (face && ![face isEqualToString:@""]) {
        [_face sd_setImageWithURL:[NSURL URLWithString:face]];
    }
    
    
    _titleLb.text = nick_name;
    if (type<=0) {
        _timeLb.text = [NSString stringWithFormat:@"第%d关卡",clearance_number];
    }else{
        _timeLb.text = [NSString stringWithFormat:@"金币:%d个",gold_balance];
    }
    
}

@end
