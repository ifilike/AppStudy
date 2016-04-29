//
//  OrderDetailModel.h
//  QXD
//
//  Created by zhujie on 平成27-11-22.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject


//@property(nonatomic,copy) NSString *detailImageView;
//@property(nonatomic,copy) NSString *detailLabel;
//@property(nonatomic,copy) NSString *detailTotalCountLabel;
//@property(nonatomic,copy) NSString *detailMoneyCountLabel;

//@property(nonatomic,copy) NSString *order_id;
@property(nonatomic,copy) NSString *product_id;
@property(nonatomic,copy) NSString *create_time;
@property(nonatomic,copy) NSString *product_name;
@property(nonatomic,copy) NSString *product_img;
@property(nonatomic,copy) NSString *product_num;
@property(nonatomic,copy) NSString *product_price;
@property(nonatomic,copy) NSString *is_comment;
@property(nonatomic,copy) NSString *product_standard;
@property(nonatomic,copy) NSString *apply;
//@property(nonatomic,copy) NSString *ID;
//@property(nonatomic,copy) NSString *CUSTOMER_ID;

-(id)initWithDic:(NSDictionary *)dictionary;

@end
