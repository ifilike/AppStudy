//
//  DKYYViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "DKYYViewController.h"
#import "FundReferences.h"
#import "DKYYXQViewController.h"
#import "ConvenientTools.h"
#import "TQYYAccessoryBar.h"
#import "DKYYPickerView.h"
#import "UIViewController+KeyboardShowOrHide.h"
#import "SVProgressHUD.h"
#import "GJJAPI.h"
#import "UserAccountInfo.h"


@interface DKYYViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField * typeField;
@property (strong, nonatomic) UITextField * numberField;
@property (strong, nonatomic) UITextField * reservesDateField;
@property (strong, nonatomic) UITextField * reservesOutletField;

@property (strong, nonatomic) TQYYAccessoryBar *accessoryBar;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) DKYYPickerView *pickerView;

@property (strong, nonatomic) NSString *purchaseTypeCode;
@property (strong, nonatomic) NSString *appointmentBranchCode;



@end

@implementation DKYYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"贷款预约";
    [UITextField appearance].backgroundColor = BackgroundColor;
    [self setUIAndConstraints];
}

- (void)setUIAndConstraints {
    UILabel * titleLabel = [[UILabel alloc] init];
    UILabel * typeLabel = [[UILabel alloc] init];
    UILabel * numberLabel = [[UILabel alloc] init];
    UILabel * reservesDateLabel = [[UILabel alloc] init];
    UILabel * reservesOutletLabel = [[UILabel alloc] init];
    UIButton * reservesButton = [[UIButton alloc] init];
    
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:typeLabel];
    [self.view addSubview:numberLabel];
    [self.view addSubview:reservesDateLabel];
    [self.view addSubview:reservesOutletLabel];
    [self.view addSubview:reservesButton];
    
    titleLabel.text = @"申请贷款";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = k_title_font;
    typeLabel.text = @"购房类型 :";
    typeLabel.font = k_text_font;
    numberLabel.text = @"购房合同号 :";
    numberLabel.font = k_text_font;
    reservesDateLabel.text = @"预约日期 :";
    reservesDateLabel.font = k_text_font;
    reservesOutletLabel.text = @"预约网点 :";
    reservesOutletLabel.font = k_text_font;
    
    [reservesButton setTitle:@"预约" forState:UIControlStateNormal];
    reservesButton.backgroundColor = BarColor;
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    typeLabel.translatesAutoresizingMaskIntoConstraints = false;
    numberLabel.translatesAutoresizingMaskIntoConstraints = false;
    reservesDateLabel.translatesAutoresizingMaskIntoConstraints = false;
    reservesOutletLabel.translatesAutoresizingMaskIntoConstraints = false;
    reservesButton.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:self.typeField];
    [self.view addSubview:self.numberField];
    [self.view addSubview:self.reservesDateField];
    [self.view addSubview:self.reservesOutletField];
    self.typeField.translatesAutoresizingMaskIntoConstraints = false;
    self.numberField.translatesAutoresizingMaskIntoConstraints = false;
    self.reservesDateField.translatesAutoresizingMaskIntoConstraints = false;
    self.reservesOutletField.translatesAutoresizingMaskIntoConstraints = false;
    
    NSMutableArray * constraints = [NSMutableArray array];
    
    NSDictionary * subView = @{
                               @"titleLabel" : titleLabel,
                               @"typeLabel" : typeLabel,
                               @"numberLabel" : numberLabel,
                               @"reservesDateLabel" : reservesDateLabel,
                               @"reservesOutletLabel" : reservesOutletLabel,
                               
                               @"typeField" : self.typeField,
                               @"numberField" : self.numberField,
                               @"reservesDateField" : self.reservesDateField,
                               @"reservesOutletField" : self.reservesOutletField,
                               
                               @"reservesButton" : reservesButton,                            };
    
    NSDictionary * metrics = @{
                               @"margin_v" : @(k_margin_vertical * 4),
                               @"margin_h" : @(k_margin_horizontal),
                               @"margin_m" : @(k_screen_height * 0.1 + k_button_size.height + k_margin_vertical * 4 + k_screen_height * 0.1),
                               @"btnH" : @(k_button_size.height * 0.7)
                               };
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:k_screen_height * 0.2]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:k_button_size.height]];
    
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin_m-[typeLabel(btnH)]-margin_v-[numberLabel(btnH)]-margin_v-[reservesDateLabel(btnH)]-margin_v-[reservesOutletLabel(btnH)]" options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:metrics views:subView]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin_m-[typeField(btnH)]-margin_v-[numberField(btnH)]-margin_v-[reservesDateField(btnH)]-margin_v-[reservesOutletField(btnH)]" options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:metrics views:subView]];
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:typeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:k_screen_width * 0.15]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:typeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:k_screen_width * 0.35]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.typeField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-k_screen_width * 0.12]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.typeField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:k_screen_width * 0.42]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:reservesButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:reservesButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:reservesOutletLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:[metrics[@"margin_v"] floatValue]]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:reservesButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:k_button_size.height]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:reservesButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:k_screen_width * 0.4]];
    
    [self.view addConstraints:constraints];
    
    
    [reservesButton addTarget:self action:@selector(reservesButtonClick) forControlEvents:UIControlEventTouchUpInside];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"开始监听购房类型和预约网点信息通知");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseTypeInfoDidLoad) name:@"purchaseTypeInfoDidLoadNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appointmentBranchInfoDidLoad) name:@"appointmentBranchInfoDidLoadNotification" object:nil];
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

- (void)purchaseTypeInfoDidLoad {
    self.purchaseType = [ConvenientTools sharedConvenientTools].purchaseType;
}
- (void)appointmentBranchInfoDidLoad {
    self.appointmentBranch = [ConvenientTools sharedConvenientTools].appointmentBranch;
}





#pragma mark - 按钮点击

- (void)reservesButtonClick {
    
    if (self.typeField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择购房类型" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (self.numberField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入合同号码" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (self.reservesDateField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择预约日期" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (self.reservesOutletField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择预约网点" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [GJJAPI loanApplicationAppointmnet_职工编号:[UserAccountInfo sharedUserAccountInfo].staffNumber 购房类型:self.purchaseTypeCode 还款方式:@"等额本金" 贷款金额:@"0" 贷款年限:@"0" 购房总价:@"0" 购房合同号:self.numberField.text 受理日期:[[NSDate date].description substringToIndex:10]  completionHandler:^(id result, NSURLResponse *response, NSError *error) {
            onceToken = 0;
            if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"]) {
                DKYYXQViewController *dkyyxqVc = [[DKYYXQViewController alloc] init];
                dkyyxqVc.appointedNumber = result[@"msg"];
                dkyyxqVc.appointedOutlet = self.reservesOutletField.text;
                dkyyxqVc.appointedDate = self.reservesDateField.text;
                [self.navigationController pushViewController:dkyyxqVc animated:true];
            }
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            onceToken = 0;
        });
    });
    

}


#pragma mark - UITextFieldDelegateMethod
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.typeField]) {
        self.pickerView.datas = self.purchaseType;
    }
    if ([textField isEqual:self.reservesOutletField]) {
        self.pickerView.datas = self.appointmentBranch;
    }
    return true;
}


#pragma mark - picker
- (TQYYAccessoryBar *)accessoryBar {
    if (_accessoryBar == nil) {
        _accessoryBar = [[TQYYAccessoryBar alloc] init];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *selectionItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStyleDone target:self action:@selector(selectionButtonClick)];
        [_accessoryBar setItems:@[spaceItem, selectionItem]];
    }
    return _accessoryBar;
}

- (void)selectionButtonClick {
    if ([self.reservesDateField isFirstResponder]) {
        if (self.datePicker.date.description.length >= 10) {
            self.reservesDateField.text = [self.datePicker.date.description substringToIndex:10];
        }
    } else if ([self.typeField isFirstResponder]) {
        if ([ConvenientTools sharedConvenientTools].purchaseType.count > 0) {
            NSDictionary *dict = [ConvenientTools sharedConvenientTools].purchaseType[self.pickerView.selectedIndexPath.row];
            self.typeField.text = dict[@"mc"];
            self.purchaseTypeCode = dict[@"bm"];
        }
    } else if ([self.reservesOutletField isFirstResponder]) {
        if ([ConvenientTools sharedConvenientTools].appointmentBranch.count > 0) {
            NSDictionary *dict = [ConvenientTools sharedConvenientTools].appointmentBranch[self.pickerView.selectedIndexPath.row];
            self.reservesOutletField.text = dict[@"mc"];
            self.appointmentBranchCode = dict[@"bm"];
        }
    }
    [self.view endEditing:true];
}

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

- (DKYYPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[DKYYPickerView alloc] init];
    }
    return _pickerView;
}

#pragma mark - 懒加载

- (UITextField *)typeField {
    if (_typeField == nil) {
        _typeField = [[UITextField alloc] init];
        _typeField.borderStyle = UITextBorderStyleRoundedRect;
        _typeField.backgroundColor = BackgroundColor;
        _typeField.delegate = self;
        _typeField.inputAccessoryView = self.accessoryBar;
        _typeField.inputView = self.pickerView;
    }
    return _typeField;
}

- (UITextField *)numberField {
    if (_numberField == nil) {
        _numberField = [[UITextField alloc] init];
        _numberField.borderStyle = UITextBorderStyleRoundedRect;
        _numberField.backgroundColor = BackgroundColor;
    }
    return _numberField;
}

- (UITextField *)reservesDateField {
    if (_reservesDateField == nil) {
        _reservesDateField = [[UITextField alloc] init];
        _reservesDateField.borderStyle = UITextBorderStyleRoundedRect;
        _reservesDateField.backgroundColor = BackgroundColor;
        _reservesDateField.delegate = self;
        _reservesDateField.inputAccessoryView = self.accessoryBar;
        _reservesDateField.inputView = self.datePicker;
    }
    return _reservesDateField;
}

- (UITextField *)reservesOutletField {
    if (_reservesOutletField == nil) {
        _reservesOutletField = [[UITextField alloc] init];
        _reservesOutletField.borderStyle = UITextBorderStyleRoundedRect;
        _reservesOutletField.backgroundColor = BackgroundColor;
        _reservesOutletField.delegate = self;
        _reservesOutletField.inputAccessoryView = self.accessoryBar;
        _reservesOutletField.inputView = self.pickerView;
    }
    return _reservesOutletField;
}

@end
