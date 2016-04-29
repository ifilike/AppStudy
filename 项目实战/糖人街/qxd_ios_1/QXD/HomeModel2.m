//
//  HomeModel2.m
//  QXD
//
//  Created by wzp on 15/11/30.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "HomeModel2.h"

@implementation HomeModel2



- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.ID = value;
    }
}







@end
