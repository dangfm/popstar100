//
//  IBAlertView.h
//  IBAlertView
//
//  Created by iBlocker on 2017/8/7.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBConfigration.h"

typedef void (^IBAlertBlock)(NSUInteger index,NSString* url);

@interface IBAlertView : UIView
+ (instancetype)alertWithConfigration:(IBConfigration *)configration block:(IBAlertBlock)block;
- (void)show;
@end
