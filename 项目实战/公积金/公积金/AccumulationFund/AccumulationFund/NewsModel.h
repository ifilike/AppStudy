//
//  NewsModel.h
//  AccumulationFund
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, NewsType) {
    NewsTypeCenterInfo = 1,
    NewsTypePolicyInfo,
    NewsTypeWorkGuide
};


@interface NewsModel : NSObject <NSCoding>

@property (assign, nonatomic) NewsType newsType;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *context;

+ (NSArray *)modelsWithArray:(NSArray *)array;

@end
