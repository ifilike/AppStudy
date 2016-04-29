//
//  ScheduleModle.m
//  QXD
//
//  Created by zhujie on 平成28-01-22.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "ScheduleModle.h"

@implementation ScheduleModle
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self creatModleWithDictionary:dic];
    }
    return self;
}
-(void)creatModleWithDictionary:(NSDictionary*)dic{
    [self setValuesForKeysWithDictionary:dic];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
