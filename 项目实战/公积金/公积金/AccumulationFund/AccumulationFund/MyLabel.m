//
//  MyLabel.m
//  AccumulationFund
//
//  Created by SL🐰鱼子酱 on 15/11/20.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        if ([UIScreen mainScreen].bounds.size.width == 320) {
            self.font = [UIFont systemFontOfSize:14];
        } else {
            self.font = [UIFont systemFontOfSize:15];
        }
    }
    return self;
}

@end
