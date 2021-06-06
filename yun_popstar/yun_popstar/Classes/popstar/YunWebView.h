//
//  YunWebView.h
//  yun_popstar
//
//  Created by dangfm on 2020/8/28.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YunWebView : UIView<WKNavigationDelegate>
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) WKWebView *webView;
@property(nonatomic,retain) NSString *url;
@property(nonatomic,retain) UIButton *sureBt;
@property(nonatomic,retain) UIButton *noBt;
@property(nonatomic,retain) FBGlowLabel *titleLb;
@property (nonatomic, strong) YunPopstarSay *say;
@property(nonatomic,copy) void(^buttonBlock)(UIButton *button,int index);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show:(NSString*)url;
-(void)showPrivate:(NSString *)url;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
