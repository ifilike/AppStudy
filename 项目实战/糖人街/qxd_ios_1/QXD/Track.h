//
//  Track.h
//  QXD
//
//  Created by zhujie on 平成28-01-23.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject
//
//@property(nonatomic,copy) NSString * content;
//@property(nonatomic,copy) NSString * create_time;
//@property(nonatomic,copy) NSString * ID;
//@property(nonatomic,copy) NSString * order_id;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *time;

-(id)initWithDic:(NSDictionary *)dic;

@end
