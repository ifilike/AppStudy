//
//  FriendsModel.h
//  QXD
//
//  Created by zhujie on 平成27-12-07.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsModel : NSObject

//@property(nonatomic,copy) NSString *CREATE_TIME;
@property(nonatomic,copy) NSString *customer_id;
@property(nonatomic,copy) NSString *ID;
//@property(nonatomic,copy) NSString *IS_DELETE;
@property(nonatomic,copy) NSString *product_id;
@property(nonatomic,copy) NSString *product_img;
@property(nonatomic,copy) NSString *product_name;
@property(nonatomic,copy) NSString *product_num;
@property(nonatomic,copy) NSString *product_price;
@property(nonatomic,copy) NSString *product_standard;

//"customer_id" = 977f6485874246088be7e4fa3b791fa0;
//id = eb007f3cc5e44ed9ab45d357008c6d7b;
//"product_id" = 00582535eaa941ec991ae5da105b5f33;
//"product_img" = "http://cdn.static.qiuxinde.com/qxd/head/2015/1203/f282a81d84f9429b8863a1e986c82d81.jpg";
//"product_name" = "\U5496\U5561";
//"product_num" = 1;
//"product_price" = 100;

-(id)initWithDict:(NSDictionary *)dict;
@end
