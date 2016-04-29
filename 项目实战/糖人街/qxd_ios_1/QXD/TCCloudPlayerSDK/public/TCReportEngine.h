//
//  TCReportEngine.h
//  TCCloudPlayerSDK
//
//  Created by AlexiChen on 15/9/10.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TCREVENTType)
{
    TCREVENT_UnKnow,                    // 未知事件
    TCREVENT_Ready,                     // 就绪事件上报
    TCREVENT_Play,                      // 播放事件上报
};

@interface TCReportItem : NSObject


- (instancetype)initWith:(NSString *)cloudURL;

- (void)configStepWith:(NSInteger)eventId paramInfo:(NSString *)info;

@end


@interface TCReportEngine : NSObject


+ (TCReportEngine *)sharedEngine;

// isTest : YES测试数据  NO正式数据 默认值 为正试环境
- (void)setEnv:(BOOL)isTest;

// 必须配置 appid 以及 logid
- (void)configAppId:(NSString *)appid;

// 以Get方式上报
- (void)getReport:(TCReportItem *)item;

// 以Post方式上报
- (void)postReport:(TCReportItem *)item;

@end
