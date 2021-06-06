//
//  YunChallengePassView.h
//  yun_popstar
//
//  Created by dangfm on 2020/10/6.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunChallengePassView : UIView
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) UIButton *sureBt;
@property(nonatomic,retain) UIImageView *statusIconView;
@property(nonatomic,retain) FBGlowLabel *titleLb;
@property(nonatomic,retain) FBGlowLabel *meLb;
@property(nonatomic,retain) FBGlowLabel *challengerLb;
@property (nonatomic, strong) YunPopstarSay *say;
@property (nonatomic, retain) NSDictionary* challenger;  // 挑战赛
@property (nonatomic, assign) float second;  // 挑战花费多少秒
@property(nonatomic,copy) void(^hideBlock)(void);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)showMsg:(NSDictionary*)challenger msg:(NSString*)msg;
-(void)showSuccess:(NSDictionary*)challenger seconds:(float)seconds popnum:(int)popnum;
-(void)showFail:(NSDictionary*)challenger seconds:(float)seconds popnum:(int)popnum;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
