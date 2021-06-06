//
//  YunPopstarNumberView.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/11.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunPopstarNumberView : UIView
@property (retain,nonatomic) UIView *numberView;
@property (retain,nonatomic) UIView *maxNumberView;
@property (retain,nonatomic) UILabel *maxNumberTitle;
@property (assign,nonatomic) int number;
@property (assign,nonatomic) float fontsize;
@property (assign,nonatomic) float padding;

-(instancetype)initWithNumber:(int)number fontsize:(float)fontsize padding:(float)padding;
-(void)showNumber:(int)number;
-(CGSize)getSize;
@end

NS_ASSUME_NONNULL_END
