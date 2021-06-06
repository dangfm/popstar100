//
//  YunGetGoldView.h
//  yun_popstar
//
//  Created by dangfm on 2020/8/22.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunGetGoldView : UIView
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) UIImageView *moneyBox;
@property(nonatomic,retain) NSMutableArray *goldViews;
@property(nonatomic,retain) YunLabel *introLb;
@property (nonatomic, strong) YunPopstarSay *say;
@property(nonatomic,retain) UIImageView *light_bg;
@property(nonatomic,retain) UIImageView *light_bg_2;
@property(nonatomic,retain) NSString *intro;
@property (nonatomic, assign) int type; //类型 0=默认 1=签到 2=免费激励 3=通关奖励 4=购买道具
@property (nonatomic, assign) int num;
@property(nonatomic,copy) void(^hideBlock)(void);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show:(int)num intro:(NSString*)intro type:(int)type;
-(void)show:(int)num intro:(NSString*)intro type:(int)type x:(float)x;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
