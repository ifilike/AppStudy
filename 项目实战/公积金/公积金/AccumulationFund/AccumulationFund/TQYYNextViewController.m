//
//  TQYYNextViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "TQYYNextViewController.h"
#import "FundReferences.h"
#import "TQYYComplementViewController.h"
#import "TQYYOutletsPickerView.h"
#import "ConvenientTools.h"
#import "TQYYAccessoryBar.h"
#import "SVProgressHUD.h"
#import "GJJAPI.h"
#import "UserAccountInfo.h"
#import "UIViewController+KeyboardShowOrHide.h"


@interface TQYYNextViewController ()

@property (strong, nonatomic) NSString *outletCode;
@property (strong, nonatomic) TQYYOutletsPickerView *outletsPickerView;

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UITextField *textField2;
@property (strong, nonatomic) UITextField *textField3;



@property (strong, nonatomic) TQYYAccessoryBar *accessoryView;
@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation TQYYNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提取预约";
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outletsInformationDidLoad) name:@"outletsInfoDidLoadNotification" object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self keyboardDidAppear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self keyboardDidDisappear];
}

- (void)outletsInformationDidLoad {
    self.outletsPickerView.outlets = [ConvenientTools sharedConvenientTools].outlets;
    [self.outletsPickerView reloadAllComponents];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}

- (void)setUI {
    
    UILabel * label = [[UILabel alloc] init];
    UILabel * label2 = [[UILabel alloc] init];
    UILabel * label3 = [[UILabel alloc] init];
    [self.backView addSubview:label];
    [self.backView addSubview:label2];
    [self.backView addSubview:label3];
    label.text = @"证件编号录入";
    label2.text = @"选择预约日期";
    label3.text = @"选择网点";
    
    UITextField * credentialsField = [[UITextField alloc] init];
    credentialsField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField = credentialsField;
    UITextField * reservesDateField = [[UITextField alloc] init];
    reservesDateField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField2 = reservesDateField;
    UITextField * outletField = [[UITextField alloc] init];
    outletField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField3 = outletField;
    [self.backView addSubview:credentialsField];
    [self.backView addSubview:reservesDateField];
    [self.backView addSubview:outletField];
    credentialsField.backgroundColor = BackgroundColor;
    reservesDateField.backgroundColor = BackgroundColor;
    outletField.backgroundColor = BackgroundColor;

    
    reservesDateField.inputView = self.datePicker;
    reservesDateField.inputAccessoryView = self.accessoryView;
    outletField.inputView = self.outletsPickerView;
    outletField.inputAccessoryView = self.accessoryView;
    
    UIButton * complementButton = [[UIButton alloc] init];
    complementButton.backgroundColor = BarColor;
    [complementButton setTitle:@"完成" forState:UIControlStateNormal];
    [complementButton addTarget:self action:@selector(complementButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backView addSubview:complementButton];
    complementButton.translatesAutoresizingMaskIntoConstraints = false;
    
    label.translatesAutoresizingMaskIntoConstraints = false;
    label2.translatesAutoresizingMaskIntoConstraints = false;
    label3.translatesAutoresizingMaskIntoConstraints = false;
    
    credentialsField.translatesAutoresizingMaskIntoConstraints = false;
    reservesDateField.translatesAutoresizingMaskIntoConstraints = false;
    outletField.translatesAutoresizingMaskIntoConstraints = false;
    
    NSMutableArray * constraints = [NSMutableArray array];
    
    NSDictionary * subvies = @{
                               @"label" : label,
                               @"label2" : label2,
                               @"label3" : label3,
                               @"cred" : credentialsField,
                               @"date" : reservesDateField,
                               @"outlet" : outletField
                               };
    
    NSDictionary * metrics = @{
                               @"margin_v" : @(k_margin_vertical * 2),
                               @"margin_h" : @(k_margin_horizontal * 4),
                               @"btnH" : @(k_button_size.height * 0.7)
                               };
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-btnH-[label(btnH)]-margin_v-[cred(btnH)]-margin_v-[label2(btnH)]-margin_v-[date(btnH)]-margin_v-[label3(btnH)]-margin_v-[outlet(btnH)]" options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:metrics views:subvies]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.backView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:[metrics[@"margin_h"] floatValue]]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.backView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-[metrics[@"margin_h"] floatValue]]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:complementButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:outletField attribute:NSLayoutAttributeBottom multiplier:1.0 constant:[metrics[@"margin_h"] floatValue]]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:complementButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.backView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:complementButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:k_screen_width * 0.333]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:complementButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:k_button_size.height]];
    
    [self.view addConstraints:constraints];
    
}

#pragma mark outlet inputAccessoryView

- (TQYYAccessoryBar *)accessoryView {
    if (_accessoryView == nil) {
        _accessoryView = [[TQYYAccessoryBar alloc] init];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *selectionItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStyleDone target:self action:@selector(selectionButtonClick)];
        [_accessoryView setItems:@[spaceItem, selectionItem]];
    }
    return _accessoryView;
}

- (void)selectionButtonClick {
   
    [self.view endEditing:true];
}

#pragma mark 预约日期选取
- (UIDatePicker *)datePicker {
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.minimumDate = [NSDate date];
        _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 365];
        
    }
    return _datePicker;
}

#pragma mark outlets网点选取pickerView
- (TQYYOutletsPickerView *)outletsPickerView {
    if (_outletsPickerView == nil) {
        _outletsPickerView = [[TQYYOutletsPickerView alloc] init];
        if ([ConvenientTools sharedConvenientTools].outlets.count != 0) {
            _outletsPickerView.outlets = [ConvenientTools sharedConvenientTools].outlets;
       }
    }
    return _outletsPickerView;
}

- (void)complementButtonClick {
    if (self.textField2.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择预约日期" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (self.textField3.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择网点" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    
    [GJJAPI appointmentNumber_职工编号:[UserAccountInfo sharedUserAccountInfo].staffNumber 提取原因:self.drawReasonCode 预约网点:self.outletCode 预约日期:self.textField2.text completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"]) {
            
            TQYYComplementViewController *complementVC = [[TQYYComplementViewController alloc] init];
            
            if ([[result[@"data"] lastObject][@"yybh"] isKindOfClass:[NSString class]]) {
                complementVC.yybh = [result[@"data"] lastObject][@"yybh"];
                complementVC.appointedDate = self.textField2.text;
                complementVC.appointedOutlet = self.textField3.text;
                complementVC.drawReasonCode = self.drawReasonCode;
            }
            [self.navigationController pushViewController:complementVC animated:true];
        } else {
            [SVProgressHUD showErrorWithStatus:@"预约失败" maskType:SVProgressHUDMaskTypeBlack];
        }

    }];
    
}

@end
