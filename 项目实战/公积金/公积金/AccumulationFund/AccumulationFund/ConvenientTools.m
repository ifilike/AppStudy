//
//  ConvenientTools.m
//  AccumulationFund
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "ConvenientTools.h"
#import "GJJAPI.h"
#import "UserAccountInfo.h"

@implementation ConvenientTools

+ (instancetype)sharedConvenientTools {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (instancetype)init {
    if (self = [super init]) {
        _mapBranchs = [self unarchiveForKey:@"map_branchs_info.archiver"];
        _drawReason = [self unarchiveForKey:@"draw_reason_info.archiver"];
        _outlets = [self unarchiveForKey:@"outlets_info.archiver"];
        _purchaseType = [self unarchiveForKey:@"purchase_type_info.archiver"];
        _appointmentBranch = [self unarchiveForKey:@"appointment_branch_info.archiver"];
        
        
        _appointedInfo = [self unarchiveForKey:@"appointed_info.archiver"];
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



#pragma mark - SettingProperties

#pragma mark 地图

- (void)setMapBranchs:(NSArray *)mapBranchs {
    if ([_mapBranchs.description isEqualToString:mapBranchs.description]) {
        return;
    }
    _mapBranchs = mapBranchs;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mapBranchsInfoDidLoadNotification" object:nil];
    BOOL success = [NSKeyedArchiver archiveRootObject:_drawReason toFile:[self getFilePathWithKey:@"map_branchs_info.archiver"]];
    if (success) {
        NSLog(@"mapBranchs 归档成功, %@", _mapBranchs);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里crash\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}

#pragma mark 提取预约
// 提取原因
- (void)setDrawReason:(NSArray *)drawReason {
    if ([_drawReason.description isEqualToString:drawReason.description]) {
        return;
    }
    _drawReason = drawReason;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"drawReasonInfoDidLoadNotification" object:nil];
    BOOL success = [NSKeyedArchiver archiveRootObject:_drawReason toFile:[self getFilePathWithKey:@"draw_reason_info.archiver"]];
    if (success) {
        NSLog(@"drawReason 归档成功, %@", _drawReason);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里crash\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}
// 提取网点
- (void)setOutlets:(NSArray *)outlets {
    if ([_outlets.description isEqualToString:outlets.description]) {
        return;
    }
    _outlets = outlets;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"outletsInfoDidLoadNotification" object:nil];
    BOOL success = [NSKeyedArchiver archiveRootObject:_outlets toFile:[self getFilePathWithKey:@"outlets_info.archiver"]];
    if (success) {
        NSLog(@"outlets 归档成功, %@", _outlets);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里crash\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}

#pragma mark 贷款预约

// 购房类型
- (void)setPurchaseType:(NSArray *)purchaseType {
    if ([_purchaseType.description isEqualToString:purchaseType.description]) {
        return;
    }
    _purchaseType = purchaseType;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseTypeInfoDidLoadNotification" object:nil];
    BOOL success = [NSKeyedArchiver archiveRootObject:_purchaseType toFile:[self getFilePathWithKey:@"purchase_type_info.archiver"]];
    if (success) {
        NSLog(@"purchaseType 归档成功, %@", _purchaseType);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里crash\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}

// 预约网点
- (void)setAppointmentBranch:(NSArray *)appointmentBranch {
    if ([_appointmentBranch.description isEqualToString:appointmentBranch.description]) {
        return;
    }
    _appointmentBranch = appointmentBranch;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appointmentBranchInfoDidLoadNotification" object:nil];
    BOOL success = [NSKeyedArchiver archiveRootObject:_appointmentBranch toFile:[self getFilePathWithKey:@"appointment_branch_info.archiver"]];
    if (success) {
        NSLog(@"appointmentBranch 归档成功, %@", _appointmentBranch);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里crash\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}






// 预约查询
- (void)setAppointedInfo:(NSArray *)appointedInfo {
    if ([_appointedInfo.description isEqualToString:appointedInfo.description]) {
        return;
    }
    _appointedInfo = appointedInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appointedInfoDidLoadNotification" object:nil];
    BOOL success = [NSKeyedArchiver archiveRootObject:_appointedInfo toFile:[self getFilePathWithKey:@"appointed_info.archiver"]];
    if (success) {
        NSLog(@"appointedInfo 归档成功, %@", _appointedInfo);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里crash\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}


#pragma mark - 网络信息加载

- (void)convenientToolsInformationrStartLoading {
    // mapBraches
    [GJJAPI branchSearchWithCompletionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSLog(@"地图网点信息加载完毕");
            self.mapBranchs = result[@"data"];
        }
    }];
    
    // 提取原因
    [GJJAPI drawAppointment_职工编号:[UserAccountInfo sharedUserAccountInfo].staffNumber 消息:nil completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSLog(@"提取原因信息加载完毕");
            self.drawReason = result[@"data"];
        }
        
    }];
    
    // 提取网点
    [GJJAPI outletsWithCompletionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSLog(@"提取网点信息加载完毕");
            self.outlets = result[@"data"];
        }
    }];
    
    // 购房类型
    [GJJAPI purchaseTypeWithCompletionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSLog(@"购房类型信息加载完毕");
            self.purchaseType = result[@"data"];
        }
    }];
    
    // 预约网点
    [GJJAPI appointmentBranchWithCompletionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSLog(@"预约网点信息加载完毕");
            self.appointmentBranch = result[@"data"];
        }
    }];
    
    
    
    
    
    
    // 预约查询
    [GJJAPI appointmentInformation_职工编号:[UserAccountInfo sharedUserAccountInfo].staffNumber 消息:nil completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSLog(@"预约查询信息加载完毕");
            self.appointedInfo = result[@"data"];
        }
    }];
}


@end
