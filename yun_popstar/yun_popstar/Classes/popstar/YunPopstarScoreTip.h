//
//  YunPopstarScoreTip.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/10.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunPopstarScoreTip : UIView
@property (nonatomic, strong) CAEmitterLayer * fireworksLayer;
@property (nonatomic, strong) UIButton * starBt;
@property(assign,nonatomic) int scroe;
@property (nonatomic, strong) YunPopstarSay *say;
-(instancetype)initWithFrame:(CGRect)frame color:(int)color;
-(instancetype)initWithFrame:(CGRect)frame color:(int)color scroe:(int)scroe;
-(void)hide;
-(void)hideself;
@end

NS_ASSUME_NONNULL_END
