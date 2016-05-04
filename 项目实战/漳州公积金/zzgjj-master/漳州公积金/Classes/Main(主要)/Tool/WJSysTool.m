//
//  WJSysTool.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/5.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJSysTool.h"

@implementation WJSysTool

+ (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //[UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:window cache:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}

+ (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
    
}

+ (DeviceModel)deviceModel
{
    float screenHeight = Screen_height;
    if(screenHeight == 480)
    {
        return DeviceModeliPhone4;
    }
    else if(screenHeight == 568)
    {
        return DeviceModeliPhone5;
    }
    else if(screenHeight == 667)
    {
        return DeviceModeliPhone6;
    }
    else if(screenHeight == 736)
    {
        return DeviceModeliPhone6Plus;
    }
    else
    {
        return DeviceModelUnKnown;
    }
}

+ (UIFont *)navigationTitleFont
{
    float fontSize;
    DeviceModel deviceModel = [WJSysTool deviceModel];
    if (deviceModel == DeviceModeliPhone4) {
        fontSize = 16;
    }
    else if (deviceModel == DeviceModeliPhone5) {
        fontSize = 18;
    }
    else if (deviceModel == DeviceModeliPhone6) {
        fontSize = 19;
    }
    else if(deviceModel == DeviceModeliPhone6Plus )
    {
        fontSize = 20;
    }
    return [UIFont systemFontOfSize:fontSize];
}

/*
 显示提示消息（自定义标题）
 */

+(void)ShowMessage : (NSString*)msgtitle : (NSString*)msgText
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:msgtitle message:msgText delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alter show];
}
@end
