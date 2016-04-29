//
//  OrderModel.m
//  QXD
//
//  Created by zhujie on 平成27-11-22.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "OrderModel.h"
#import "OrderDetailModel.h"

@implementation OrderModel


-(id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self creatModelWithDic:dict];
    }
    return self;
}
-(void)creatModelWithDic:(NSDictionary *)dict{
    [self setValuesForKeysWithDictionary:dict];
    
    self.PRODUCTS = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.products) {
        OrderDetailModel *detailModle = [[OrderDetailModel alloc] initWithDic:dic];
        [self.PRODUCTS addObject:detailModle];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}


@end
