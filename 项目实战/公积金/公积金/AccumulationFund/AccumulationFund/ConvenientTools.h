//
//  ConvenientTools.h
//  AccumulationFund
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvenientTools : NSObject


#pragma mark - 提取预约
// 地图网点获取
@property (strong, nonatomic) NSArray *mapBranchs;
// 提取原因
@property (strong, nonatomic) NSArray *drawReason;
// 网点获取
@property (strong, nonatomic) NSArray *outlets;
// 购房类型
@property (strong, nonatomic) NSArray *purchaseType;
// 预约网店
@property (strong, nonatomic) NSArray *appointmentBranch;


// 预约查询
@property (strong, nonatomic) NSArray *appointedInfo;

+ (instancetype)sharedConvenientTools;
- (void)convenientToolsInformationrStartLoading;

@end
