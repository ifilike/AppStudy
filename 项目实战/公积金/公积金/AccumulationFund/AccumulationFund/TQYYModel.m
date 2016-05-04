//
//  TQYYModel.m
//  AccumulationFund
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "TQYYModel.h"

@implementation TQYYModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)modelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)modelsWithArray:(NSArray *)array {
    NSMutableArray * models = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        TQYYModel *model = [TQYYModel modelWithDict:dict];
        if ([dict isEqual:array.firstObject]) {
            model.selected = true;
        }
        [models addObject:model];

    }
    return models.copy;
}

@end
