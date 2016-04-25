//
//  ZJTextStorageParser.h
//  CoreText
//
//  Created by babbage on 16/4/22.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJTextStorageParser : NSObject

+ (NSArray *)parseWithJsonFilePath:(NSString *)filePath;

+ (NSArray *)parseWithJsonData:(NSData *)jsonData;

+ (NSArray *)parseWithJsonArray:(NSArray *)jsonArray;

@end
