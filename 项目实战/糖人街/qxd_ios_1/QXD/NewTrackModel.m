//
//  NewTrackModel.m
//  QXD
//
//  Created by zhujie on 平成28-02-02.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import "NewTrackModel.h"

@implementation NewTrackModel
-(id)initWithDict:(NSDictionary *)dic{
    if (self = [super init]) {
        [self creatModelWithDic:dic];
    }
    return self;
}
-(void)creatModelWithDic:(NSDictionary *)dic{
    [self setValuesForKeysWithDictionary:dic];
}
//-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if ([key isEqualToString:@"id"]) {
//        self.Id = value;
//    }
//}


@end
