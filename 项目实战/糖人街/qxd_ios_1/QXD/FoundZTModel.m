//
//  FoundZTModel.m
//  QXD
//
//  Created by wzp on 15/12/29.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "FoundZTModel.h"

@implementation FoundZTModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.ID = value;
    }
}





@end
