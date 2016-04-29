//
//  Track.m
//  QXD
//
//  Created by zhujie on 平成28-01-23.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "Track.h"

@implementation Track
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self ) {
        [self creatModleWithDic:dic];
    }
    return self;
}
-(void)creatModleWithDic:(NSDictionary *)dict{
    [self setValuesForKeysWithDictionary:dict];
}
//-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if ([key isEqualToString:@"id"]) {
//        self.ID = value;
//    }
//}


@end
