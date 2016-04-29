//
//  VipModle.h
//  QXD
//
//  Created by zhujie on 平成27-12-04.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipModle : NSObject

@property(nonatomic,copy) NSString *iconImg;
@property(nonatomic,copy) NSString *nameLabel;
@property(nonatomic,copy) NSString *vip_id;
@property(nonatomic,copy) NSString *detailLabel;

-(id)initWithDict:(NSDictionary *)dic;
@end
