//
//  WJNews.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/6.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJNews.h"
#import "MJExtension.h"
#import "NSDate+WJ.h"
@implementation WJNews

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"
             };
}

-(void)setID:(NSString *)ID
{
    _ID = ID;
    self.realRedirectUrl = [NSString stringWithFormat:@"http://2015.zzgjj.gov.cn/wap%@.html",ID];
}

-(void)setIndate:(NSString *)Indate
{
//    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
//    
//        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
//    
//        NSDate *date =[dateFormat dateFromString:@"2015-11-15 12:12:12"];
//        NSDateFormatter* dateFormat2 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
//    
//        [dateFormat2 setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
//    
//        self.cIndate = [dateFormat2 stringFromDate:date];
    
    _Indate = Indate;
    //1、字符串转换为日期
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSDate *date =[dateFormat dateFromString:Indate];
    
    //2、日期转换为字符串
    
    NSDateFormatter* dateFormat2 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat2 setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    
    self.cIndate = [dateFormat2 stringFromDate:date];
    
    
//    //将字符串转成日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"E M d HH:mm:ss Z yyyy"];
//    NSDate *date = [dateFormatter dateFromString:self.Indate];
//    
//    //将日期转换成字符串
//    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
//    
//    [outputFormatter setLocale:[NSLocale currentLocale]];
//    
//    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    self.cIndate= [outputFormatter stringFromDate:date];
    
}
@end
