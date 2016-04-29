//
//  FoundModel.m
//  QXD
//
//  Created by wzp on 15/12/10.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "FoundModel.h"

@implementation FoundModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.ID = value;
    }
}










@end
