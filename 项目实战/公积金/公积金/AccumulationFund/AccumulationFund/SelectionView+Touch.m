//
//  SelectionView+Touch.m
//  AccumulationFund
//
//  Created by mac on 15/11/17.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "SelectionView+Touch.h"

@implementation SelectionView (Touch)

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.selected = !self.selected;
}

@end
