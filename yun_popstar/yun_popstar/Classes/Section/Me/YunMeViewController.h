//
//  YunMeViewController.h
//  yun_popstar
//
//  Created by dangfm on 2020/7/3.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunPopstarBackgroundImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YunMeViewController : UIViewController

@property (retain,nonatomic) UIView *headerView;
@property (retain,nonatomic) YunPopstarBackgroundImageView *backgroundView;
@property (nonatomic, strong) YunPopstarSay *say;
@end

NS_ASSUME_NONNULL_END
