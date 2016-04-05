//
//  ZJTabBar.h
//  loveinvest
//
//  Created by babbage on 16/3/16.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZJTabBar;
@protocol ZJTabBarDelegate <NSObject>

@optional
- (void)tabBar:(ZJTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface ZJTabBar : UIView
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@property (nonatomic, weak) id<ZJTabBarDelegate> delegate;

@end
