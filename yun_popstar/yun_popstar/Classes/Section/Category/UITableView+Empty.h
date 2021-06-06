//
//  UITableView+Empty.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/14.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^clickBackgroundViewBlock)(void);
@interface UITableView (Empty)
@property(nonatomic,copy) clickBackgroundViewBlock clickBackgroundViewBlock;
- (void)showDataCount:(NSInteger)count msg:(NSString*)msg block:(void(^)(void))block;
@end

NS_ASSUME_NONNULL_END
