//
//  AddressModel.h
//  QXD
//
//  Created by zhujie on 平成27-11-27.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *area;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *province;
@property(nonatomic,copy) NSString *selected;
@property(nonatomic,copy) NSString *selfId;
-(id)initWithDict:(NSDictionary *)dict;
@end
