//
//  YunStarPlayView.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/21.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunStarPlayView.h"
#import "YunPopstarButton.h"
#import "YunPopstarSay.h"
#import "YunStarCommand.h"


#import "ANGifEncoder.h"
#import "ANCutColorTable.h"
#import "ANGifNetscapeAppExtension.h"
#import "UIImagePixelSource.h"

#define kPopTime 0.08
#define kGifMaxImages 150.0
#define kGifDuration (0.1)

@interface YunStarPlayView()
@property (retain,nonatomic) UIView *starButtonsView;
@property (retain,nonatomic) NSMutableArray *linkButtons;
@property (retain,nonatomic) NSMutableDictionary *buttonStatus;
@property (retain,nonatomic) UIImage *gifimg;
@property (assign,nonatomic) BOOL isFinished;
@property (assign,nonatomic) BOOL gameOver;
@property (assign,nonatomic) BOOL isPass;   // 是否过关
@property (assign,nonatomic) BOOL isExit;   // 是否退出
@property (assign,nonatomic) BOOL isExecute;   // 是否正在执行命令
@property (assign,nonatomic) int gameOverLastStarCount; // 每次游戏结束，剩余多少星星
@property (nonatomic, strong) YunPopstarSay *say;
@property (nonatomic, strong) NSMutableArray *downButtons;
@property (nonatomic, strong) CAEmitterLayer * fireworksLayer;
@property (assign,nonatomic) int start_time; // 游戏开始时间

@end

@implementation YunStarPlayView

-(void)dealloc{
    
    NSLog(@"YunStarPlayView dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame{
    if([super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

-(void)free{
    _isExit = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self clear];
    [self.say free];
}

-(void)stop{
    _index = 0;
    _isStop = YES;
    _playBt.hidden = NO;
    _playBt.tag = 0;
    _playBt.enabled = YES;
    if (_stopBlock) {
        _stopBlock(nil);
    }
}

-(void)initView{
    _gifImgs = [NSMutableArray new];
    [self initSay];
    [self createPlayBt];
    [self checkPopstarHasTheSame];
}

-(void)createPlayBt{
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    float x = (self.frame.size.width - w) /2;
    float y = (self.frame.size.height - h) /2;
    _playBt = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    UIImage *icon = [UIImage imageNamed:@"play_stop_icon"];
    icon = [UIImage scaleToSize:icon size:CGSizeMake(80, 80)];
    [_playBt setImage:icon forState:UIControlStateNormal];
    _playBt.tag = 0;
    _playBt.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 10;
    _playBt.layer.cornerRadius = 10;
    [_playBt addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playBt];
}

-(void)clear{

    if (self.starButtonsView) {
        for (UIView *v in self.starButtonsView.subviews) {
            [v removeFromSuperview];
        }
        [self.starButtonsView removeFromSuperview];
        
    }
    self.starButtonsView = nil;
    if (self.linkButtons) {
        [self.linkButtons removeAllObjects];
    }
    self.linkButtons = nil;
    if (self.buttonStatus) {
        [self.buttonStatus removeAllObjects];
    }
    self.buttonStatus = nil;
    
    if (self.downButtons) {
        [self.downButtons removeAllObjects];
    }
    self.downButtons = nil;
}

-(void)initSay{
    self.say = [YunPopstarSay new];
}
// 播放命令
-(void)play:(NSMutableDictionary*)cmds{
    _isInit = YES;
    if (_cmds) {
        [_cmds removeAllObjects];
    }
    _cmds = cmds;
    _isFinished = YES;
    _isStop = YES;
    _isExecute = NO;
    _playOver = NO;
    // 初始化播放首页
    [self playstarhome];
    
    // 启动gif采集
    if (_isRecordGif) {
        [self createGif];
    }
    
    //[self startPlay];
}
// 开始播放
-(void)startPlay{
    
    _playBt.enabled = NO;
    if (_playBt.tag==0 && _isFinished) {
        _playBt.tag = 1;
        // 播放
        _isStop = NO;
        [self.say touchButton];
        _playBt.alpha = 1;
        self.start_time = [fn getTimestamp];
        [self playing:self.index];
        self.playBt.hidden = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationName_LevesStartBackPlay object:nil userInfo:@{@"me":self}];
    }else{
        // 暂停
        [self.say touchButton];
        [self pause];
    
    }
    
}

-(void)pause{
    _playBt.alpha = 1;
    _playBt.tag = 0;
    _isStop = YES;
    
    _playBt.hidden = NO;
    _starButtonsView.userInteractionEnabled = NO;
}
// 初始化播放首页
-(void)playstarhome{
    NSArray *cmd = [_cmds[@"cmds"] mj_JSONObject];
    if (cmd) {
        self.index = 0;
        NSDictionary *item = cmd[0];
        // 命令操作
        NSString *name = item[@"name"];
        // 星星对象
        NSArray *links = item[@"links"];
        // 运行命令
        [self command:name links:links];
        WEAKSELF
        [fn sleepSeconds:0.3 finishBlock:^{
            // 播放下一个命令
            __weakSelf.index ++;
//            [__weakSelf checkPopstarFinished:^{
//                // 播放下一个命令
//                __weakSelf.index ++;
//            }];
        }];
        
    }
}
-(void)playing:(int)index{
    if (self.isStop) {
        _starButtonsView.userInteractionEnabled = YES;
        _playBt.enabled = YES;
        return;
    }

    NSArray *cmd = [_cmds[@"cmds"] mj_JSONObject];
    WEAKSELF
    if (index<cmd.count) {
        NSDictionary *item = cmd[index];
        // 等待时间毫秒
        long t = [item[@"t"] longValue];
        // 命令操作
        NSString *name = item[@"name"];
        // 星星对象
        NSArray *links = item[@"links"];
        if ([name isEqualToString:@"start"]) {
            t = 0;
        }
        t = MIN(t, 2000);
        
        index ++;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, t*NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
            if (__weakSelf.isStop) {
                __weakSelf.starButtonsView.userInteractionEnabled = YES;
                __weakSelf.playBt.enabled = YES;
                return;
            }
            // 运行命令
            __weakSelf.isExecute = YES;
            [__weakSelf command:name links:links];
            __weakSelf.index = index;
            // 检查是否完成一次消失任务
            [__weakSelf checkPopstarFinished:^{
                
                // 播放下一个命令
                __weakSelf.isExecute = NO;
                [__weakSelf playing:index];
            }];
            
        });
    }
}
// 运行回放命令
-(void)command:(NSString*)name links:(NSArray*)buttons{
    // 游戏开始命令
    if ([name isEqualToString:@"start"]) {
        [self resetStarView:buttons];
    }
    // 消除命令
    if ([name isEqualToString:@"pop"]) {
        [self popStar:buttons];
    }
    // 刷新命令
    if ([name isEqualToString:@"refresh"]) {
        [self refreshButtons:buttons];
    }
    // 爆破命令
    if ([name isEqualToString:@"bomb"]) {
        [self bomb:buttons];
    }
    // 魔术笔命令
    if ([name isEqualToString:@"magic"]) {
        [self changeColorWithButton:buttons];
    }
}

-(void)createGif{
//    NSString *pic_gif = _cmds[@"pic_gif"];
//    if (pic_gif) {
//        if (![pic_gif isEqualToString:@""]) {
//            // 已经生成过了
//            NSLog(@"%@",pic_gif);
//            return;
//        }
//    }
    [self.gifImgs removeAllObjects];
    NSLog(@"开始录制gif");
    WEAKSELF
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{    // 检查是否完成一次清除工作，只有完成清除后才可以继续下一次清除
        int i=0;
        while (true) {
            // 录制播放动画
            if (!__weakSelf.isStop && i<=kGifMaxImages) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    UIImage *img = [UIImage snapshot:__weakSelf scale:[UIScreen mainScreen].scale];
//                    NSData *data = UIImageJPEGRepresentation(img, 0.5);
//                    img = [UIImage imageWithData:data scale:1];
                    //img = [UIImage combine:img otherImage:nil frame:__weakSelf.frame];
                    //img = [UIImage scaleToSize:img size:CGSizeMake(img.size.width/8, img.size.height/8)];
                    // 拼接
                    if (__weakSelf.mainViewImg) {
                        img = [UIImage combine:__weakSelf.mainViewImg otherImage:img frame:__weakSelf.frame];
                    }
                    img = [UIImage scaleToSize:img size:CGSizeMake(img.size.width/5, img.size.height/5)];
                    
                    [__weakSelf.gifImgs addObject:img];
                });
                i ++;
            }
            
            if(__weakSelf.playOver){
               
                return;
            }
            [NSThread sleepForTimeInterval:kGifDuration];
            
        }
    });
    
    
    
    
}

-(NSString*)compareGif:(NSArray*)images duration:(float)duration{
    //创建gif文件
    NSArray *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucmentStr =[document objectAtIndex:0];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSString *textDic = [doucmentStr stringByAppendingString:@"/gif"];  //文件夹
    [filemanager createDirectoryAtPath:textDic withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *fileOutput = [textDic stringByAppendingString:[NSString stringWithFormat:@"%.f.gif",[fn getTimestamp]]];
    NSLog(@"-----%@",fileOutput);   // GIF 的保存路径
    UIImage *firstImage = images.firstObject;
    CGSize canvasSize = (firstImage ? firstImage.size : CGSizeZero);
    ANGifEncoder * encoder = [[ANGifEncoder alloc] initWithOutputFile:fileOutput size:canvasSize globalColorTable:nil];
    ANGifNetscapeAppExtension * extension = [[ANGifNetscapeAppExtension alloc] init];
    [encoder addApplicationExtension:extension];
    
    for (int i = 0; i < [images count]; i++) {
        UIImage * image = [images objectAtIndex:i];
        
        ANGifImageFrame * theFrame = [self imageFrameWithImage:image fitting:canvasSize duration:kGifDuration];
        [encoder addImageFrame:theFrame];
    }
    [encoder closeFile];
    return fileOutput;
}

- (ANGifImageFrame *)imageFrameWithImage:(UIImage *)anImage fitting:(CGSize)imageSize duration:(float)duration{
    UIImage * scaledImage = anImage;
    if (!CGSizeEqualToSize(anImage.size, imageSize)) {
        scaledImage = [anImage imageFittingFrame:imageSize];
    }
    // 压缩
    //NSData *data = UIImageJPEGRepresentation(anImage, 1);
    //scaledImage = [YQImageCompressTool OnlyCompressToImageWithImage:anImage FileSize:data.length/5];

    UIImagePixelSource * pixelSource = [[UIImagePixelSource alloc] initWithImage:scaledImage];
    ANCutColorTable * colorTable = [[ANCutColorTable alloc] initWithTransparentFirst:YES pixelSource:pixelSource];
    ANGifImageFrame * frame = [[ANGifImageFrame alloc] initWithPixelSource:pixelSource colorTable:colorTable delayTime:duration];

    return frame;
}

-(void)shareAction:(void (^)(NSString *gif_url))block{
    WEAKSELF
    [SVProgressHUD showWithStatus:@"正在生成动图..."];
    [fn sleepSeconds:0.3 finishBlock:^{
        [__weakSelf sendUploadGif:^(NSString *gif_url) {
            block(gif_url);
        }];
    }];
}

-(void)sendUploadGif:(void (^)(NSString *gif_url))block{
    
    
    // 游戏结束，生成gif图片
    WEAKSELF
    //[self compareGif:self.gifImgs duration:kGifDuration] ;
    NSString *gifpath = [UIImage creatGifWithImages:self.gifImgs sec:kGifDuration];
    [self.gifImgs removeAllObjects];
    if (self.stopBlock) {
        self.stopBlock(gifpath);
    }
    [http uploadLevelsGifWithImageFile:gifpath params:@{@"levels_cmd_id":[NSString stringWithFormat:@"%@",_cmds[@"id"]]} start:^{
        [SVProgressHUD showWithStatus:@"正在上传数据..."];
    } failure:^{
        [SVProgressHUD showSuccessWithStatus:@"上传失败，网络不给力"];
        if (block) {
            block(nil);
        }
    } success:^(NSDictionary *dic) {
        int code = [dic[@"code"] intValue];
        if (code==200) {
            NSLog(@"%@",gifpath);
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            NSString *gif_url = dic[@"data"];
            __weakSelf.cmds[@"pic_gif"] = gif_url;
            if (block) {
                block(gif_url);
            }
            
        }else{
            FMHttpShowError(dic)
            if (block) {
                block(nil);
            }
        }
    }];
//    UIImageView *gif = [[UIImageView alloc] initWithFrame:__weakSelf.mainView.frame];
//    [gif sd_setImageWithURL:[NSURL fileURLWithPath:gifpath]];
//    [__weakSelf addSubview:gif];
    
}

- (void)resetStarView:(NSArray*)buttons{
    
    [self clear];
    if (!self.starButtonsView) {
        self.starButtonsView = [[UIView alloc] initWithFrame:self.bounds];
        self.starButtonsView.backgroundColor = [UIColor clearColor];
        self.starButtonsView.tag = 10010;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPlay)];
        [self.starButtonsView addGestureRecognizer:tap];
        self.starButtonsView.userInteractionEnabled = YES;
        [self addSubview:self.starButtonsView];
    }
    
    if (!self.buttonStatus) {
        self.buttonStatus = [NSMutableDictionary new];
    }
    if (!self.downButtons) {
        self.downButtons = [NSMutableArray new];
    }
    self.playOver = NO;
    self.isFinished = YES;
    self.gameOver = NO;
    self.isPass = NO;
    float padding = 0;
    int rowcount = 10;
    int btw = (self.frame.size.width-(rowcount-1)*padding)/rowcount;
    int bth = btw;
    int x = 0;
    int y = 0;
    float t = 0.005;
    self.starButtonsView.frame = CGRectMake((self.frame.size.width-10*btw)/2, (self.frame.size.height-10*bth)/2, 10*btw, 10*bth);
    WEAKSELF
    for(NSArray*item in buttons){
        int tag = [item.firstObject intValue];
        int color = [item.lastObject intValue];
        
        // 生成星星 一行十个
        YunPopstarButton *star = [[YunPopstarButton alloc] initWithFrame:CGRectMake(x, y, btw, bth) color:color];
        star.tag = tag;
        star.userInteractionEnabled = NO;
        //[star addTarget:self action:@selector(clickbtaction:) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:star];
        [self.starButtonsView addSubview:star];
        // 星星消失回调
        star.clearPopstarBlock = ^(YunPopstarButton *me, BOOL isClear) {
            // 清除标识
            NSLog(@"清除：%d",(int)me.firstTag);
            [__weakSelf.buttonStatus setValue:@(1) forKey:[NSString stringWithFormat:@"%d",(int)me.firstTag]];
        };
        
        
        //旋转动画
        CABasicAnimation *anima3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        anima3.toValue = [NSNumber numberWithFloat:M_PI*4];
        anima3.duration = 1.0;
        
        CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
        anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        anima.toValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];;
        anima.duration = t;
        //[star.layer addAnimation:anima forKey:nil];
//
        // 通过关键帧动画实现缩放
        CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"transform.scale";
        animation.values = @[@0.1,@1.0];
        animation.duration = 1.0;
        //animation.calculationMode = kCAAnimationLinear;
        
        //组动画
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.animations = [NSArray arrayWithObjects:animation,anima,anima3, nil];
        groupAnimation.duration = 4.0f;
        
        [star.layer addAnimation:groupAnimation forKey:nil];
        anima = nil;
        anima3 = nil;
        animation = nil;
        groupAnimation = nil;
        star = nil;
        t+= 0.005;
        x += btw;
        if (x>=self.frame.size.width-btw) {
            y += bth;
            x = 0;
        }
    }
    [self setButtonTag];
    [self bringSubviewToFront:self.playBt];
}


-(void)popStar:(NSArray*)buttons{
    if (!self.linkButtons) {
        self.linkButtons = [NSMutableArray new];
    }
    [self.linkButtons removeAllObjects];
    for (NSArray*item in buttons) {
        int tag = [item.firstObject intValue];
        //int color = [item.lastObject intValue];
        YunPopstarButton *bt = [self.starButtonsView viewWithTag:tag];
        if (bt) {
            [self.linkButtons addObject:bt];
        }
        
        bt = nil;
    }
    WEAKSELF

    // 消灭五个，欢呼
    if (self.linkButtons.count==5) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say nice];
        });

    }
    if (self.linkButtons.count==6) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say good];
        });

    }
    if (self.linkButtons.count==7) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say welldone];
        });

    }
    // 消灭8个，欢呼
    if (self.linkButtons.count==8) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say verygood];
        });

    }
    // 消灭9个，欢呼
    if (self.linkButtons.count>=9 && self.linkButtons.count<15) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say perfect];
        });

    }
    
    // 消灭15个以上
    if (self.linkButtons.count>=15) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [__weakSelf.say veryperfect];
        });

    }
    

    float t = 0;
    for (YunPopstarButton *button in self.linkButtons) {
        [self.starButtonsView bringSubviewToFront:button];
        button.selected = YES;
        button.enabled = NO;
        [button performSelector:@selector(hide) withObject:nil afterDelay:t];
        t += kPopTime;
    }
 
    
    // 自由落体
    [self performSelector:@selector(moveDownButtons) withObject:nil afterDelay:t+0.3];
    
}

/// 按钮自由落体
-(void)moveDownButtons{
    [self.downButtons removeAllObjects];
    // 排序一下先,从上到下去搜索
    NSArray *sortedArray = [self.linkButtons sortedArrayUsingComparator:^NSComparisonResult(YunPopstarButton *p1, YunPopstarButton *p2){
        //对数组进行排序（升序）
        return p1.tag>p2.tag;
    }];
    int t=0;
    for (YunPopstarButton *button in sortedArray) {
        int tag = (int)button.tag;
        // 防止重复
        button.tag = tag * 1000;
        BOOL isLast = button==sortedArray.lastObject;
        [self checkButtonDowns:tag step:10 s:1  isLast:isLast t:t];
        t+=1;
    }
    if (self.downButtons.count>0) {
        [self.say say:@"lz_movedown.wav"];
    }
    

    [self moveLeftButtons];
    
    [self performSelector:@selector(setButtonTag) withObject:nil afterDelay:0.5];
}

- (void)checkButtonDowns:(int)tag step:(int)step s:(int)s isLast:(BOOL)isLast t:(int)t{
    
    WEAKSELF
    
    YunPopstarButton *buttonBottom = nil;
    
    int target_tag = tag - step;
    //NSLog(@"target_tag=%d",target_tag);
    buttonBottom = [self.starButtonsView viewWithTag:target_tag];
    if (buttonBottom && [[buttonBottom class] isEqual:[YunPopstarButton class]]) {
        if (buttonBottom.selected) {
            // 跳过继续上一个
            [self checkButtonDowns:tag step:step+10 s:s+1 isLast:isLast t:t];
        }else{
            int btw = (int)self.frame.size.width/10;
            int bth = btw;
            if (target_tag>=0 && target_tag<100) {
                int x = buttonBottom.frame.origin.x;
                int y = buttonBottom.frame.origin.y + buttonBottom.frame.size.height*s;
//                int w = buttonBottom.frame.size.width;
//                int h = buttonBottom.frame.size.height;
                int end_tag = x / btw + y / bth * 10;
                buttonBottom.tag = end_tag;
                NSLog(@"oldtag=%d,tag=%d move=%d",tag,end_tag,y);
                buttonBottom.isMoving = YES;
                [self.buttonStatus setObject:@(0) forKey:[NSString stringWithFormat:@"%d",end_tag]];
                [buttonBottom moveDown:y block:^(YunPopstarButton * me, BOOL finished) {
                    buttonBottom.isMoving = NO;
                    [__weakSelf.buttonStatus setObject:@(1) forKey:[NSString stringWithFormat:@"%d",end_tag]];
                }];
                [self.downButtons addObject:buttonBottom];
                //[sender removeFromSuperview];
                [self checkButtonDowns:tag step:step+10 s:s isLast:isLast t:t];
            }
        }
    }else{
        if (target_tag>=0 && target_tag<100) {
            // 跳过继续上一个
            [self checkButtonDowns:tag step:step+10 s:s isLast:isLast t:t];
        }
    }
}

/// 向左移动星星
-(void)moveLeftButtons{
    // 检查最后一排的星星是否存在，不存在就要向左移动拉
    for (int i=90; i<100; i++) {
        YunPopstarButton *button = [self.starButtonsView viewWithTag:i];
        BOOL isClear = YES;
        if(button){
            isClear = button.isClear;
        }
        if(isClear){
            // 如果星星已经消失,那就查找下一排星星，并且移动x轴
            int tag = i + 1;
            [self moveLeft:tag s:1];
        }
    }
    
}

/// 向左移动
/// @param start_tag 起始标签
/// @param s 移动列数
-(void)moveLeft:(int)start_tag s:(int)s{
    WEAKSELF
    YunPopstarButton *start_button = [self.starButtonsView viewWithTag:start_tag];
    if (start_button) {
        int tag_num = start_tag % 10;
        for (int i=0; i<10; i++) {
            int tag = tag_num + i*10;
            int btw = (int)self.frame.size.width/10;
            int bth = btw;
            YunPopstarButton *button = [self.starButtonsView viewWithTag:tag];
            if (tag>0 && tag<100 && button) {
                int x = button.frame.origin.x;
                int y = button.frame.origin.y;
                int w = button.frame.size.width;
                //int h = button.frame.size.height;
                x -= w*s;
                int end_tag = x / btw + y / bth * 10;
                button.tag = end_tag;
                //NSLog(@"oldtag=%d,tag=%d move=%d",tag,end_tag,y);
                button.isMoving = YES;
                [self.buttonStatus setObject:@(0) forKey:[NSString stringWithFormat:@"%d",end_tag]];
                
                [button moveLeft:x block:^(YunPopstarButton * me, BOOL finished) {
                    button.isMoving = NO;
                    [__weakSelf.buttonStatus setObject:@(1) forKey:[NSString stringWithFormat:@"%d",end_tag]];
                    
                }];
                
            }
        }
        [self moveLeft:start_tag+1 s:1];
    }else{
        if (start_tag<100) {
            // 遇到空的继续寻找下一个，并且移动列数加1
            [self moveLeft:start_tag+1 s:s+1];
        }
    }

}


/// 检查是否还有相同颜色的星星，没有就全部爆裂
-(void)checkTheSameStar{
    BOOL isHasTheSameStar = NO;
    for (YunPopstarButton *button in self.starButtonsView.subviews) {
        YunPopstarButton *buttonLeft = nil;
        YunPopstarButton *buttonRight = nil;
        YunPopstarButton *buttonTop = nil;
        YunPopstarButton *buttonBottom = nil;
        
        if (button.tag % 10 != 0) {
            buttonLeft = [self.starButtonsView viewWithTag:button.tag - 1];
        }
        
        if (button.tag % 10 != 9) {
            buttonRight = [self.starButtonsView viewWithTag:button.tag + 1];
        }
        
        if (button.tag / 10 != 0) {
            buttonTop = [self.starButtonsView viewWithTag:button.tag - 10];
        }
        
        if (button.tag / 10 != 9) {
            buttonBottom = [self.starButtonsView viewWithTag:button.tag + 10];
        }
        
        if (![[buttonLeft class] isEqual:[YunPopstarButton class]]) {
            buttonLeft = nil;
        }
        if (![[buttonRight class] isEqual:[YunPopstarButton class]]) {
            buttonRight = nil;
        }
        if (![[buttonTop class] isEqual:[YunPopstarButton class]]) {
            buttonTop = nil;
        }
        if (![[buttonBottom class] isEqual:[YunPopstarButton class]]) {
            buttonBottom = nil;
        }
        
        if ((buttonLeft && buttonLeft.color == button.color) ||
            (buttonRight && buttonRight.color == button.color) ||
            (buttonTop && buttonTop.color == button.color) ||
            (buttonBottom && buttonBottom.color == button.color)) {
            isHasTheSameStar = YES;
            break;
        }
    }
    
    
    // 剩余爆破
    if (!isHasTheSameStar) {
        [self gameOverAction];
    }

}

/// 通过按钮位置换算tag值
- (void)setButtonTag {
    int btw = (int)self.frame.size.width/10;
    int bth = btw;
    for (YunPopstarButton *button in self.starButtonsView.subviews) {
        int tag = button.frame.origin.x / btw + button.frame.origin.y / bth * 10;
        if (button.selected) {
            //[button removeFromSuperview];
        }else{
            if (button.firstTag<0) {
                button.firstTag = tag;
            }
            button.tag = tag;
        }
    }
}

- (void)checkPopstarFinished:(void(^)(void))block{
    typeof(self) __weak weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{    // 检查是否完成一次清除工作，只有完成清除后才可以继续下一次清除
        while (true) {
            __block BOOL isFinish = YES;
            @synchronized(weakSelf) {
                if (weakSelf.buttonStatus) {
                    for (NSString *key in weakSelf.buttonStatus.allKeys) {
                      BOOL isClear = [weakSelf.buttonStatus[key] boolValue];
                      dispatch_sync(dispatch_get_main_queue(), ^{
                          YunPopstarButton *button = [weakSelf.starButtonsView viewWithTag:[key intValue]];
                          if (!isClear && button) {
                              // 未消失，等待
                              NSLog(@"消失：%@",key);
                              isFinish = NO;
                          }
                          button = nil;
                      });
                    }
                }else{
                    isFinish = NO;
                }
                weakSelf.isFinished = isFinish;
            }
            
            if (isFinish) {
                [weakSelf.buttonStatus removeAllObjects];
                NSLog(@"完成一次");
                dispatch_async_main_safe(^{
                    if (block) {
                        block();
                    }
                });
                
                break;;
            }
            NSLog(@"weakSelf.isFinished=%d",isFinish);
            [NSThread sleepForTimeInterval:0.3];
        }
    });
}

- (void)checkPopstarHasTheSame{
    typeof(self) __weak weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{    // 检查相同的星星，没有就爆破
        while (!weakSelf.isExit) {
            
            @synchronized(weakSelf) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (!weakSelf.gameOver && weakSelf.playBt.tag == 1) {
                          [weakSelf checkTheSameStar];
                        }
                    
                });
            }
            [NSThread sleepForTimeInterval:0.5];
        }
        
    });
}

// 炸弹 点击按钮，把按钮四周的星星炸掉
-(void)bomb:(NSArray*)buttons{
   
    [self.say say:@"lz_tool_bg_bomb.mp3"];
    if (!self.linkButtons) {
        self.linkButtons = [NSMutableArray new];
    }
    [self.linkButtons removeAllObjects];
    int i = 1;
    YunPopstarButton *button = nil;
    for (NSArray*item in buttons) {
        int tag = [item.firstObject intValue];
        //int color = [item.lastObject intValue];
        YunPopstarButton *bt = [self.starButtonsView viewWithTag:tag];
        if (bt) {
            [self.linkButtons addObject:bt];
            [self.starButtonsView bringSubviewToFront:bt];
            bt.selected = YES;
            bt.enabled = NO;
            [bt hideNoAnimation];
            if (i==1) {
                button = bt;
            }
        }
        bt = nil;
        i++;
    }
    
    [self bombAnimation:button];
   
    // 自由落体
    [self performSelector:@selector(moveDownButtons) withObject:nil afterDelay:0.5];
}

// 刷新颜色
-(void)refreshButtons:(NSArray*)buttons{
    [self.say say:@"lz_tool_bg_xuanzhuan.wav"];
    for (NSArray*item in buttons) {
        int tag = [item.firstObject intValue];
        int color = [item.lastObject intValue];
        YunPopstarButton *bt = [self.starButtonsView viewWithTag:tag];
        if (bt) {
            bt.color = color;
        }
        bt = nil;
    }
}

// 变换颜色
-(void)changeColorWithButton:(NSArray*)buttons{
    buttons = buttons.firstObject;
    YunPopstarButton *button = [self.starButtonsView viewWithTag:[buttons.firstObject intValue]];
    int color = [buttons.lastObject intValue];
    WEAKSELF
    // 显示弹框
    [self.say touchButton];
    [self.starButtonsView bringSubviewToFront:button];
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:1];
    anima2.toValue = [NSNumber numberWithFloat:2];
    anima2.duration = 0.5;
    anima2.autoreverses = YES;
    anima2.repeatCount = NSNotFound;
    //以下两行同时设置才能保持移动后的位置状态不变
//    anima2.fillMode=kCAFillModeForwards;
//    anima2.removedOnCompletion = NO;
    
    [button.layer addAnimation:anima2 forKey:nil];
    
    [fn sleepSeconds:0.5 finishBlock:^{
        [__weakSelf.starButtonsView bringSubviewToFront:button];
        CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        anima2.fromValue = [NSNumber numberWithFloat:2];
        anima2.toValue = [NSNumber numberWithFloat:1];
        //以下两行同时设置才能保持移动后的位置状态不变
        anima2.fillMode=kCAFillModeForwards;
        anima2.removedOnCompletion = NO;
        anima2.duration = 0.5;
        [button.layer addAnimation:anima2 forKey:nil];
        button.color = color;
    }];
  
}

// 游戏结束
-(void)gameOverAction{
    
    self.gameOver = YES;
    // 表名已经没有相同颜色的了，就爆破所有星星
    self.gameOverLastStarCount = 0;
    float t = 0;
    int i = 0;
    for (YunPopstarButton *button in self.starButtonsView.subviews) {
        if (!button.isClear) {
            self.gameOverLastStarCount += 1;
            [self sendSubviewToBack:button];
            int rnd = 3 + arc4random() % 3;
            if (i<rnd) {
                // 前面3到5个内可以加分奖励
                button.isReward = YES;
                t += 5*kPopTime;
            }else{
                t += kPopTime;
            }
            [button performSelector:@selector(hide) withObject:nil afterDelay:t];
            
            i ++;
        }
        
        //sleep(0.1);
        
    }
    WEAKSELF
    [fn sleepSeconds:t+1 finishBlock:^{
        
        __weakSelf.playOver = YES;
       [__weakSelf stop];
    }];

}


-(void)bombAnimation:(YunPopstarButton*)button{
    //爆炸
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.bounds;
    [self.layer addSublayer:emitter];
    self.fireworksLayer = emitter;
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width*0.5,    emitter.frame.size.height*0.5);
    emitter.emitterSize= CGSizeMake(1, 1);
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.name = @"sparkCell";
    cell.contents = (__bridge id)[UIImage imageNamed:@"lz_star"].CGImage;//和CALayer一样，只是用来设置图片
    cell.birthRate = 150;//出生率
    cell.lifetime = 2.0;//生命周期
    cell.emissionLongitude = 0;//决定了粒子飞行方向跟水平坐标轴（x轴）之间的夹角，默认是0，即沿着x轴向右飞行。
    cell.color = [UIColor redColor].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 350;//速度
    cell.velocityRange = 500;//速度范围
    cell.yAcceleration = 575.f;  // 模拟重力影响
    cell.emissionRange =M_PI_2;
    cell.scale = 0.3;
    cell.redRange = 1.f;
    cell.greenRange = 1.f;
    cell.blueSpeed = 1.f;
    cell.alphaRange = 0.1;
    cell.alphaSpeed = -0.1f;
    cell.scaleRange = 0.5;
    cell.scaleSpeed = 0.01;
    
    CAEmitterCell *cell2 = [[CAEmitterCell alloc] init];
    cell2.name = @"sparkCell2";
    cell2.contents = (__bridge id)[UIImage imageNamed:@"lz_star"].CGImage;//和CALayer一样，只是用来设置图片
    cell2.birthRate = 100;//出生率
    cell2.lifetime = 2.0;//生命周期
    cell2.emissionLongitude = 0;//决定了粒子飞行方向跟水平坐标轴（x轴）之间的夹角，默认是0，即沿着x轴向右飞行。
    cell2.color = [UIColor yellowColor].CGColor;
    cell2.alphaSpeed = -0.4;
    cell2.velocity = 150;//速度
    cell2.velocityRange = 500;//速度范围
    cell2.yAcceleration = 575.f;  // 模拟重力影响
    cell2.emissionRange =M_PI_2;
    cell2.scale = 0.2;
    cell2.redSpeed = 0.4;
    cell2.greenSpeed = -0.1;
    cell2.blueSpeed = -0.1;
    cell2.alphaSpeed = -0.25;
    //add particle template to emitter
    emitter.emitterPosition = CGPointMake(button.frame.origin.x+button.frame.size.width/2, button.frame.origin.y+button.frame.size.height/2); // 在底部
    emitter.emitterMode = kCAEmitterLayerOutline;
    emitter.emitterShape = kCAEmitterLayerLine;
    emitter.renderMode = kCAEmitterLayerAdditive;
    
    emitter.emitterCells = @[cell,cell2];
    
    [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:0.5];
}

/**
 * 动画结束
 */
- (void)stopAnimation{
    // 用KVC设置颗粒个数
    [self.fireworksLayer setValue:@0 forKeyPath:@"emitterCells.sparkCell.birthRate"];
    [self.fireworksLayer setValue:@0 forKeyPath:@"emitterCells.sparkCell2.birthRate"];
    //[self.fireworksLayer removeAllAnimations];
}

@end
