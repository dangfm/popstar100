//
//  UITableView+Empty.m
//  yun_popstar
//
//  Created by dangfm on 2020/9/14.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import "UITableView+Empty.h"

static const void *UtilityKey = &UtilityKey;

@implementation UITableView (Empty)

@dynamic clickBackgroundViewBlock;

- (clickBackgroundViewBlock)clickBackgroundViewBlock {
    return objc_getAssociatedObject(self, UtilityKey);
}

- (void)setClickBackgroundViewBlock:(clickBackgroundViewBlock)block{
    objc_setAssociatedObject(self, UtilityKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showDataCount:(NSInteger)count msg:(NSString*)msg block:(clickBackgroundViewBlock)block{
    if (count > 0) {
        self.backgroundView = nil;
        return;
    }
    
    float w = self.frame.size.width;
    float h = self.frame.size.height;
    float iw = 80;
    float ih = 80;
    float ix = (w-iw)/2;
    float iy = (h-ih)/2;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    
    UIImageView *showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ix, iy, iw, ih)];
    showImageView.contentMode = UIViewContentModeScaleAspectFill;
    [backgroundView addSubview:showImageView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iy + ih + 20, w, 20)];
    tipLabel.font = kFont(16);
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:tipLabel];
    
    showImageView.image = [UIImage imageNamed:@"no-data"];
    tipLabel.text = msg;
    ///tipLabel.text = @"网络不可用";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackgroundView)];
    [backgroundView addGestureRecognizer:tap];
    self.clickBackgroundViewBlock = block;
    backgroundView.alpha = 0.5;
    self.backgroundView = backgroundView;
    
}

-(void)clickBackgroundView{
    if (self.clickBackgroundViewBlock) {
        self.clickBackgroundViewBlock();
    }
}

@end
