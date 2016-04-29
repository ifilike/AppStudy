//
//  EvaluateModle.m
//  QXD
//
//  Created by zhujie on 平成27-12-23.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "EvaluateModle.h"

@implementation EvaluateModle
-(instancetype)initWithDiction:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self creatWithDic:dict];
    }
    return self;
}
-(void)creatWithDic:(NSDictionary *)dic{
    [self setValuesForKeysWithDictionary:dic];
}



@end
