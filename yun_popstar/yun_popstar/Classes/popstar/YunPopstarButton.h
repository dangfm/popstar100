//
//  YunPopstarButton.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/6.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>


NS_ASSUME_NONNULL_BEGIN
@class YunPopstarButton;
typedef enum {
    red_popstar,
    green_popstar,
    yellow_popstar,
    blue_popstar,
    purple_popstar
} PopstarColor;
// 清除后回调
typedef void(^ClearPopstarBlock)(YunPopstarButton *me,BOOL isClear);
typedef void(^MoveDownComplateBlock)(YunPopstarButton *me, BOOL finished);

@interface YunPopstarButton : UIButton
@property(retain,nonatomic) UIImageView *bg;
@property(assign,nonatomic) PopstarColor color;
@property(assign,nonatomic) BOOL isClear;
@property(assign,nonatomic) BOOL isMoving;
@property(assign,nonatomic) BOOL isReward;
@property(assign,nonatomic) int firstTag;
@property(copy,nonatomic) ClearPopstarBlock clearPopstarBlock;
@property (nonatomic, strong) YunPopstarSay *say;


/// 创建一个颜色背景的按钮
/// @param frame 位置
/// @param color 颜色
-(instancetype)initWithFrame:(CGRect)frame color:(PopstarColor)color;

/// 隐藏
-(void)hide;
-(void)hideNoAnimation;
-(void)moveDown:(int)y block:(MoveDownComplateBlock)complate;
-(void)moveLeft:(int)x block:(MoveDownComplateBlock)complate;
@end

NS_ASSUME_NONNULL_END
