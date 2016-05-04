//
//  WJTabBar.h
//  漳州公积金
//  自定义底部菜单的按钮
//

#import <UIKit/UIKit.h>
@class WJTabBar;

@protocol WJTabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickedPlusButton:(WJTabBar *)tabBar;

@end

@interface WJTabBar : UITabBar
@property (nonatomic, weak) id<WJTabBarDelegate> tabBarDelegate;
@end
