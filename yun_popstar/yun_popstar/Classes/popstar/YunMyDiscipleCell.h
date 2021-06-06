//
//  YunMyDiscipleCell.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/18.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kYunMyDiscipleCellHeight 80
NS_ASSUME_NONNULL_BEGIN

@interface YunMyDiscipleCell : UITableViewCell
@property (nonatomic,retain) UIImageView *face;
@property (nonatomic,retain) UIButton *goldbt;
@property (nonatomic,retain) UILabel *titleLb;
@property (nonatomic,retain) UIView *box;
@property (nonatomic,retain) UILabel *introLb;
@property (nonatomic,retain) UILabel *goldLb;
@property (nonatomic,retain) NSDictionary *dic;
@property (nonatomic,assign) int type;
-(void)setContentWithDic:(NSDictionary*)dic type:(int)type;
@end

NS_ASSUME_NONNULL_END
