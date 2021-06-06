//
//  YunStarCommand.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/21.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunStarCommand : NSObject
@property (nonatomic,retain) NSMutableArray *cmdlines;
@property (nonatomic,assign) long start_time;
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)reset;
-(void)cmdWithName:(NSString*)name linkButtons:(NSArray*)linkButtons;
@end

NS_ASSUME_NONNULL_END
