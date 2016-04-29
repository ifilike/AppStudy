//
//  HomeModel.m
//  QXD
//
//  Created by WZP on 15/11/20.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.ID = value;
    }
}








@end
