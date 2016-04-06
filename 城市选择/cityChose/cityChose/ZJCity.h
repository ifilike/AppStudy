//
//  ZJCity.h
//  cityChose
//
//  Created by babbage on 16/4/3.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJCity : NSObject
/**
 *  城市ID
 */
@property(nonatomic,strong) NSString *cityID;
/**
 *  城市名称
 */
@property(nonatomic,strong) NSString *cityName;
/**
 *  短名称
 */
@property(nonatomic,strong) NSString *shortName;
/**
 *  城市名称-拼音
 */
@property(nonatomic,strong) NSString *pinyin;
/**
 *  城市名称-拼音首字母
 */
@property(nonatomic,strong) NSString *initials;

@end

#pragma mark -ZJCityGroup
@interface ZJCityGroup : NSObject
/**
 *  分组标题
 */
@property(nonatomic,strong) NSString *groupName;
/**
 *  城市数组
 */
@property(nonatomic,strong) NSMutableArray *arrayCitys;

@end











