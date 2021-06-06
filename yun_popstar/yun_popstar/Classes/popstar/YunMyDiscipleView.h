//
//  YunMyDiscipleView.h
//  yun_popstar
//
//  Created by dangfm on 2020/9/18.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunMyDiscipleCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface YunMyDiscipleView : UIView
<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIView *mainView;
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *datas;
@property (nonatomic, strong) YunPopstarSay *say;
@property(nonatomic,retain) UIButton *closeBt;
@property(nonatomic,retain) UIButton *passOrderBt;
@property(nonatomic,retain) UIButton *goldOrderBt;
@property(nonatomic,retain) UIButton *shareBt;
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int type;
@property(nonatomic,copy) void(^magicBlock)(UIButton *button,int index);
+ (instancetype)sharedSingleton;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (id)copy NS_UNAVAILABLE; // 没有遵循协议可以不写
- (id)mutableCopy NS_UNAVAILABLE; // 没有遵循协议可以不写
-(void)show;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
