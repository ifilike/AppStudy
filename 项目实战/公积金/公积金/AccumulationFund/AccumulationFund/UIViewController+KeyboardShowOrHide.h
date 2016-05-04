//
//  UIViewController+KeyboardShowOrHide.h
//  AccumulationFund
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (KeyboardShowOrHide)

/*
    Usage
    - (void)viewDidAppear:(BOOL)animated {
        [super viewDidAppear:animated];
        [self keyboardDidAppear];
    }
 
    - (void)viewDidDisappear:(BOOL)animated {
        [super viewDidDisappear:animated];
        [self keyboardDidDisappear];
    }
 */
- (void)keyboardDidAppear;
- (void)keyboardDidDisappear;


@end
