//
//  YunPopstarSay.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/11.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface YunPopstarSay : UIView
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
-(void)free;
-(void)say:(NSString*)voice;
-(void)saymp3:(NSString*)voice numberOfLoops:(int)numberOfLoops;
-(void)stop;
-(void)popstar_disappear;
-(void)readygo;
-(void)nice;
-(void)good;
-(void)welldone;
-(void)verygood;
-(void)perfect;
-(void)playBackgroundMusic;
-(void)passtarget;
// 奖励分数
-(void)reward;
// 点击按钮声音
-(void)touchButton;
// 金币散落声音
-(void)coindrop;
// 红包来了
-(void)redenvelope_comein;
// 暂停
- (void)pause;
// 开始播放
- (void)beginPlay;
// 收货道具
-(void)get_tool_success;
// 太完美了 整不敢相信
-(void)veryperfect;
// 发光背景配乐
-(void)lighting;
// peng
-(void)peng;
@end

NS_ASSUME_NONNULL_END
