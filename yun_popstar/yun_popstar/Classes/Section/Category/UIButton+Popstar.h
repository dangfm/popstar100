//
//  UIButton+Popstar.h
//  yun_popstar
//
//  Created by dangfm on 2020/8/20.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Popstar)
+(UIButton*)createDefaultButton:(NSString*)title frame:(CGRect)frame size:(float)size;
+(UIButton*)createDefaultButton:(NSString*)title frame:(CGRect)frame;
+(UIButton*)createAdButton:(NSString*)title frame:(CGRect)frame;
+(UIButton*)createGoldButton:(NSString*)title frame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
