//
//  AppDelegate.h
//  yun_popstar
//
//  Created by dangfm on 2020/6/3.
//  Copyright © 2020 fangyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate*)sharedSingleton;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *urlParams;
@property (assign, nonatomic) BOOL isDownloadUserInfo;

@end

