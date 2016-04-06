//
//  ZJChooseCityDelegate.h
//  cityChose
//
//  Created by babbage on 16/4/2.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZJChooseCityController;
@class ZJCity;

@protocol ZJChooseCityDelegate <NSObject>

-(void) cityPickerControllerDidCancel:(ZJChooseCityController *)chooseCityController;
-(void) cityPickerController:(ZJChooseCityController *)chooseCityController didSelectCity:(ZJCity *)city;

@end
@protocol ZJCityGroupCellDelegate <NSObject>

-(void) cityGroupCellDidSelectCity:(ZJCity *)city;

@end