//
//  IBConfigration.h
//  IBAlertView
//
//  Created by iBlocker on 2017/8/7.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

@interface IBConfigration : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSAttributedString *message;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *confirmTitle;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic) NSTextAlignment messageAlignment;
@end
