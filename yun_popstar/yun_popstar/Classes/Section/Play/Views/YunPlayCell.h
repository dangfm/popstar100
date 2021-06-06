//
//  YunPlayCell.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/22.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kYunPlayCellHeight 100
NS_ASSUME_NONNULL_BEGIN

@interface YunPlayCell : UITableViewCell
@property (nonatomic,retain) UILabel *titleLb;
@property (nonatomic,retain) UIView *box;
@property (nonatomic,retain) UILabel *statusLb;
@property (nonatomic,retain) UILabel *timeLb;
@property (nonatomic,retain) UILabel *popLb;
@property (nonatomic,retain) UIImageView *popIcon;
@property (nonatomic,retain) UIButton *playBt;
-(void)setContentWithDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
