//
//  YunStarCommand.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/21.
//  Copyright © 2020 fangyun. All rights reserved.
//
#import "YunPopstarButton.h"
#import "YunStarCommand.h"

@implementation YunStarCommand
// 跟上面的方法实现有一点不同
+ (instancetype)sharedSingleton {
    static YunStarCommand *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          // 要使用self来调用
        _sharedSingleton = [[self alloc] init];
    });
    return _sharedSingleton;
}

-(instancetype)init{
    _cmdlines = [NSMutableArray new];
    return self;
}

-(void)reset{
    [_cmdlines removeAllObjects];
    _start_time = [fn getTimestamp];
}

-(void)cmdWithName:(NSString*)name linkButtons:(NSArray*)linkButtons{
    if (linkButtons.count<=0) {
        return;
    }
    long t =  [fn getTimestamp];
    t -= _start_time;
    NSMutableArray *links = [NSMutableArray new];
    
    for (YunPopstarButton *button in linkButtons) {
        int tag = (int)button.tag;
        int color = button.color;
        [links addObject:@[@(tag),@(color)]];
    }
    
    // 生成命令
    NSDictionary *cmdline = @{
        @"t":@(t),
        @"name":name,
        @"links":links
    };
    
    _start_time = [fn getTimestamp];
    //NSLog(@"%@",cmdline);
    
    [_cmdlines addObject:cmdline];
    
}

@end
