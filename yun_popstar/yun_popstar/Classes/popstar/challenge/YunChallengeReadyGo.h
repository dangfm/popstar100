//
//  YunChallengeReadyGo.h
//  yun_popstar
//
//  Created by dangfm on 2020/10/5.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunChallengeReadyGo : UIView
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) UIButton *sureBt;
@property(nonatomic,retain) FBGlowLabel *countdownLb;
@property (nonatomic, strong) YunPopstarSay *say;
@property (nonatomic, retain) NSDictionary* challenger;  // 挑战赛
@property(nonatomic,copy) void(^hideBlock)(void);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show:(NSDictionary*)challenger;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
