//
//  UserAccountInfo.m
//  AccumulationFund
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "UserAccountInfo.h"
#import "NSData+Encryption.h"

static NSString *const secretKey = @"&^&*!FTDAG&";

@implementation UserAccountInfo

#warning For-Test
//- (NSString *)staffNumber {
//    return @"100000070986";
//}
//
//- (NSString *)contractNumber {
//    return @"2005080501011183";
//}

#warning -------

//@synthesize username = _username;
//@synthesize cellphone = _cellphone;
//@synthesize password = _password;
//@synthesize account = _account;
//@synthesize staffNumber = _staffNumber;
//@synthesize contractNumber = _contractNumber;

+ (instancetype)sharedUserAccountInfo {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self unarchive];
    }
    return self;
}

// 加密
- (NSData *)encryptionWithString:(NSString *)string {
    return [[string dataUsingEncoding:NSUTF8StringEncoding] AES256ParmEncryptWithKey:secretKey];
}

// 解密
- (NSString *)DecryptionWithData:(NSData *)data {
    return [[NSString alloc] initWithData:[data AES256ParmDecryptWithKey:secretKey] encoding:NSUTF8StringEncoding];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self encryptionWithString:self.username] forKey:@"username"];
    [aCoder encodeObject:[self encryptionWithString:self.cellphone] forKey:@"cellphone"];
    [aCoder encodeObject:[self encryptionWithString:self.password] forKey:@"password"];
    [aCoder encodeObject:[self encryptionWithString:self.account] forKey:@"account"];
    [aCoder encodeObject:[self encryptionWithString:self.staffNumber] forKey:@"staff_number"];
    [aCoder encodeObject:[self encryptionWithString:self.contractNumber] forKey:@"contract_number"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        if (aDecoder == nil) {
            return nil;
        }
        self.username = [self DecryptionWithData:[aDecoder decodeObjectForKey:@"username"]];
        self.cellphone = [self DecryptionWithData:[aDecoder decodeObjectForKey:@"cellphone"]];
        self.password = [self DecryptionWithData:[aDecoder decodeObjectForKey:@"password"]];
        self.account = [self DecryptionWithData:[aDecoder decodeObjectForKey:@"account"]];
        self.staffNumber = [self DecryptionWithData:[aDecoder decodeObjectForKey:@"staff_number"]];
        self.contractNumber = [self DecryptionWithData:[aDecoder decodeObjectForKey:@"contract_number"]];
    }
    return self;
}

-(NSString *)getFilePath{
    NSString *path =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *userDirectory = [path stringByAppendingPathComponent:@"users"];
        
    if (![[NSFileManager defaultManager] fileExistsAtPath:userDirectory]) {
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:userDirectory withIntermediateDirectories:true attributes:nil error:nil];
        if (!success) {
            NSLog(@"用户目录创建失败");
        }
    }
    return [userDirectory stringByAppendingPathComponent:@"user_account.archiver"];
}

- (BOOL)archive {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:[UserAccountInfo sharedUserAccountInfo] forKey:@"user_account"];
    [archiver finishEncoding];
    
    return [data writeToFile:[self getFilePath] atomically:YES];
}

- (void)unarchive {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self getFilePath]]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:[self getFilePath]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        UserAccountInfo *userAccount = [unarchiver decodeObjectForKey:@"user_account"];
        [unarchiver finishDecoding];
        self.username = userAccount.username;
        self.cellphone = userAccount.cellphone;
        self.password = userAccount.password;
        self.account = userAccount.account;
        self.staffNumber = userAccount.staffNumber;
        self.contractNumber = userAccount.staffNumber;
    }
    NSLog(@"账户信息: %@", self);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n", self.username, self.cellphone, self.password, self.account, self.staffNumber, self.contractNumber];
}

@end
