//
//  LastCollectionModel.m
//  QXD
//
//  Created by zhujie on 平成27-11-23.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "LastCollectionModel.h"

@implementation LastCollectionModel
-(id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self creatWithDic:dic];
    }
    return self;
}
-(void)creatWithDic:(NSDictionary *)dic{
    self.selfID = [dic objectForKey:@"id"];
    
    self.imageView = [dic objectForKey:@"product_img1"];
    
    self.titleLabel = [dic objectForKey:@"product_name"];
    self.detailLabel = [dic objectForKey:@"product_details"];
    self.todayPriceLabel = [dic objectForKey:@"product_present_price"];
    self.yestodayPriceLabel = [dic objectForKey:@"product_original"];
    self.productId = [dic objectForKey:@"product_id"];
}



@end
