//
//  YunCommunityListCell.h
//  yun_popstar
//
//  Created by dangfm on 2020/10/2.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kYunCommunityListCellHeight 350
NS_ASSUME_NONNULL_BEGIN

@interface YunCommunityListCell : UITableViewCell
@property (nonatomic,retain) UIImageView *face;
@property (nonatomic,retain) UILabel *titleLb;
@property (nonatomic,retain) UIView *box;
@property (nonatomic,retain) UILabel *statusLb;
@property (nonatomic,retain) UILabel *timeLb;
@property (nonatomic,retain) UILabel *popLb;
@property (nonatomic,retain) UILabel *secondLb;
@property (nonatomic,retain) UIImageView *popIcon;
@property (nonatomic,retain) UIButton *playBt;
@property (nonatomic,retain) UIButton *challengeBt;
@property (nonatomic,retain) YunStarPlayView *playView;
@property (nonatomic,copy) void(^clickChallengeBlock)(void);
-(void)setContentWithDic:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
