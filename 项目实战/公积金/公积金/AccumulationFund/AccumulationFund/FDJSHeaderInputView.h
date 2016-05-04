//
//  FDJSHeaderInputView.h
//  AccumulationFund
//
//  Created by mac on 15/12/17.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDJSHeaderView.h"

@interface FDJSHeaderInputView : UIView


@property (weak, nonatomic) IBOutlet UILabel *maxAmoutLabel;
@property (weak, nonatomic) IBOutlet UITextField *needAmoutLabel;

@property (weak, nonatomic) IBOutlet UITextField *needLoanDateLabel;


@property (weak, nonatomic) IBOutlet UIButton *calculationButton;

@end
