//
//  ScheduleModle.h
//  QXD
//
//  Created by zhujie on 平成28-01-22.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleModle : NSObject

@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *create_time;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end
