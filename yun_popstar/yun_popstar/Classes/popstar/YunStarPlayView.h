//
//  YunStarPlayView.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/21.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YunStarPlayView : UIView
@property (nonatomic, strong) NSMutableDictionary *cmds;  // 命令
@property (nonatomic, strong) UIButton *playBt;  // 播放按钮
@property (nonatomic, strong) UIImage *mainViewImg;  // 截图
@property (retain,nonatomic) NSMutableArray *gifImgs;
@property (nonatomic, assign) BOOL isStop;  //是否停止
@property (nonatomic, assign) BOOL isInit;  //是否已经初始化
@property (nonatomic, assign) int index;  // 播放进度
@property (assign,nonatomic) BOOL playOver;
@property (assign,nonatomic) BOOL isRecordGif; // 是否录制gif
@property (nonatomic, copy) void(^stopBlock)(NSString * _Nullable gifurl);  // 停止后回调
@property (nonatomic, copy) void(^startplayBlock)(void);  // 开始播放回调
// 播放命令
-(void)play:(NSMutableDictionary*)cmds;
-(void)stop;
-(void)pause;
-(void)free;
-(void)clear;
-(void)shareAction:(void(^)(NSString*gif_url))block;
@end

NS_ASSUME_NONNULL_END
