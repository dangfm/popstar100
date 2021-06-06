//
//  YunPopstarMagicView.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/15.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunPopstarButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface YunPopstarMagicView : UIView
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,copy) void(^magicBlock)(PopstarColor color,BOOL success);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
