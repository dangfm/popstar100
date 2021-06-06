//
//  YunPopstarShowMsgView.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/16.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBGlowLabel/FBGlowLabel.h>
#import "MCSteamView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunPopstarShowMsgView : UIView
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) FBGlowLabel *titleView;
@property(nonatomic,retain) UIImageView *msgView;
@property(nonatomic,retain) MCSteamView *steamView;
@property(nonatomic,copy) void(^magicBlock)(UIButton *button,int index);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show;
-(void)hide;
-(void)showMsg:(NSString*)msg;
-(void)showNice;
-(void)showCool;
-(void)showGood;
-(void)showWellDone;
-(void)showVeryGood;
-(void)showPerfect;
-(void)showReadyGo;
-(void)showPassTarget;
-(void)showVeryPerfect;
@end

NS_ASSUME_NONNULL_END
