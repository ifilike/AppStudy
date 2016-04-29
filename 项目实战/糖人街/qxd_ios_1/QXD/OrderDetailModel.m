//
//  OrderDetailModel.m
//  QXD
//
//  Created by zhujie on 平成27-11-22.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel

-(id)initWithDic:(NSDictionary *)dictionary{
    if (self = [super init]) {
        [self creatModelWithDic:dictionary];
    }
    return self;
}
-(void)creatModelWithDic:(NSDictionary *)dic{
    
    [self setValuesForKeysWithDictionary:dic];
    
}



@end
