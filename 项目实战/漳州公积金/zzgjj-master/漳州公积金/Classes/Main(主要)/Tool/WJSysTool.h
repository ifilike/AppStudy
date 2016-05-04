//
//  WJSysTool.h
//  漳州公积金
//
//  Created by fengwujie on 16/1/5.
//  Copyright © 2016年 vision-soft. All rights reserved.
//  系统通用方法类

#import <Foundation/Foundation.h>

/**
 *  设备型号
 */
typedef enum{
    /** 320*480  3.5寸*/
    DeviceModeliPhone4,
    /** 320*568  4寸*/
    DeviceModeliPhone5,
    /** 375*667 6和6S屏幕大小一样都是4.7寸*/
    DeviceModeliPhone6,
    /** 414*736 6Plus和6S Plus屏幕大小一样都是5.5寸*/
    DeviceModeliPhone6Plus,
    /** 未知设备型号，按iPhone5处理 */
    DeviceModelUnKnown
} DeviceModel;

@interface WJSysTool : NSObject

/**
 *  退出程序
 */
+ (void)exitApplication;

//+ (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context ;
/**
 *  获取设备型号
 */
+ (DeviceModel)deviceModel;

/**
 *  获取导航栏字体大小
 */
+ (UIFont *) navigationTitleFont;
/**
 *  显示提示信息
 *
 *  @param msgtitle 标题内容
 *  @param msgText  文本内容
 */
+ (void)ShowMessage : (NSString*)msgtitle : (NSString*)msgText;
@end
