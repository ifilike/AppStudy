//
//  SelectionView.h
//  SelectedList
//
//  Created by mac on 15/11/14.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionViewDelegate.h"


typedef NS_OPTIONS(NSInteger, SelectionViewType) {
    SelectionViewTypeSingleSelection = 0,
    SelectionViewTypeMultipleIndicator
};


@interface SelectionView : UIView 

@property (assign, nonatomic, getter=isSelected) BOOL selected;
@property (strong, nonatomic) UILabel * textLabel;

@property (weak, nonatomic) id <SelectionViewDelegate> delegate;


- (instancetype)initWithType:(SelectionViewType)type;
@end
