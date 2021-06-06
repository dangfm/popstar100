//
//  YunWebViewController.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/14.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunPopstarBackgroundImageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunWebViewController : UIViewController
@property (retain,nonatomic) UIView *headerView;
@property (retain,nonatomic) UIScrollView *mainView;
@property (retain,nonatomic) YunPopstarBackgroundImageView *backgroundView;
@property (nonatomic, strong) YunPopstarSay *say;
@property(nonatomic,retain) WKWebView *webView;
@property(nonatomic,retain) NSString *url;
@property(nonatomic,retain) YunLabel *titleLb;
-(instancetype)initWithUrl:(NSString*)url;
@end

NS_ASSUME_NONNULL_END
