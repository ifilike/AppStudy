//
//  ZJCity.m
//  cityChose
//
//  Created by babbage on 16/4/3.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ZJCity.h"

@implementation ZJCity

@end

@implementation ZJCityGroup

-(NSMutableArray *)arrayCitys{
    if (!_arrayCitys) {
        _arrayCitys = [[NSMutableArray alloc] init];
    }
    return _arrayCitys;
}

@end