//
//  YunEnchashmentCell.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/14.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kYunEnchashmentCellHeight 80
NS_ASSUME_NONNULL_BEGIN

@interface YunEnchashmentCell : UITableViewCell
@property (nonatomic,retain) UILabel *titleLb;
@property (nonatomic,retain) UIView *box;
@property (nonatomic,retain) UILabel *statusLb;
@property (nonatomic,retain) UILabel *timeLb;
-(void)setContentWithDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
