//
//  UserIDModle.h
//  QXD
//
//  Created by wzp on 15/12/4.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserIDModle : NSObject

@property(nonatomic,copy)NSString *binding_num;
@property(nonatomic,copy)NSString *birthday;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *head_portrait;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *is_binding;
@property(nonatomic,copy)NSString *is_vip;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *vip_id;
@property(nonatomic,copy)NSString *vip_owner;
@property(nonatomic,copy)NSString *vip_time_limit;
@property(nonatomic,copy)NSString *vip_discount;

@property(nonatomic,copy)NSString *load_type;//登录类型
@property(nonatomic,copy)NSString *third_id;//第三方登录id
@property(nonatomic,copy)NSString *qq_id;//qq的id
@property(nonatomic,copy)NSString *wb_id;//wb的id
@property(nonatomic,copy)NSString *wx_id;//wx的id
@property(nonatomic,copy)NSString *password;//mima


@end
