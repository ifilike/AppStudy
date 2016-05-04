//
//  AccountInfoCenter.m
//  AccumulationFund
//
//  Created by SL🐰鱼子酱 on 15/12/10.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "AccountInfoCenter.h"
#import "GJJAPI.h"
#import "UserAccountInfo.h"

@implementation AccountInfoCenter

+ (instancetype)sharedAccountInfoCenter {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init {
    if (self = [super init]) {
        _userAccount = [self unarchiveForKey:@"user_account_info.archiver"];
        _loanInformation = [self unarchiveForKey:@"loan_information.archive"];
        _repaymentInfo = [self unarchiveForKey:@"loan_repayment_info.archive"];
        _loanProgress = [self unarchiveForKey:@"loan_progress_info.archive"];
        _depositDetail = [self unarchiveForKey:@"deposit_detail_info.archive"];
    }
    return self;
}

- (id)unarchiveForKey:(NSString *)key {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFilePathWithKey:key]];
}

- (NSString *)getFilePathWithKey:(NSString *)key {
    
    NSString *path =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *dataDirectory = [path stringByAppendingPathComponent:@"datas"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataDirectory]) {
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dataDirectory withIntermediateDirectories:true attributes:nil error:nil];
        if (!success) {
            NSLog(@"数据目录创建失败");
        }
    }
    return [dataDirectory stringByAppendingPathComponent:key];
}

- (void)setUserAccount:(NSDictionary *)userAccount {
    if ([userAccount.description isEqualToString:_userAccount.description]) {
        return;
    }
    _userAccount = userAccount;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userAccountInfoDidLoadNotification" object:nil];
    BOOL success = [NSKeyedArchiver archiveRootObject:_userAccount toFile:[self getFilePathWithKey:@"user_account_info.archiver"]];
    if (success) {
        NSLog(@"userAccountInfo 归档成功, %@", _userAccount);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里crash\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}

- (void)setLoanInformation:(NSDictionary *)loanInformation {
    if ([loanInformation.description isEqualToString:_loanInformation.description]) {
        return;
    }
    _loanInformation = loanInformation;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loanInformationDidLoadNotification" object:nil];
    BOOL success = [NSKeyedArchiver archiveRootObject:_loanInformation toFile:[self getFilePathWithKey:@"loan_information.archive"]];
    if (success) {
        NSLog(@"loanInformation 归档成功, %@", _loanInformation);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里crash\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}

- (void)setRepaymentInfo:(NSDictionary *)repaymentInfo {
    if ([_repaymentInfo.description isEqualToString:repaymentInfo.description]) {
        return;
    }
    _repaymentInfo = repaymentInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loanRepaymentInformationDidLoadNotification" object:nil];
    BOOL success = [NSKeyedArchiver archiveRootObject:_repaymentInfo toFile:[self getFilePathWithKey:@"loan_repayment_info.archive"]];
    if (success) {
        NSLog(@"repaymentInfo 归档成功, %@", _repaymentInfo);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里crash\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}

- (void)setLoanProgress:(NSDictionary *)loanProgress {
    if ([_loanInformation.description isEqualToString:loanProgress.description]) {
        return;
    }
    _loanProgress = loanProgress;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loanProgressInformationDidLoadNotification" object:nil];
    BOOL success = [NSKeyedArchiver archiveRootObject:_loanProgress toFile:[self getFilePathWithKey:@"loan_progress_info.archive"]];
    if (success) {
        NSLog(@"loanProgress 归档成功, %@", _loanProgress);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里crash\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}

- (void)setDepositDetail:(NSArray *)depositDetail {
    if ([_depositDetail.description isEqualToString:depositDetail.description]) {
        return;
    }
    _depositDetail = depositDetail;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"depositDetailInformationDidLoadNotification" object:nil];
    BOOL success = [NSKeyedArchiver archiveRootObject:_depositDetail toFile:[self getFilePathWithKey:@"deposit_detail_info.archive"]];
    if (success) {
        NSLog(@"depositDetail 归档成功, %@", _depositDetail);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里crash\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}


#pragma mark - 网络信息加载
- (void)accountInformationrStartLoading {
    [GJJAPI userAccount_公积金账号:[UserAccountInfo sharedUserAccountInfo].account completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        
        if ([result isKindOfClass:[NSDictionary class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSLog(@"账户查询信息加载完毕");
            self.userAccount = [result[@"data"] lastObject];
        }
    }];
    
    [GJJAPI loanBasicInformation_职工编号:[UserAccountInfo sharedUserAccountInfo].staffNumber 消息:nil completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSLog(@"贷款查询信息加载完毕");
            self.loanInformation = [result[@"data"] lastObject];
            
        }
    }];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [fmt stringFromDate:[NSDate date]];
    
    [GJJAPI loanRepaymentBasicInformation_职工编号:[UserAccountInfo sharedUserAccountInfo].staffNumber 消息:nil completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSDictionary *header = [result[@"data"] lastObject];
            if (header.count > 0) {
                dict[@"header"] = @{
                                    @"借款人" : header[@"jkrxm"],
                                    @"贷款状态" : header[@"dkzt"],
                                    @"本金余额" : header[@"bjye"],
                                    };
                if ([header[@"htbh"] length] > 0) {
                    [UserAccountInfo sharedUserAccountInfo].contractNumber = header[@"htbh"];
                    if (![[UserAccountInfo sharedUserAccountInfo] archive]) {
                        NSLog(@"userAccount 归档失败");
                    }
                }
            }

            [GJJAPI loanDetails_职工编号:[UserAccountInfo sharedUserAccountInfo].staffNumber 合同编号:[UserAccountInfo sharedUserAccountInfo].contractNumber 开始时间:@"1970-01-01" 结束时间:dateString completionHandler:^(id result, NSURLResponse *response, NSError *error) {
                if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"]) {
                    dict[@"detail"] = result[@"data"];
                    self.repaymentInfo = dict.copy;
                }
            }];
        }
    }];
    
    
    [GJJAPI loanProgressBasicInformation_职工编号:[UserAccountInfo sharedUserAccountInfo].staffNumber 消息:nil completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        
        if ([result isKindOfClass:[NSDictionary class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"header"] = [result[@"data"] lastObject];
            [GJJAPI loanApplicationStatus_职工编号:[UserAccountInfo sharedUserAccountInfo].staffNumber 申请编号:dict[@"header"][@"sqbh"] completionHandler:^(id result, NSURLResponse *response, NSError *error) {
                
                if ([result isKindOfClass:[NSDictionary class]] && [result[@"ret"] isEqualToString:@"0"]) {
                    dict[@"detail"] = result[@"data"];
                    self.loanProgress = dict;
                }
            }];
            
        }
        
    }];
    
    [GJJAPI depositDetail_公积金账户:[UserAccountInfo sharedUserAccountInfo].account 开始时间:@"1970-01-01" 结束时间:dateString completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSLog(@"缴存明细信息加载完毕");
            self.depositDetail = result[@"data"];
        }
    }];
}

@end
