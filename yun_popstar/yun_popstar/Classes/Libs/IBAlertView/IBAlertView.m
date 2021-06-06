//
//  IBAlertView.m
//  IBAlertView
//
//  Created by iBlocker on 2017/8/7.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import "IBAlertView.h"

@interface IBAlertView ()<UITextViewDelegate> {
    CGFloat _viewHeight;
}
@property (nonatomic, strong) IBConfigration *configration;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UITextView *messageLab;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, copy) IBAlertBlock alertBlock;
@end

@implementation IBAlertView

+ (instancetype)alertWithConfigration:(IBConfigration *)configration block:(IBAlertBlock)block {
    
    IBAlertView *alertView = [[IBAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
    alertView.configration = configration;
    alertView.alertBlock = block;
    [alertView handleSubviews];
    
    return alertView;
}

- (void)setConfigration:(IBConfigration *)configration {
    if (!configration) {
        configration.title = @"title";
        configration.message = [[NSAttributedString alloc] initWithString:@""];
        configration.cancelTitle = @"Cancel";
        configration.confirmTitle = @"Confirm";
        configration.messageAlignment = NSTextAlignmentLeft;
    }
    
    CGRect rect = [self getHeightOfText:configration.message width:kScreenWidth - 120];
    self.messageLab.attributedText = configration.message;
    self.messageLab.textAlignment = configration.messageAlignment;
    //[self.messageLab sizeThatFits:CGSizeMake(kScreenWidth-120, 0)];
    _viewHeight = rect.size.height+30 + 39 + 15 + 50 + 22;
    self.messageLab.frame = (CGRect){20, self.titleLab.frame.origin.y + 45, kScreenWidth - 120, rect.size.height+30};
    self.messageLab.delegate = self;
    self.messageLab.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    self.messageLab.scrollEnabled = NO;
    
    self.titleLab.text = configration.title;
    [self.cancelButton setTitle:configration.cancelTitle forState:UIControlStateNormal];
    [self.confirmButton setTitle:configration.confirmTitle forState:UIControlStateNormal];
    //self.confirmButton.backgroundColor = configration.tintColor;
    [self.confirmButton setTitleColor:configration.tintColor forState:UIControlStateNormal];
    _configration = configration;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if ([URL.absoluteString indexOf:@"https://"]!=NSNotFound) {
           //《协议》点击事件
        NSLog(@"%@",URL.absoluteString);
        if (self.alertBlock) {
            self.alertBlock(-1,URL.absoluteString);
        }
        return NO;
    }
    return YES;
    
}


- (void)handleSubviews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLab];
    [self.bgView addSubview:self.messageLab];
    [self.bgView addSubview:self.cancelButton];
    [self.bgView addSubview:self.confirmButton];
}

- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [keyWindow bringSubviewToFront:self];
}

#pragma mark - Method
- (CGRect)getHeightOfText:(NSAttributedString *)text width:(CGFloat)width {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    return rect;
}

- (NSArray *)getRGBWithColor:(UIColor *)color {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}

#pragma mark - Subviews
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.center = self.center;
        _bgView.bounds = (CGRect){0, 0, kScreenWidth - 80, _viewHeight};
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.frame = CGRectMake(0, 15, kScreenWidth - 80, 40);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:23];
        _titleLab.textColor = [UIColor blackColor];
    }
    return _titleLab;
}
- (UITextView *)messageLab {
    if (!_messageLab) {
        _messageLab = [UITextView new];
        _messageLab.backgroundColor = [UIColor whiteColor];
        _messageLab.font = [UIFont systemFontOfSize:14];
    }
    return _messageLab;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = (CGRect){0, _viewHeight - 50, (kScreenWidth - 80) / 2.0, 50};
        _cancelButton.titleLabel.font = kFont(18);
        _cancelButton.tag = 1;
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelButton.layer.borderColor = FMBottomLineColor.CGColor;
        _cancelButton.layer.borderWidth = 0.5;
        //  点击选中按钮再移出按钮范围
//        [_cancelButton addTarget:self action:@selector(touchDragOut:) forControlEvents:UIControlEventTouchDragOutside];
//        //  修改点击选中按钮的背景色
//        [_cancelButton addTarget:self action:@selector(touchDownClick:) forControlEvents:UIControlEventTouchDown];
        //  点击方法
        [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.titleLabel.font = kFont(18);
        _confirmButton.frame = (CGRect){(kScreenWidth - 80) / 2.0, _viewHeight - 50, (kScreenWidth - 80) / 2.0, 50};
        _confirmButton.tag = 2;
        [_confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _confirmButton.layer.borderColor = FMBottomLineColor.CGColor;
        _confirmButton.layer.borderWidth = 0.5;
        //  点击选中按钮再移出按钮范围
//        [_confirmButton addTarget:self action:@selector(touchDragOut:) forControlEvents:UIControlEventTouchDragOutside];
//        //  修改点击选中按钮的背景色
//        [_confirmButton addTarget:self action:@selector(touchDownClick:) forControlEvents:UIControlEventTouchDown];
        //  点击方法
        [_confirmButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark - Action
- (void)touchDragOut:(UIButton *)sender {
    if (sender.tag == 1) {
        sender.backgroundColor = [UIColor whiteColor];
    } else {
        sender.backgroundColor = self.configration.tintColor;
    }
}
- (void)touchDownClick:(UIButton *)sender {
    //  修改点击选中按钮,修改背景色
    if (sender.tag == 1) {
        sender.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.7];
    } else {
        //  获取原有背景景色的RGBA值
        NSArray *colorArr = [self getRGBWithColor:self.configration.tintColor];
        //  根据RGBA值获取新的Color
        UIColor *touchDownColor = [UIColor colorWithRed:[colorArr[0] floatValue] * 0.7 green:[colorArr[1] floatValue] * 0.7 blue:[colorArr[2] floatValue] * 0.7 alpha:[colorArr[3] floatValue] * 0.7];
        sender.backgroundColor = touchDownColor;
    }
}
- (void)buttonClick:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.alertBlock) {
        self.alertBlock(sender.tag,nil);
    }
}

@end
