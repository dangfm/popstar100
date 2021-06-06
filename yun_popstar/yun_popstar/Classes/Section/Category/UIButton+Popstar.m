//
//  UIButton+Popstar.m
//  yun_popstar
//
//  Created by dangfm on 2020/8/20.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "UIButton+Popstar.h"

@implementation UIButton (Popstar)

+(UIButton*)createDefaultButton:(NSString*)title frame:(CGRect)frame{
//    UIImage *bg = [UIImage gradientColorImageFromColors:@[
//        UIColorFromRGB(0xffd05d),
//        UIColorFromRGB(0xffb500),
//        UIColorFromRGB(0xffa800),
//        UIColorFromRGB(0xffb500),
//        UIColorFromRGB(0xffd05d)
//    ] gradientType:GradientTypeTopToBottom imgSize:CGSizeMake(frame.size.width, frame.size.height)];
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    UIButton *bt = [[UIButton alloc] initWithFrame:frame];
    
    //文字
    YunLabel *tt = [[YunLabel alloc] initWithFrame:bt.bounds borderWidth:3 borderColor:UIColorFromRGB(0xdd8a21)];
    tt.text = title;
    tt.font = kFontBold(20);
    tt.textColor = [UIColor whiteColor];
    tt.textAlignment = NSTextAlignmentCenter;
    tt.tag = 101;
    [bt addSubview:tt];
    
//    [bt setTitle:title forState:UIControlStateNormal];
//    bt.titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt setBackgroundImage:bg forState:UIControlStateNormal];
//    bt.layer.cornerRadius = frame.size.height/2;
//    bt.layer.masksToBounds = YES;
//    bt.layer.borderWidth = 3;
//    bt.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4].CGColor;
    
    return bt;
    
}
+(UIButton*)createDefaultButton:(NSString*)title frame:(CGRect)frame size:(float)size{
    UIImage *bg = [UIImage imageNamed:@"yellow_button_bg"];
    UIButton *bt = [[UIButton alloc] initWithFrame:frame];
    
    //文字
    YunLabel *tt = [[YunLabel alloc] initWithFrame:bt.bounds borderWidth:3 borderColor:UIColorFromRGB(0xdd8a21)];
    tt.text = title;
    tt.font = kFontBold(size);
    tt.textColor = [UIColor whiteColor];
    tt.textAlignment = NSTextAlignmentCenter;
    tt.tag = 101;
    [bt addSubview:tt];
    [bt setBackgroundImage:bg forState:UIControlStateNormal];
    
    return bt;
    
}

+(UIButton*)createAdButton:(NSString*)title frame:(CGRect)frame{
    
    UIButton *bt = [UIButton createDefaultButton:title frame:frame];
    UIImage * bg1 = [UIImage imageNamed:@"button_icon_freead"];
    bg1 = [UIImage imageWithTintColor:UIColorFromRGB(0xdd8a21) blendMode:kCGBlendModeDestinationIn WithImageObject:bg1];
    UIImageView *icon = [[UIImageView alloc] initWithImage:bg1];
    icon.frame = CGRectMake(15, (frame.size.height-25)/2, 25, 25);
    [bt addSubview:icon];
    
    UIImage * bg = [UIImage imageNamed:@"button_icon_freead"];
    bg = [UIImage imageWithTintColor:[UIColor whiteColor] blendMode:kCGBlendModeDestinationIn WithImageObject:bg];
    UIImageView *iconfont = [[UIImageView alloc] initWithImage:bg];
    iconfont.frame = CGRectMake(2, 2, 25-4, 25-4);
    [icon addSubview:iconfont];
    icon.tag = 102;
    //bt.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    //bt.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);;
    YunLabel *tt = [bt viewWithTag:101];
    float fontWidth = [tt.text sizeWithAttributes:@{NSFontAttributeName:tt.font}].width;
    float iconWidth = icon.frame.origin.x + icon.frame.size.width + 10;
    if ((bt.frame.size.width - fontWidth) / 2 <= (iconWidth+10)) {
        // 字体变小点
        float size = (bt.frame.size.width - 2 * iconWidth) / (tt.text.length);
        tt.font = kFontBold(size);
    }
    
    return bt;
    
}

+(UIButton*)createGoldButton:(NSString*)title frame:(CGRect)frame{
    
    UIButton *bt = [UIButton createDefaultButton:title frame:frame];
    UIImage * bg1 = [UIImage imageNamed:@"lz_coin"];
    bg1 = [UIImage imageWithTintColor:UIColorFromRGB(0xdd8a21) blendMode:kCGBlendModeDestinationIn WithImageObject:bg1];
    UIImageView *icon = [[UIImageView alloc] initWithImage:bg1];
    icon.frame = CGRectMake(15, (frame.size.height-25)/2, 25, 25);
    [bt addSubview:icon];
    
    UIImage * bg = [UIImage imageNamed:@"lz_coin"];
    //bg = [UIImage imageWithTintColor:[UIColor whiteColor] blendMode:kCGBlendModeDestinationIn WithImageObject:bg];
    UIImageView *iconfont = [[UIImageView alloc] initWithImage:bg];
    iconfont.frame = CGRectMake(2, 2, 25-4, 25-4);
    [icon addSubview:iconfont];
    icon.tag = 102;
    
    //bt.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    //bt.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);;
    
    return bt;
    
}

@end
