//
//  WJNewsTool.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/8.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJNewsTool.h"
#import "MJExtension.h"
#import "WJHttpTool.h"
#import "WJNews.h"

@implementation WJNewsTool


+ (void)newsWithParam:(WJNewsParam *)param success:(void (^)(WJNewsReturn *))success failure:(void (^)(NSError *))failure
{
    
//    // 从数据库中读取（加载）缓存数据(微博模型数组)
//    NSArray *cachedHomeStatuses = [self cachedHomeStatusesWithParam:param];
//    if (cachedHomeStatuses.count != 0) { // 有缓存数据
//        if (success) {
//            HMHomeStatusesResult *result = [[HMHomeStatusesResult alloc] init];
//            result.statuses = cachedHomeStatuses;
//            success(result);
//        }
//    } else { // 没有缓存数据
    
    param.methodName = @"TableToJsonPageDate";
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                             <soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\
                             <soap12:Body>\
                             <%@ xmlns=\"http://tempuri.org/\">\
                             <lmid>%@</lmid>\
                             <mindate>%@</mindate>\
                             <maxdate>%@</maxdate>\
                             <size>%@</size>\
                             </%@>\
                             </soap12:Body>\
                             </soap12:Envelope>",
                             param.methodName, param.lmid, param.mindate, param.maxdate, param.size,param.methodName];
    param.soapMessage = soapMessage;
        NSDictionary *params = [param mj_keyValues];
    
    [WJHttpTool post:@"http://webservice.zzgjj.gov.cn/DataServiceWeb.asmx" params:params success:^(id responseObj) {
        if (success) {
            //WJNewsReturn *result = [WJNewsReturn mj_objectWithKeyValues:responseObj];
            WJNewsReturn *result = [[WJNewsReturn alloc] init];
            NSArray *resultTemp = [WJNews mj_objectArrayWithKeyValuesArray:responseObj];
            result.Details = resultTemp;
            success(result);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    /*
        [WJHttpTool get:@"http://webservice.zzgjj.gov.cn/DataServiceWeb.asmx" params:params success:^(id responseObj) {
            //WJLog(@"请求成功！ %@",responseObj);
            // 新浪返回的字典数组
//            NSArray *statusDictArray = responseObj[@"statuses"];
            
            // 缓存微博字典数组
//            [self saveHomeStatusDictArray:statusDictArray accessToken:param.access_token];
            
            if (success) {
                WJNewsReturn *result = [WJNewsReturn mj_objectWithKeyValues:responseObj];
                success(result);
            }
        } failure:^(NSError *error) {
            //WJLog(@"请求失败！ %@",error);
            if (failure) {
                failure(error);
            }
        }];
    */
    
    /*
    NSDictionary *params = [param mj_keyValues];
    [WJHttpTool post:@"http://webservice.zzgjj.gov.cn/DataServiceWeb.asmx?op=TableToJson" params:params success:^(id responseObj) {
        WJLog(@"%@",responseObj);
        // 新浪返回的字典数组
        //            NSArray *statusDictArray = responseObj[@"statuses"];
        
        // 缓存微博字典数组
        //            [self saveHomeStatusDictArray:statusDictArray accessToken:param.access_token];
        
        if (success) {
            WJNewsReturn *result = [WJNewsReturn mj_objectWithKeyValues:responseObj];
            success(result);
        }
    } failure:^(NSError *error) {
        WJLog(@"%@",error);
        if (failure) {
            failure(error);
        }
    }];
    */
    
//    }

}


@end
