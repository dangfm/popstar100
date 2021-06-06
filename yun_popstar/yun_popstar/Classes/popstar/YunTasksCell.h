//
//  YunTasksCell.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/18.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kYunTasksCellHeight 80
NS_ASSUME_NONNULL_BEGIN

@interface YunTasksCell : UITableViewCell
@property (nonatomic,retain) UIButton *goldbt;
@property (nonatomic,retain) UILabel *titleLb;
@property (nonatomic,retain) UIView *box;
@property (nonatomic,retain) UILabel *introLb;
-(void)setContentWithDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
