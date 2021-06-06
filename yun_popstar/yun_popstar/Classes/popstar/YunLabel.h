//
//  YunLabel.h
//  yun_popstar
//
//  Created by dangfm on 2020/8/20.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunLabel : UILabel
@property (nonatomic,assign) float borderWidth;
@property (nonatomic,retain) UIColor *borderColor;
-(instancetype)initWithFrame:(CGRect)frame borderWidth:(float)borderWidth borderColor:(UIColor*)borderColor;
@end

NS_ASSUME_NONNULL_END
