//
//  NetworkEnvironment.h
//  MyProject
//
//  Created by 韩阿丽 on 14-9-25.
//  Copyright (c) 2014年 张云波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkEnvironment : NSObject
+ (NetworkEnvironment *)sharedInstance;
- (BOOL)isNetworkReachable;
- (BOOL)isEnableWIFI;
- (BOOL)isEnable3G;
@end
