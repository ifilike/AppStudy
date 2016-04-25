//
//  ZJTextStorageParser.m
//  CoreText
//
//  Created by babbage on 16/4/22.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ZJTextStorageParser.h"
#import "ZJTextContainer.h"

@implementation ZJTextStorageParser

+ (NSArray *)parseWithJsonFilePath:(NSString *)filePath
{
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    return [self parseWithJsonData:jsonData];
}

+ (NSArray *)parseWithJsonData:(NSData *)jsonData
{
    if (jsonData == nil)  return nil ;
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingAllowFragments
                                                       error:nil];
    return [self parseWithJsonArray:array];
}

+ (NSArray *)parseWithJsonArray:(NSArray *)jsonArray
{
    if (jsonArray) {
        NSMutableArray *textStorageArray = [NSMutableArray array];
        
        if ([jsonArray isKindOfClass:[NSArray class]]){
            
            for (NSDictionary *dic in jsonArray) {
                NSString *type = dic[@"type"];
                id<ZJAppendTextStorageProtocol> textStorage = nil;
                
                if ([type isEqualToString:@"txt"]) {
                    // 解析文本
                    textStorage = [self parseTextStorageFromDictinary:dic];
                } else if ([type isEqualToString:@"img"]) {
                    // 解析图片
                    textStorage = [self parseImageRunFromDictinary:dic];
                } else if ([type isEqualToString:@"link"]) {
                    // 解析链接
                    textStorage = [self parseLinkRunFromDictinary:dic];
                }
                
                if (textStorage) {
                    [textStorageArray addObject:textStorage];
                }
            }
            
        }
        return [textStorageArray copy];
    }
    return nil;
}

+ (id<ZJAppendTextStorageProtocol>)parseTextStorageFromDictinary:(NSDictionary *)dic
{
    ZJTextStorage *textStorage = [[ZJTextStorage alloc]init];
    textStorage.text = dic[@"content"];
    NSInteger fontSize = [dic[@"size"] integerValue];
    if (fontSize > 0) {
        textStorage.font = [UIFont systemFontOfSize:fontSize];
    }
    textStorage.textColor = [self colorFromTemplate:dic[@"color"]];
    
    return textStorage;
}

+ (id<ZJDrawStorageProtocol>)parseImageRunFromDictinary:(NSDictionary *)dic
{
    ZJImageStorage *imageStorage = [[ZJImageStorage alloc]init];
    imageStorage.imageName = dic[@"name"];
    imageStorage.imageAlignment = ZJImageAlignmentRight;
    imageStorage.size = CGSizeMake([dic[@"width"] doubleValue], [dic[@"height"] doubleValue]);
    
    return imageStorage;
}

+ (id<ZJAppendTextStorageProtocol>)parseLinkRunFromDictinary:(NSDictionary *)dic
{
    ZJLinkTextStorage *linkStorage = [[ZJLinkTextStorage alloc]init];
    linkStorage.text = dic[@"content"];
    linkStorage.font = [UIFont systemFontOfSize:[dic[@"size"] integerValue]];
    linkStorage.textColor = [self colorFromTemplate:dic[@"color"]];
    linkStorage.linkData = dic[@"url"];
    
    return linkStorage;
}

+ (UIColor *)colorFromTemplate:(NSString *)name
{
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"black"]) {
        return [UIColor blackColor];
    } else if ([name isEqualToString:@"orange"]) {
        return [UIColor orangeColor];
    }else if ([name isEqualToString:@"green"]) {
        return [UIColor greenColor];
    }else if ([name isEqualToString:@"default"]){
        return [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    }else {
        return nil;
    }
}

@end
