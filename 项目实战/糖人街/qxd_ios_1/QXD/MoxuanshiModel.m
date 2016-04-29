//
//  MoxuanshiModel.m
//  QXD
//
//  Created by wzp on 16/1/23.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "MoxuanshiModel.h"

@implementation MoxuanshiModel




- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.ID = value;
    }
}






@end
