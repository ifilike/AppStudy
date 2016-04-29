//
//  ByxxrMode.m
//  QXD
//
//  Created by wzp on 15/12/3.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "ByxxrMode.h"

@implementation ByxxrMode


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.ID = value;
    }
}

@end
