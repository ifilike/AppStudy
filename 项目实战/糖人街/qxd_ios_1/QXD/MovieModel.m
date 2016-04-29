//
//  MovieModel.m
//  QXD
//
//  Created by wzp on 16/2/2.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.ID = value;
    }
}





@end
