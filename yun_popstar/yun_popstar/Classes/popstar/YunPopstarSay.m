//
//  YunPopstarSay.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/11.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPopstarSay.h"

@interface YunPopstarSay()<AVAudioPlayerDelegate>

@end

@implementation YunPopstarSay
-(void)dealloc{
    NSLog(@"YunPopstarSay dealloc");
}
-(void)free{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stop];
}

-(instancetype)init{
    if ([super init]) {
   
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginPlay) name:kNSNotificationName_SoundStart object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:kNSNotificationName_SoundStop object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginPlay) name:kNSNotificationName_applicationWillEnterForeground object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:kNSNotificationName_applicationDidEnterBackground object:nil];
    }
    return self;
}
// 星星消失
-(void)popstar_disappear{
    [self say:@"popstar_disappear.wav"];
}

-(void)readygo{
    [self say:@"lz_star_ready_go.wav"];
    [[YunPopstarShowMsgView sharedSingleton] showReadyGo];
}
-(void)nice{
    [self say:@"ku.mp3"];
    [[YunPopstarShowMsgView sharedSingleton] showNice];
}
-(void)good{
    [self say:@"feichangbang.mp3"];
    [[YunPopstarShowMsgView sharedSingleton] showGood];
}
-(void)welldone{
    [self say:@"jingcaijuelun.mp3"];
    [[YunPopstarShowMsgView sharedSingleton] showWellDone];
}

-(void)verygood{
    [self say:@"tailihaile.mp3"];
    [[YunPopstarShowMsgView sharedSingleton] showVeryGood];
}

-(void)perfect{
    [self say:@"wanmeiwubi.mp3"];
    [[YunPopstarShowMsgView sharedSingleton] showPerfect];
}

-(void)passtarget{
    [self say:@"mubiaodacheng.mp3"];
    [[YunPopstarShowMsgView sharedSingleton] showPassTarget];
}

-(void)veryperfect{
    [self say:@"taiwanmeile_zhenbuganxiangxin.mp3"];
    [[YunPopstarShowMsgView sharedSingleton] showVeryPerfect];
}


// 奖励分数
-(void)reward{
    [self say:@"lz_star_reward.wav"];
}
-(void)coindrop{
    [self say:@"more_coin_down.wav"];
}
// 点击按钮声音
-(void)touchButton{
    [self say:@"lz_touch_on.wav"];
}

// 红包来了
-(void)redenvelope_comein{
    [self say:@"redenvelope_comein.wav"];
}

// 收货道具
-(void)get_tool_success{
    [self say:@"get_tool_success.wav"];
}

-(void)lighting{
    [self say:@"light_bg.wav"];
}

-(void)peng{
    [self say:@"peng.mp3"];
}
/// 随机获取背景音乐播放
-(void)playBackgroundMusic{
    //int n = arc4random() % 2;
    NSString *filenames = @"lz_star_sound_bg.mp3";
    [self saymp3:filenames numberOfLoops:0];
    
}

-(void)say:(NSString*)voice{
    if ([YunConfig getGameVoiceIsOpen]) {
        // 创建播放器
        NSURL *soundUrl = [[NSBundle mainBundle] URLForResource:voice withExtension:nil];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl,&soundID);
        AudioServicesPlaySystemSound(soundID);
    }
    
}

-(void)saymp3:(NSString*)voice numberOfLoops:(int)numberOfLoops{
    if ([YunConfig getGameSoundIsOpen]) {
        [self audioPlayer:voice numberOfLoops:numberOfLoops];
        self.audioPlayer.volume = 0.1;
        [self beginPlay];
//        NSURL *soundUrl = [[NSBundle mainBundle] URLForResource:voice withExtension:nil];
//        SystemSoundID soundID;
//        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl,&soundID);
//        AudioServicesPlaySystemSound(soundID);
    }
}

/// 显示提示信息
/// @param str 信息内容
-(void)showMessage:(NSString*)str{
    
}


#pragma mark -懒加载
-(AVAudioPlayer *)audioPlayer:(NSString*)voice numberOfLoops:(int)numberOfLoops
{

    // 1. 获取资源URL
    NSURL *url = [[NSBundle mainBundle]  URLForResource:voice withExtension:nil];
    // 2. 根据资源URL, 创建 AVAudioPlayer 对象
    if (!_audioPlayer) {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }else{
        [self stop];
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    }
    
    // 2.1 设置允许倍速播放
    self.audioPlayer.enableRate = YES;
    _audioPlayer.numberOfLoops = numberOfLoops;

    // 3. 准备播放
    [_audioPlayer prepareToPlay];

    // 4. 设置代理, 监听播放事件
    _audioPlayer.delegate = self;
    //self.audioPlayer.volume = 0.5;
    return _audioPlayer;
}

- (void)setBackGroundPlay:(BOOL)active
{
    // 1. 设置会话模式
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil]; ;
    // 2. 激活会话
    [[AVAudioSession sharedInstance] setActive:active error:nil];
}


// 开始播放
- (void)beginPlay {
    
    if ([YunConfig getGameSoundIsOpen]) {
        [self setBackGroundPlay:YES];
        [self.audioPlayer play];
    }
    
}

// 暂停
- (void)pause {
    [self setBackGroundPlay:NO];
    [self.audioPlayer pause];
}

// 停止
- (void)stop {
    [self pause];
    // 停止某个音乐, 并不会重置播放时间, 下次再播放, 会从当前位置开始播放
    [self.audioPlayer stop];
    // 重置当前播放时间
    self.audioPlayer.currentTime = 0;
    // 或者直接清空重新创建
    self.audioPlayer.delegate = nil;
    self.audioPlayer = nil;
}



#pragma mark - 播放器代理
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"播放完成");
    [self playBackgroundMusic];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer*)player error:(NSError *)error{
    //解码错误执行的动作
    NSLog(@"%@",error);
}
- (void)audioPlayerBeginInteruption:(AVAudioPlayer*)player{
    //处理中断的代码
}
- (void)audioPlayerEndInteruption:(AVAudioPlayer*)player{
    //处理中断结束的代码
}
@end
