//
//  DataSourceCenter.h
//  AccumulationFund
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSourceCenter : NSObject

@property (strong, nonatomic) NSArray *centerInfos;
@property (strong, nonatomic) NSArray *policyInfos;
@property (strong, nonatomic) NSArray *workGuides;
@property (strong, nonatomic) NSArray *allNews;

+ (instancetype)sharedDataSourceCenter;

- (void)newsInformationStartLoading;

@end
