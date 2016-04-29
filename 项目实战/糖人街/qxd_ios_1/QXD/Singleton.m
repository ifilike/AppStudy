//
//  Singleton.m
//  QXD
//
//  Created by wzp on 16/2/18.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "Singleton.h"


static Singleton * single=nil;

@implementation Singleton










+ (Singleton*)defaultSingleton{
    @synchronized(self) {
        if (single==nil) {
            single=[[Singleton alloc] init];
            single.registerIs=NO;
        }
    }
    return single;
}


@end
