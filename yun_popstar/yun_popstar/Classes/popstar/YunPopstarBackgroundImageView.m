//
//  YunPopstarBackgroundImageView.m
//  yun_popstar
//
//  Created by dangfm on 2020/6/13.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "YunPopstarBackgroundImageView.h"

@implementation YunPopstarBackgroundImageView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

-(void)initViews{
    UIImage *bgimg = FMDefaultBackgroundImage;
    self.bg = [[UIImageView alloc] initWithFrame:self.bounds];
    self.bg.image = bgimg;
    [self addSubview:self.bg];
    float x = 0;
    float y = 0;
    float h = UIScreenHeight;
    float w = self.bg.image.size.width/self.bg.image.size.height * h;
    CGRect frame = CGRectMake(x, y, w, h);
    self.bg.frame = frame;
    
    [self move];
}

-(void)move{
    float x = 0;
    float y = 0;
    float h = UIScreenHeight;
    float w = self.bg.image.size.width/self.bg.image.size.height * h;
    if (self.bg.frame.origin.x==0) {
        x = -w + UIScreenWidth;
    }else{
        x = 0;
    }
    CGRect frame = CGRectMake(x, y, w, h);
    self.bg.frame = frame;
//    [UIView animateWithDuration:60 animations:^{
//        self.bg.frame = frame;
//    } completion:^(BOOL finished) {
//        [self move];
//    }];
}

@end
