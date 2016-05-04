//
//  CommonItem.m
//

#import "WJCommonItem.h"

@implementation WJCommonItem

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon
{
    WJCommonItem *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithTitle:title icon:nil];
}

@end
