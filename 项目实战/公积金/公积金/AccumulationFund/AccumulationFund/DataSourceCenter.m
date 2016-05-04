//
//  DataSourceCenter.m
//  AccumulationFund
//
//  Created by mac on 15/12/7.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "DataSourceCenter.h"
#import "NewsModel.h"
#import "GJJAPI.h"

@interface DataSourceCenter ()

@property (strong, nonatomic) NSDateFormatter *formatter;
@property (assign, nonatomic) NSInteger i;

@end

@implementation DataSourceCenter


+ (instancetype)sharedDataSourceCenter {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _centerInfos = [self unarchiveForKey:@"center_infos_of_news.archiver"];
        _policyInfos = [self unarchiveForKey:@"policy_infos_of_news.archiver"];
        _workGuides = [self unarchiveForKey:@"work_guides_of_news.archiver"];
    }
    return self;
}


- (id)unarchiveForKey:(NSString *)key {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFilePathWithKey:key]];
}

- (BOOL)archiveWithArray:(NSArray *)array forKey:(NSString *)key {
    NSMutableArray *archiveArr = [NSMutableArray arrayWithArray:array];
    NSString *archivePath = [self getFilePathWithKey:key];
    return [NSKeyedArchiver archiveRootObject:archiveArr toFile:archivePath];
}

-(NSString *)getFilePathWithKey:(NSString *)key {
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[array lastObject] stringByAppendingPathComponent:key];
}

- (void)setCenterInfos:(NSArray *)centerInfos {
    if ([self dataInDisk:_centerInfos IsEqualToNewData:centerInfos]) {
        return;
    }
    _centerInfos = centerInfos;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"centerInfosDidLoadNotification" object:nil userInfo:nil];

    BOOL success = [self archiveWithArray:_centerInfos forKey:@"center_infos_of_news.archiver"];
    if (success) {
        NSLog(@"centerInfos 归档成功, 归档数据%li条", _centerInfos.count);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里carsh\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}

- (void)setPolicyInfos:(NSArray *)policyInfos {
    if ([self dataInDisk:_policyInfos IsEqualToNewData:policyInfos]) {
        return;
    }
    _policyInfos = policyInfos;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"policyInfosDidLoadNotification" object:nil userInfo:nil];

    BOOL success = [self archiveWithArray:_policyInfos forKey:@"policy_infos_of_news.archiver"];
    if (success) {
        NSLog(@"policyInfos 归档成功, 归档数据%li条", _policyInfos.count);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里carsh\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}

- (void)setWorkGuides:(NSArray *)workGuides {
    if ([self dataInDisk:_workGuides IsEqualToNewData:workGuides]) {
        return;
    }
    _workGuides = workGuides;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"workGuidesDidLoadNotification" object:nil userInfo:nil];
    
    BOOL success = [self archiveWithArray:_workGuides forKey:@"work_guides_of_news.archiver"];
    if (success) {
        NSLog(@"workGuides 归档成功, 归档数据%li条", _workGuides.count);
    } else {
        NSAssert(0, @"\n\nClass\t: %@\n_cmd\t\t: %@\nself\t\t: %@\nError\t: \"在这里carsh\"\n", self.class, NSStringFromSelector(_cmd), self);
    }
}

- (void)newsInformationStartLoading {
    [GJJAPI information_资讯类型:@"01" 消息:nil completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSLog(@"中心信息数据加载完毕");
            NSArray *temp = [[NewsModel modelsWithArray:result[@"data"]] sortedArrayUsingComparator:^NSComparisonResult(NewsModel *obj1, NewsModel *obj2) {
                NSDate *date1 = [self.formatter dateFromString:[obj1.date substringToIndex:18]];
                NSDate *date2 = [self.formatter dateFromString:[obj2.date substringToIndex:18]];
                return [date2 compare:date1];
            }];
            self.centerInfos = temp;
        }
        self.i++;
    }];
    
    [GJJAPI information_资讯类型:@"02" 消息:nil completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSLog(@"政策信息数据加载完毕");
            NSArray *temp = [[NewsModel modelsWithArray:result[@"data"]] sortedArrayUsingComparator:^NSComparisonResult(NewsModel *obj1, NewsModel *obj2) {
                NSDate *date1 = [self.formatter dateFromString:[obj1.date substringToIndex:18]];
                NSDate *date2 = [self.formatter dateFromString:[obj2.date substringToIndex:18]];
                return [date2 compare:date1];
            }];
            self.policyInfos = temp;
        }
        self.i++;
    }];
    
    [GJJAPI information_资讯类型:@"03" 消息:nil completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && [result[@"ret"] isEqualToString:@"0"]) {
            NSLog(@"办事指南数据加载完毕");
            NSArray *temp = [[NewsModel modelsWithArray:result[@"data"]] sortedArrayUsingComparator:^NSComparisonResult(NewsModel *obj1, NewsModel *obj2) {
                NSDate *date1 = [self.formatter dateFromString:[obj1.date substringToIndex:18]];
                NSDate *date2 = [self.formatter dateFromString:[obj2.date substringToIndex:18]];
                return [date2 compare:date1];
            }];
            self.workGuides = temp;
        }
        self.i++;
    }];
}

- (BOOL)dataInDisk:(NSArray *)diskArray IsEqualToNewData:(NSArray *)newArray {
    NewsModel *newModel = newArray.lastObject;
    NSDate *newDate;
    if (newModel.date.length > 18) {
        newDate = [self.formatter dateFromString:[newModel.date substringToIndex:18]];
    }
    NewsModel *lastModel = diskArray.lastObject;
    NSDate * lastDate;
    if (lastModel != nil && lastModel.date.length > 18) {
        lastDate = [self.formatter dateFromString:[lastModel.date substringToIndex:18]];
    }
    if (diskArray == nil || newArray.count != diskArray.count || NSOrderedSame != [newDate compare:lastDate]) {
        return false;
    }
    return true;
}

- (NSArray *)allNews {
    if (_allNews.count == 0 && self.centerInfos != nil && self.policyInfos != nil && self.workGuides != nil) {
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObjectsFromArray:self.centerInfos];
        [temp addObjectsFromArray:self.policyInfos];
        [temp addObjectsFromArray:self.workGuides];
        
        [temp sortUsingComparator:^NSComparisonResult(NewsModel *obj1, NewsModel *obj2) {
            NSDate *date1 = [self.formatter dateFromString:[obj1.date substringToIndex:18]];
            NSDate *date2 = [self.formatter dateFromString:[obj2.date substringToIndex:18]];
            return [date2 compare:date1];
        }];

        _allNews = temp.copy;
    }
    return _allNews;
}

- (void)setI:(NSInteger)i {
    _i = i;
    if (_i == 3) {
        _i = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"allNewsDidLoadNotification" object:nil];
        NSLog(@"所有新闻请求返回完毕");
    }
}

- (NSDateFormatter *)formatter {
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    }
    return _formatter;
}

@end
