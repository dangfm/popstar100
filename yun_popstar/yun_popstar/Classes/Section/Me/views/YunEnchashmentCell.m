//
//  YunEnchashmentCell.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/14.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunEnchashmentCell.h"

@implementation YunEnchashmentCell

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
    
    float x = 15;
    float y = 15;
    float w = UIScreenWidth - 2*y;
    float h = kYunEnchashmentCellHeight - y;
    _box = [[UIView alloc] initWithFrame:CGRectMake(x, 0, w, h)];
    _box.backgroundColor = [UIColor whiteColor];
    _box.layer.cornerRadius = 10;
    _box.layer.masksToBounds = YES;
    [self addSubview:_box];
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w-2*x, 17)];
    _titleLb.font = kFontBold(16);
    _titleLb.textColor = FMBlackColor;
    [_box addSubview:_titleLb];
    
    _statusLb = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w-2*x, 17)];
    _statusLb.font = kFont(16);
    _statusLb.textColor = FMGreyColor;
    _statusLb.textAlignment = NSTextAlignmentRight;
    [_box addSubview:_statusLb];
    
    _timeLb = [[UILabel alloc] initWithFrame:CGRectMake(x, y+17+5, w-2*x, 13)];
    _timeLb.font = kFont(12);
    _timeLb.textColor = FMGreyColor;
    _timeLb.textAlignment = NSTextAlignmentLeft;
    [_box addSubview:_timeLb];
    
}

-(void)setContentWithDic:(NSDictionary *)dic{
    dic = [fn checkNullWithDictionary:dic];
    NSString *title = dic[@"title"];
    NSString *time = dic[@"created_str"];
    NSString *status = dic[@"status_intro"];
    
    _titleLb.text = title;
    _statusLb.text = status;
    _timeLb.text = time;
}
@end
