//
//  RevisionViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/23.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "RevisionViewController.h"
#import "UIViewController+KeyboardShowOrHide.h"


@interface RevisionViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons;
@property (weak, nonatomic) IBOutlet UITextField *label1;
@property (weak, nonatomic) IBOutlet UITextField *label2;
@property (weak, nonatomic) IBOutlet UITextField *label3;
@property (weak, nonatomic) IBOutlet UITextField *label4;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation RevisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat I6PStdHeight;
    if ([UIScreen mainScreen].bounds.size.width == 375) {
        I6PStdHeight = 40;
    } else if ([UIScreen mainScreen].bounds.size.width > 375) {
        I6PStdHeight = 60;
    } else if ([UIScreen mainScreen].bounds.size.width < 375) {
        I6PStdHeight = 30;
    }
    self.heightCons1.constant = I6PStdHeight;
    self.heightCons2.constant = I6PStdHeight;
    self.heightCons3.constant = I6PStdHeight * 1.5;
    self.widthCons.constant = [UIScreen mainScreen].bounds.size.width * 0.75;
    
    
    self.label1.delegate = self;
    self.label2.delegate = self;
    self.label3.delegate = self;
    self.label4.delegate = self;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self keyboardDidAppear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self keyboardDidDisappear];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag < 100003) {
        UIView * v = [self.view viewWithTag:(textField.tag + 1)];
        NSLog(@"%@", v);
        [v becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        if (self.confirmButton.enabled) {
            [self.confirmButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
    return true;
}


@end
