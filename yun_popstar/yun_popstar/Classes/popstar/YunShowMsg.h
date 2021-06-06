//
//  YunShowMsg.h
//  yun_popstar
//
//  Created by dangfm on 2020/8/27.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBGlowLabel/FBGlowLabel.h>
NS_ASSUME_NONNULL_BEGIN

@interface YunShowMsg : UIView
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) FBGlowLabel *titleLb;
@property(nonatomic,retain) YunLabel *contentLb;
@property(nonatomic,retain) UIButton *closeBt;
@property(nonatomic,retain) UIButton *sureBt;
@property (nonatomic, strong) YunPopstarSay *say;
@property(nonatomic,copy) void(^sureBlock)(void);
@property(nonatomic,copy) void(^closeBlock)(void);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show:(NSString*)msg;
-(void)hide;
-(void)show:(NSString*)title content:(NSString*)content sure:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
