//
//  TQYYModel.h
//  AccumulationFund
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TQYYModel : NSObject

@property (copy, nonatomic) NSString *mc;
@property (copy, nonatomic) NSString *bm;
@property (assign, nonatomic) BOOL selected;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
+ (NSArray *)modelsWithArray:(NSArray *)array;
@end
