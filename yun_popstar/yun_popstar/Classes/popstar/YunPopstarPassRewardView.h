//
//  YunPopstarPassRewardView.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/20.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunPopstarPassRewardView : UIView 

@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) UIImageView *giftImg;
@property(nonatomic,retain) UIButton *giftNumber;
@property(nonatomic,assign) int giftTag;
@property(nonatomic,assign) int last_giftTag;
@property(nonatomic,assign) int giftTagNumber;
@property(nonatomic,retain) UIButton *sureBt;
@property(nonatomic,retain) UIButton *closeBt;
@property(nonatomic,retain) UIButton *otherBt;
@property (nonatomic, strong) YunPopstarSay *say;
@property(nonatomic,retain) FBGlowLabel *titleLb;
@property(nonatomic,assign) BOOL ispass;
@property(nonatomic,retain) UIImageView *light_bg;
@property(nonatomic,retain) UIImageView *light_bg_2;
@property (assign,nonatomic) int num; // 剩余没有打爆的星星数量

@property(nonatomic,copy) void(^clickButtonBlock)(UIButton * _Nullable button);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show:(int)num;
-(void)showfail;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
