//
//  YunPopstarNumberView.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/11.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPopstarNumberView.h"

@implementation YunPopstarNumberView

-(instancetype)initWithNumber:(int)number fontsize:(float)fontsize padding:(float)padding{
    if([super init]){
        self.number = number;
        self.fontsize = fontsize;
        self.padding = padding;
        [self initView];
    }
    return self;
}

-(void)initView{
    self.numberView = [[UIView alloc] initWithFrame:self.bounds];
    self.maxNumberView = [[UIView alloc] initWithFrame:CGRectMake(0, _fontsize + 15, self.bounds.size.width, 20)];
    self.maxNumberTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, _fontsize + 15, self.bounds.size.width, 20)];
    self.maxNumberTitle.text = @"最高分:";
    self.maxNumberTitle.font = kFont(16);
    self.maxNumberTitle.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    [self.maxNumberTitle sizeToFit];
    [self showNumber:self.number];
    [self addSubview:self.numberView];
    [self addSubview:self.maxNumberView];
    [self addSubview:self.maxNumberTitle];
}

-(void)showNumber:(int)number{
    for (YunPopstarNumberView *v in self.numberView.subviews) {
        [v removeFromSuperview];
    }
    for (YunPopstarNumberView *v in self.maxNumberView.subviews) {
        [v removeFromSuperview];
    }
    NSString *numstr = [NSString stringWithFormat:@"%d",number];
    NSString *temp = nil;
    for(int i =0; i < [numstr length]; i++)
    {
        temp = [numstr substringWithRange:NSMakeRange(i, 1)];
        UIImageView * iv = [self createNumber:[temp intValue]];
        [self.numberView addSubview:iv];
        iv = nil;
    }
    
    
    NSString *maxnumstr = [NSString stringWithFormat:@"%d",[YunConfig getUserCoinMax]];
    NSString *maxtemp = nil;
    for(int i =0; i < [maxnumstr length]; i++)
    {
        maxtemp = [maxnumstr substringWithRange:NSMakeRange(i, 1)];
        UIImageView * iv = [self createNumber:[maxtemp intValue]];
        [self.maxNumberView addSubview:iv];
        iv = nil;
    }
    
    [self setFontsize:self.fontsize];
}

-(UIImageView*)createNumber:(int)num{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"num-%d",num]];
    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    iv.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    iv.layer.shadowColor = UIColorFromRGB(0x5b331b).CGColor;//阴影颜色
    iv.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    iv.layer.shadowOpacity = 0.3;//不透明度
    iv.layer.shadowRadius = 3.0;//半径

    //iv.alpha = 0.8;
    [iv setTintColor:[UIColor whiteColor]];
    
    return iv;
}
- (void)setFontsize:(float)fontsize{
    _fontsize = fontsize;
    float w = fontsize;
    float h = w;
    float x = 0;
    float y = 0;
    for (UIImageView *iv in self.numberView.subviews) {
        iv.frame = CGRectMake(x, y, w, h);
        x += (w-self.padding);
    }
    CGRect frame = self.numberView.frame;
    frame.size.width = (w-self.padding) * self.numberView.subviews.count;
    frame.size.height = 2*h;
    self.numberView.frame = frame;
    
    float sw = self.maxNumberTitle.font.pointSize;
    float sh = sw;
    float sx = (frame.size.width - self.maxNumberView.subviews.count*sw - self.maxNumberTitle.frame.size.width-5) / 2;
    float sy = 0;
    
    // 最高分
    self.maxNumberTitle.frame = CGRectMake(sx, self.maxNumberView.frame.origin.y, self.maxNumberTitle.frame.size.width,self.maxNumberTitle.frame.size.height);
    sx += self.maxNumberTitle.frame.size.width;
    
    for (UIImageView *iv in self.maxNumberView.subviews) {
        iv.frame = CGRectMake(sx, sy, sw, sh);
        sx += (sw);
    }
    
    
}
-(CGSize)getSize{
    return CGSizeMake((self.fontsize-self.padding) * self.numberView.subviews.count, 2*self.fontsize);
}
-(void)setPoint:(CGPoint)point{
    float w = (self.fontsize-self.padding) * self.numberView.subviews.count;
    float h = 2*self.fontsize;
    float x = point.x;
    float y = point.y;
    self.frame = CGRectMake(x, y, w, h);
}

@end
