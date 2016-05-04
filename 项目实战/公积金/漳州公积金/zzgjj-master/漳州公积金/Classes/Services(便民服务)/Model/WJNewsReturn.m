//
//  WJNewsReturn.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/8.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJNewsReturn.h"
#import "WJNews.h"
#import "MJExtension.h"

@implementation WJNewsReturn

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"Details" : [WJNews class]};
}

@end
