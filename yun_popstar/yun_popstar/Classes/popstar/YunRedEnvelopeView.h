//
//  YunRedEnvelopeView.h
//  yun_popstar
//
//  Created by dangfm on 2020/7/1.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunEnchashmentViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunRedEnvelopeView : UIView

@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property (retain,nonatomic) LDProgressView *redenvelope_progress;
@property (retain,nonatomic) UILabel *redenvelope_progress_lable;
@property (retain,nonatomic) UILabel *balanceLb;
@property (retain,nonatomic) UILabel *introLb;
@property (retain,nonatomic) UILabel *activityLb;
@property (retain,nonatomic) UIButton *yaoqingBt;
@property (retain,nonatomic) UIScrollView *userListView;
@property (retain,nonatomic) NSMutableArray *userViews;
@property (nonatomic, strong) YunPopstarSay *say;
@property(nonatomic,copy) void(^magicBlock)(UIButton *button,int index);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
