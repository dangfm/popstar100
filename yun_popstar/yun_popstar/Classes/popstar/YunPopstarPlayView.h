//
//  YunPopstarPlayView.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/16.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunPopstarPlayView : UIView
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) UIButton *redenvelopeBt;
@property(nonatomic,retain) UIButton *resetGameBt;
@property(nonatomic,retain) UIButton *continueBt;
@property (nonatomic, strong) YunPopstarSay *say;
@property (nonatomic, assign) BOOL isChallenge;  // 是否挑战赛
@property(nonatomic,copy) void(^magicBlock)(UIButton *button,int index);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show;
-(void)showChallenge;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
