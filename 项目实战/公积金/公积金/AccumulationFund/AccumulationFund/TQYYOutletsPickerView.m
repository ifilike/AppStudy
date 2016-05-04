//
//  TQYYOutletsPickerView.m
//  AccumulationFund
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "TQYYOutletsPickerView.h"
#import "FundReferences.h"

@interface TQYYOutletsPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation TQYYOutletsPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.showsSelectionIndicator = true;
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.outlets.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.outlets[row][@"mc"];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return k_screen_width;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:component];
}



@end
