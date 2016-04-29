//
//  LastCollectionModel.h
//  QXD
//
//  Created by zhujie on 平成27-11-23.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LastCollectionModel : NSObject
@property(nonatomic,copy) NSString *selfID;
@property(nonatomic,copy) NSString *productId;

@property(nonatomic,copy) NSString *imageView;

@property(nonatomic,copy) NSString *titleLabel;
@property(nonatomic,copy) NSString *detailLabel;
@property(nonatomic,copy) NSString *todayPriceLabel;
@property(nonatomic,copy) NSString *yestodayPriceLabel;

-(id)initWithDic:(NSDictionary *)dic;
@end
