//
//  WishListModel.m
//  QXD
//
//  Created by wzp on 15/12/11.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "WishListModel.h"

@implementation WishListModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.ID = value;
    }
}




@end
