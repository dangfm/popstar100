//
//  YunPlayStarViewBox.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/24.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunPlayStarViewBox : UIView
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) FBGlowLabel *titleLb;
@property(nonatomic,retain) UIButton *closeBt;
@property(nonatomic,retain) UIButton *popBt;
@property(nonatomic,retain) UIButton *shareBt;
@property(nonatomic,retain) UIButton *loveBt;
@property(nonatomic,retain) UILabel *userTitleLb;
@property (retain,nonatomic) NSMutableArray *gifImgs;
@property (retain,nonatomic) UIImage *gifimg;
@property (nonatomic, retain) YunStarPlayView *play;
@property (nonatomic, strong) YunPopstarSay *say;
@property (nonatomic, strong) NSMutableDictionary *cmds;
@property (nonatomic, strong) NSString *picurl;
@property(nonatomic,copy) void(^magicBlock)(UIButton *button,int index);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show:(NSMutableDictionary*)cmds;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
