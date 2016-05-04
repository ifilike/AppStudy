//
//  NSData+Encryption.h
//  AccumulationFund
//
//  Created by mac on 15/11/30.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

- (NSData *)AES256ParmEncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256ParmDecryptWithKey:(NSString *)key;   //解密

@end
