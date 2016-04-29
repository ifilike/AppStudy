//
//  EvaluateModle.h
//  QXD
//
//  Created by zhujie on 平成27-12-23.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluateModle : NSObject
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *product_id;
@property(nonatomic,copy) NSString *product_img;
@property(nonatomic,copy) NSString *product_name;
@property(nonatomic,copy) NSString *product_num;
@property(nonatomic,copy) NSString *product_price;
@property(nonatomic,copy) NSString *is_comment;
@property(nonatomic,copy) NSString *product_standard;
@property(nonatomic,copy) NSString *apply;
-(instancetype)initWithDiction:(NSDictionary *)dict;
@end
