//
//  WJNewsReturn.h
//  漳州公积金
//
//  Created by fengwujie on 16/1/8.
//  Copyright © 2016年 vision-soft. All rights reserved.
//  新闻返回结果模型

#import <Foundation/Foundation.h>

@interface WJNewsReturn : NSObject

/** 新闻数组（装着WJNews模型） */
@property (nonatomic, strong) NSArray *Details;

@end
