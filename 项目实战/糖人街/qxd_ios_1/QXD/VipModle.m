//
//  VipModle.m
//  QXD
//
//  Created by zhujie on 平成27-12-04.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "VipModle.h"

@implementation VipModle
-(id)initWithDict:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self creatModelWithDic:dic];
    }
    return self;
}
-(void)creatModelWithDic:(NSDictionary *)dict{
    self.iconImg = [dict objectForKey:@"head_portrait"];
    self.nameLabel = [dict objectForKey:@"nickName"];
    self.vip_id = [dict objectForKey:@"id"];
    self.detailLabel = [dict objectForKey:@"vip_owner"];
}



@end
