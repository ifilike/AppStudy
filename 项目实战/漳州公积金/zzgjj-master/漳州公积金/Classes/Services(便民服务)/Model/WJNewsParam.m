//
//  WJNewsParam.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/8.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJNewsParam.h"

@implementation WJNewsParam

- (NSNumber *)size
{
    return _size ? _size : @20;
}

- (NSString *)mindate
{
    return _mindate ? _mindate : @"";
}

- (NSString *)maxdate
{
    return _maxdate ? _maxdate : @"";
}

- (id)init
{
    if (self = [super init]) {
//        _size = @20;
//        _str = @"";
    }
    return self;
}

+ (instancetype)param
{
    return [[self alloc] init];
}
@end
