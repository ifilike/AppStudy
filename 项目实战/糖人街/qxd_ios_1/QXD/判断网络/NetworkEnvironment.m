//
//  NetworkEnvironment.m
//  MyProject
//
//  Created by 韩阿丽 on 14-9-25.
//  Copyright (c) 2014年 张云波. All rights reserved.
//

#import "NetworkEnvironment.h"
#import "Reachability.h"
static NetworkEnvironment * g_instance = nil;
@implementation NetworkEnvironment

+ (NetworkEnvironment *)sharedInstance
{
    @synchronized(self){
        if (g_instance == nil) {
            g_instance = [[NetworkEnvironment alloc] init];
        }
        return g_instance;
    }
}
- (BOOL)isNetworkReachable
{
    BOOL isReachable = NO;
    Reachability * reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:
            isReachable = NO;
            break;
        case ReachableViaWiFi:
            isReachable = YES;
            break;
        case ReachableViaWWAN:
            isReachable = YES;
            break;
            
        default:isReachable = NO;
            break;
    }
    return isReachable;
}
- (BOOL)isEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
- (BOOL)isEnable3G
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

@end
