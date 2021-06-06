//
//  YunTasksCell.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/18.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunTasksCell.h"

@implementation YunTasksCell

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
    float h = kYunTasksCellHeight - y;
    _box = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w, h)];
    _box.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    _box.layer.cornerRadius = 10;
    _box.layer.masksToBounds = YES;
    [self addSubview:_box];
    
    //UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    float gw = 80;
    float gh = 30;
    _goldbt = [UIButton createGoldButton:@"" frame:CGRectMake(w-15-gw, (h-gh)/2, gw, gh)];
    _goldbt.userInteractionEnabled = NO;
    [_box addSubview:_goldbt];
    
     _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, y, w-30-_goldbt.frame.size.width, 17)];
    _titleLb.font = kFontBold(16);
    _titleLb.textColor = [UIColor whiteColor];
    _titleLb.adjustsFontSizeToFitWidth = YES;
    [_box addSubview:_titleLb];
    
    
    _introLb = [[UILabel alloc] initWithFrame:CGRectMake(_titleLb.frame.origin.x, y+17+5, _titleLb.frame.size.width, 15)];
    _introLb.font = kFont(14);
    _introLb.textColor = [UIColor whiteColor];
    [_box addSubview:_introLb];
    
}

-(void)setContentWithDic:(NSDictionary *)dic{
    dic = [fn checkNullWithDictionary:dic];
    NSString *intro = dic[@"intro"];
    NSString *name = dic[@"name"];
    int gold = [dic[@"gold"] intValue];
    //NSString *push = dic[@"push"];
   
    _titleLb.text = name;
    _introLb.text = intro;
    
    YunLabel *l = [_goldbt viewWithTag:101];
    l.text = [NSString stringWithFormat:@"%d",gold];
    l.font = kFontBold(14);
    l.mj_x = 10;
    UIImageView *icon = [_goldbt viewWithTag:102];
    icon.mj_x = 10;
    icon.mj_w = 20;
    icon.mj_h = 20;
    icon.mj_y = 5;
    UIImageView *subicon = [icon subviews].firstObject;
    subicon.mj_w = 20-4;
    subicon.mj_h = 20-4;
        
}

@end
