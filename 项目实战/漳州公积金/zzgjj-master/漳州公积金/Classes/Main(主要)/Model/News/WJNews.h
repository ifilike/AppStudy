//
//  WJNews.h
//  漳州公积金
//
//  Created by fengwujie on 16/1/6.
//  Copyright © 2016年 vision-soft. All rights reserved.
//  新闻模型

#import <Foundation/Foundation.h>

@interface WJNews : NSObject
/**
 *  新闻ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *FTitle;
/**
 *  发布日期
 */
@property (nonatomic, copy) NSString *Indate;
/**
 *  新闻跳转URL地址，目前没有，服务器返回的是空值，
 */
@property (nonatomic, copy) NSString *RedirectUrl;
/**
 *  日期，年月日
 */
@property (nonatomic, copy) NSString *cIndate;

/**
 *  新闻真实的跳转链接
 */
@property (nonatomic, copy) NSString *realRedirectUrl;

@end
