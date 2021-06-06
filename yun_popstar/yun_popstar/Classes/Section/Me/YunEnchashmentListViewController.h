//
//  YunEnchashmentListViewController.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/14.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunPopstarBackgroundImageView.h"
#import "YunEnchashmentCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunEnchashmentListViewController : UIViewController
@property (retain,nonatomic) UIView *headerView;
@property (retain,nonatomic) YunPopstarBackgroundImageView *backgroundView;
@property (nonatomic, strong) YunPopstarSay *say;
@property (nonatomic, strong) NSMutableArray *datas;
@property (retain,nonatomic) UITableView *tableView;
@property (nonatomic, assign) BOOL backtop;
@property (nonatomic, assign) int page;
@end

NS_ASSUME_NONNULL_END
