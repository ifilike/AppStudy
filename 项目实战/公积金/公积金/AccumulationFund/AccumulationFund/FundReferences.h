//
//  FundReferences.h
//  AccumulationFund
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIkit.h>



#pragma mark --------------------------FONT--------------------------
#define k_title_font [UIFont systemFontOfSize:27]
#define k_text_font [UIFont systemFontOfSize:18]

#pragma mark --------------------------GEOM--------------------------
#define k_screen_width [UIScreen mainScreen].bounds.size.width
#define k_screen_height [UIScreen mainScreen].bounds.size.height

extern CGFloat k_margin_vertical;
extern CGFloat k_margin_horizontal;


#pragma mark --------------------------COLOR--------------------------

#define BarColor [UIColor colorWithRed:100/255.0 green:202/255.0 blue:216/255.0 alpha:0.9]
#define BackgroundColor [UIColor colorWithRed:233/255.0 green:232/255.0 blue:232/255.0 alpha:1]

#pragma mark - font
//设置字体大小
#define YFont(x) [UIFont systemFontOfSize:x];
//设置粗体字体大小
#define YBFont(x) [UIFont boldSystemFontOfSize:x];

#pragma mark 便民工具

#pragma mark --------------------------便民工具--------------------------

// 主界面
// item尺寸百分比
extern CGFloat k_section0_side_percent;
// cell的间隔
extern CGFloat k_collection_cell_margin;

extern CGFloat k_tqyy_row_height;

// cell尺寸
#define k_collection_cell_side ((k_screen_height - k_collection_cell_margin * 5 - 64 - 49) * 0.25)

// cell_icon尺寸
#define k_collection_cell_icon_side k_screen_width * k_section0_side_percent * 0.4

//退休提取
#define k_button_size CGSizeMake(k_screen_width * 0.6, k_screen_height * 0.06666666)




#pragma mark --------------------------关于我们--------------------------
// 主界面
// cell_icon尺寸
extern CGFloat k_about_cell_icon_side;


#pragma mark --------------------------DEVICE--------------------------
#define mySystemVersion [UIDevice currentDevice].systemVersion.doubleValue