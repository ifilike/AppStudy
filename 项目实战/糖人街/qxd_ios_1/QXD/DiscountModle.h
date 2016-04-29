//
//  DiscountModle.h
//  QXD
//
//  Created by zhujie on 平成27-12-17.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountModle : NSObject
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *condition_descript;
@property(nonatomic,copy) NSString *coupon_descript;
@property(nonatomic,copy) NSNumber *time_limt;
@property(nonatomic,copy) NSString *coupon_type;
@property(nonatomic,copy) NSString *deadline;
@property(nonatomic,copy) NSString *coupon_sums;
-(id)initWithDiscountDic:(NSDictionary *)dic;
@end
