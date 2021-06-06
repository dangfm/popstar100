//
//  YunWinerListCell.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/17.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kYunWinerListCellHeight 80
NS_ASSUME_NONNULL_BEGIN

@interface YunWinerListCell : UITableViewCell
@property (nonatomic,retain) UIImageView *ordericon;
@property (nonatomic,retain) UIImageView *face;
@property (nonatomic,retain) UILabel *titleLb;
@property (nonatomic,retain) UIView *box;
@property (nonatomic,retain) UILabel *statusLb;
@property (nonatomic,retain) UILabel *timeLb;
-(void)setContentWithDic:(NSDictionary*)dic order:(int)order type:(int)type;
@end

NS_ASSUME_NONNULL_END
