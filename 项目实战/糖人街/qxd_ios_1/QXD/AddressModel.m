//
//  AddressModel.m
//  QXD
//
//  Created by zhujie on 平成27-11-27.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel
-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        //为了判断删除的字段删除
        self.selfId = value;
    }
}
@end
