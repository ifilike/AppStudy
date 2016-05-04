//
//  WJUpdateTool.h
//  漳州公积金
//
//  Created by fengwujie on 16/1/5.
//  Copyright © 2016年 vision-soft. All rights reserved.
//  软件升级操作类

#import <Foundation/Foundation.h>

@interface WJUpdateTool : NSObject

/*
 检查是否需要升级
 */
+(void)CheckUpdate;


+(void)CheckUpdate:(BOOL) prompt;


@end
