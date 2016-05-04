//
//  RouteAnnotation.h
//  AccumulationFund
//
//  Created by SL🐰鱼子酱 on 15/12/18.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end
