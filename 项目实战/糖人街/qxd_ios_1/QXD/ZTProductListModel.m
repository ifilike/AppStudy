//
//  ZTProductListModel.m
//  QXD
//
//  Created by wzp on 15/12/7.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "ZTProductListModel.h"

@implementation ZTProductListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.ID = value;
    }
}

@end
