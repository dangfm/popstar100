//
//  YunLabel.m
//  yun_popstar
//
//  Created by dangfm on 2020/8/20.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunLabel.h"

@implementation YunLabel

-(instancetype)initWithFrame:(CGRect)frame borderWidth:(float)borderWidth borderColor:(UIColor*)borderColor{
    if (self=[super initWithFrame:frame]) {
        _borderWidth = borderWidth;
        _borderColor = borderColor;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, _borderWidth);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = _borderColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

@end
