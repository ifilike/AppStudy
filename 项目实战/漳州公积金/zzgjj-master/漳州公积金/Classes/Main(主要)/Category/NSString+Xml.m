//
//  NSString+Xml.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/13.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "NSString+Xml.h"

@implementation NSString (Xml)

-(NSString *)stringByXmlNoteContentWithElementName:(NSString *)elementName
{
    // 返回XML串中的数据体开头<方法名Result>的位置
    NSRange rangeBegin = [self rangeOfString:[NSString stringWithFormat:@"<%@>",elementName]];
    // 返回XML串中的数据体结尾</方法名>的位置
    NSRange rangeEnd = [self rangeOfString:[NSString stringWithFormat:@"</%@>",elementName]];
    // 截取字符串的开始位置
    long beginIndex = rangeBegin.location + rangeBegin.length;
    // 截取字符串的结束位置
    long endIndex = rangeEnd.location - beginIndex;
    return [self substringWithRange:NSMakeRange(beginIndex,endIndex)];
}
@end
