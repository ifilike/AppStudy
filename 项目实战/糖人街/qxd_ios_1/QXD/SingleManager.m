//
//  SingleManager.m
//  QXD
//
//  Created by wzp on 15/12/25.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "SingleManager.h"
#import "MemberModel.h"


static SingleManager* manager=nil;
@implementation SingleManager



+ (SingleManager*)single{
    @synchronized(self) {
        if (manager==nil) {
            manager=[[SingleManager alloc] init];
            
        }
    }
    return manager;
}

- (void)setModel:(MemberModel*)model{

    _is_special_offer=model.is_special_offer;  //是否特惠
    _vip_descript=model.vip_descript;      //描述
    _vip_original_price=model.vip_original_price;//原价
    _vip_present_price=model.vip_present_price; //现价
    _vip_privilege=model.vip_privilege;     //特权
    _vip_time_limit=model.vip_time_limit;    //有效期
    _VID=model.VID;               //id
    
}




@end
