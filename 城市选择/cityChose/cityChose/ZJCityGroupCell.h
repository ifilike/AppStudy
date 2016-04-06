//
//  ZJCityGroupCell.h
//  cityChose
//
//  Created by babbage on 16/4/2.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJChooseCityDelegate.h"

#define     WIDTH_LEFT          13.5        // button左边距
#define     WIDTH_RIGHT         28          // button右边距
#define     MIN_SPACE           8           // 城市button最小间隙
#define     MAX_SPACE           10         //城市button的最大间距
#define     MIN_WIDTH_BUTTON    75
#define     HEIGHT_BUTTON       38

@interface ZJCityGroupCell : UITableViewCell
@property(nonatomic,assign) id<ZJCityGroupCellDelegate> delegate;
/**
 *  标题
 */
@property (nonatomic,strong) UILabel *titleLabel;
/**
 *  暂无数据
 */
@property (nonatomic,strong) UILabel *noDataLabel;
/**
 *  城市数据信息
 */
@property (nonatomic,strong) NSArray *cityArray;
/**
 *  btn数组
 */
@property(nonatomic,strong) NSMutableArray *arrayCityButtons;
/**
 *  返回高度的方法
 */
+(CGFloat) getCellHeightOfCityArray:(NSArray *)cityArray;


@end
