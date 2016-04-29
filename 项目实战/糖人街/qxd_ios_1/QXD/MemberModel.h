//
//  MemberModel.h
//  QXD
//
//  Created by wzp on 15/12/7.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberModel : NSObject


@property(nonatomic,retain)NSString * is_special_offer;  //是否特惠
@property(nonatomic,retain)NSString * vip_descript;      //描述
@property(nonatomic,retain)NSString * vip_original_price;//原价
@property(nonatomic,retain)NSString * vip_present_price; //现价
@property(nonatomic,retain)NSString * vip_privilege;     //特权
@property(nonatomic,retain)NSString * vip_time_limit;    //有效期
@property(nonatomic,retain)NSString * VID;               //id




@end
