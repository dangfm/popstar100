//
//  YunShowFirstGoldView.h
//  yun_popstar
//
//  Created by dangfm on 2020/8/28.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunGetGoldView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunShowFirstGoldView : UIView
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) UIImageView *giftImg;
@property(nonatomic,retain) UIButton *giftNumber;
@property(nonatomic,assign) int giftTag;
@property(nonatomic,assign) int giftTagNumber;
@property(nonatomic,retain) UIButton *closeBt;
@property(nonatomic,retain) UIButton *otherBt;
@property (nonatomic, strong) YunPopstarSay *say;
@property(nonatomic,copy) void(^clickButtonBlock)(UIButton *button);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
