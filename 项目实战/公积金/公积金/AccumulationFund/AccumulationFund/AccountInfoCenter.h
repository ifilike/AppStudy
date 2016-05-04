//
//  AccountInfoCenter.h
//  AccumulationFund
//
//  Created by SL🐰鱼子酱 on 15/12/10.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountInfoCenter : NSObject

@property (strong, nonatomic) NSDictionary *userAccount; // 账户查询
@property (strong, nonatomic) NSDictionary *loanInformation; // 贷款查询
@property (strong, nonatomic) NSDictionary *repaymentInfo; // 还款查询
@property (strong, nonatomic) NSDictionary *loanProgress;  // 贷款进度
@property (strong, nonatomic) NSArray *depositDetail; // 缴存明细

+ (instancetype)sharedAccountInfoCenter;

- (void)accountInformationrStartLoading;

@end
