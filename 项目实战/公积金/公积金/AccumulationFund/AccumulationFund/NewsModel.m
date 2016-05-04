
//
//  NewsModel.m
//  AccumulationFund
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "NewsModel.h"

@interface NewsModel ()


@end

@implementation NewsModel

+ (NSArray *)modelsWithArray:(NSArray *)array {
    NSMutableArray *modelsM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        NewsModel *temp = [[NewsModel alloc] init];
        temp.newsType = [dict[@"classid"] integerValue];
        temp.title = dict[@"ns_title"];
        temp.context = dict[@"ns_content"];
        temp.date = dict[@"ns_datendtime"];
        [modelsM addObject:temp];
    }
    return modelsM.copy;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        if (aDecoder == nil) {
            return nil;
        }
        self.newsType = [aDecoder decodeIntegerForKey:@"news_type"];
        self.title = [aDecoder decodeObjectForKey:@"news_title"];
        self.date = [aDecoder decodeObjectForKey:@"news_date"];
        self.context = [aDecoder decodeObjectForKey:@"news_context"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.newsType forKey:@"news_type"];
    [aCoder encodeObject:self.title forKey:@"news_title"];
    [aCoder encodeObject:self.date forKey:@"news_date"];
    [aCoder encodeObject:self.context forKey:@"news_context"];
}



- (NSString *)description {
    return self.date;
}

@end
