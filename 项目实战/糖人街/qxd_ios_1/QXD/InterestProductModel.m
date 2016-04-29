//
//  InterestProductModel.m
//  QXD
//
//  Created by wzp on 15/12/24.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "InterestProductModel.h"

@implementation InterestProductModel




- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.ID = value;
    }
}




@end
