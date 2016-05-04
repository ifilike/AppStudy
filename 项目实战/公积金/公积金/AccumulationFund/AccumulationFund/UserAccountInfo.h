//
//  UserAccountInfo.h
//  AccumulationFund
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAccountInfo : NSObject <NSCoding>

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *cellphone;
@property (copy, nonatomic) NSString *password;

// 公积金账号
@property (copy, nonatomic) NSString *account;
// 职工编号
@property (copy, nonatomic) NSString *staffNumber;
// 合同编号
@property (copy, nonatomic) NSString *contractNumber;

+ (instancetype)sharedUserAccountInfo;

- (BOOL)archive;
- (void)unarchive;


@end
