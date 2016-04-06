//
//  ZJChooseCityController.h
//  cityChose
//
//  Created by babbage on 16/4/2.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJChooseCityDelegate.h"
#define     MAX_COMMON_CITY_NUMBER      8
#define     COMMON_CITY_DATA_KEY        @"GYZCommonCityArray"
#define IOS8 [[[UIDevice currentDevice] systemVersion]floatValue]>=8.0

@interface ZJChooseCityController : UITableViewController

@property(nonatomic,assign) id <ZJChooseCityDelegate> delegate;

@end
