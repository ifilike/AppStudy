//
//  ProductModel.m
//  QXD
//
//  Created by zhujie on 平成27-12-25.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

-(instancetype)initModleWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self creatModleWithDic:dic];
    }
    return self;
}

-(void)creatModleWithDic:(NSDictionary *)dict{
    
    [self setValuesForKeysWithDictionary:dict];
    
}

@end
