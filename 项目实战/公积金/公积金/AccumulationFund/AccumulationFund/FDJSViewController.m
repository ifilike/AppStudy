//
//  FDJSViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/17.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "FDJSViewController.h"
#import "FundReferences.h"
#import "SelectionView+Touch.h"
#import "SelectionViewDelegate.h"
#import "FDSJXQViewController.h"
#import "MyLabel.h"
#import "GJJAPI.h"
#import "UserAccountInfo.h"
#import "TQYYAccessoryBar.h"
#import "UIViewController+KeyboardShowOrHide.h"
#import "SVProgressHUD.h"

@interface FDJSViewController () <SelectionViewDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIScrollView * scrollView;

@property (strong, nonatomic) SelectionView * F6SelectedView;
@property (strong, nonatomic) SelectionView * F8SelectedView;

@property (strong, nonatomic) NSDictionary *mortgageCalculation;

@property (strong, nonatomic) UITextField *tf1;
@property (strong, nonatomic) UITextField *tf2;

@property (strong, nonatomic) UITextField *tf5;
@property (strong, nonatomic) UITextField *tf7;

@property (strong, nonatomic) TQYYAccessoryBar *accessoryBar;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) NSArray *pickerData;

@end

@implementation FDJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"房贷计算";
    
    [self.view addSubview:self.scrollView];
    
    [self setUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat height;
    for (UIView * view in self.scrollView.subviews) {
        height += view.frame.size.height + k_margin_vertical;
    }    
    self.scrollView.contentSize = CGSizeMake(k_screen_width, height + 1);
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [GJJAPI mortgageCalculationBasicInformation_职工编号:[UserAccountInfo sharedUserAccountInfo].staffNumber 消息:nil completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"]) {
            self.tf1.text = [result[@"data"] lastObject][@"dkye"];
            self.tf2.text = [result[@"data"] lastObject][@"jcje"];
            
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您没有贷款或非贷款主借款人" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:true];
            }];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:true completion:nil];
        }
    }];
}

- (void)setUI {
    UIView * v1 = [[UIView alloc] init];
    v1.frame = CGRectMake(0, 0, k_screen_width, 120);
    v1.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:v1];
    
    UIView * v2 = [[UIView alloc] init];
    v2.frame = CGRectMake(0, v1.bounds.size.height + k_margin_horizontal, v1.bounds.size.width, v1.bounds.size.height);
    v2.backgroundColor = v1.backgroundColor;
    [self.scrollView addSubview:v2];
    
    UIView * v3 = [[UIView alloc] init];
    v3.frame = CGRectMake(0, v2.bounds.size.height + v2.frame.origin.y + k_margin_horizontal, v1.bounds.size.width, v1.bounds.size.height);
    v3.backgroundColor = v1.backgroundColor;
    [self.scrollView addSubview:v3];
    
    UIView * v4 = [[UIView alloc] init];
    v4.frame = CGRectMake(0, v3.bounds.size.height + v3.frame.origin.y + k_margin_horizontal, v1.bounds.size.width, 200);
    v4.backgroundColor = v1.backgroundColor;
    [self.scrollView addSubview:v4];
    
    
    MyLabel * l1 = [[MyLabel alloc] init];
    l1.text = @"公积金月缴存额 :";
    l1.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:l1];

    UITextField * f1 = [[UITextField alloc] init];
    f1.backgroundColor = BackgroundColor;
    [v1 addSubview:f1];
    self.tf1 = f1;
    f1.borderStyle = UITextBorderStyleRoundedRect;
    
    MyLabel * l2 = [[MyLabel alloc] init];
    l2.text = @"缴存比例 :";
    l2.textAlignment = NSTextAlignmentRight;
    [v1 addSubview:l2];
    
    UITextField * f2 = [[UITextField alloc] init];
    f2.backgroundColor = BackgroundColor;
    [v1 addSubview:f2];
    self.tf2 = f2;
    f2.borderStyle = UITextBorderStyleRoundedRect;
    
    MyLabel * l3 = [[MyLabel alloc] init];
    l3.text = @"配偶公积金月缴存额 :";
    l3.textAlignment = NSTextAlignmentRight;
    [v2 addSubview:l3];
    
    UITextField * f3 = [[UITextField alloc] init];
    f3.backgroundColor = BackgroundColor;
    [v2 addSubview:f3];
    f3.borderStyle = UITextBorderStyleRoundedRect;
    
    MyLabel * l4 = [[MyLabel alloc] init];
    l4.text = @"缴存比例 :";
    l4.textAlignment = NSTextAlignmentRight;
    [v2 addSubview:l4];
    
    UITextField * f4 = [[UITextField alloc] init];
    f4.backgroundColor = [UIColor whiteColor];
    [v2 addSubview:f4];
    f4.borderStyle = UITextBorderStyleRoundedRect;
    
    MyLabel * l5 = [[MyLabel alloc] init];
    l5.text = @"房屋评估价值或实际购房款 :";
    l5.textAlignment = NSTextAlignmentRight;
    [v3 addSubview:l5];
    
    UITextField * f5 = [[UITextField alloc] init];
    f5.backgroundColor = BackgroundColor;
    [v3 addSubview:f5];
    self.tf5 = f5;
    f5.borderStyle = UITextBorderStyleRoundedRect;
    f5.keyboardType = UIKeyboardTypeNumberPad;
    
    MyLabel * l6 = [[MyLabel alloc] init];
    l6.text = @"房屋性质 :";
    l6.textAlignment = NSTextAlignmentRight;
    [v3 addSubview:l6];
    
    SelectionView * s61 = [[SelectionView alloc] init];
    s61.textLabel.text = @"政策性住宅";
    s61.textLabel.textAlignment = NSTextAlignmentLeft;
    s61.textLabel.font = [UIFont systemFontOfSize:12];
    [v3 addSubview:s61];
    s61.tag = 1000061;
    s61.delegate = self;
    
    SelectionView * s62 = [[SelectionView alloc] init];
    s62.textLabel.text = @"其他";
    s62.textLabel.textAlignment = NSTextAlignmentLeft;
    s62.textLabel.font = [UIFont systemFontOfSize:12];
    s62.selected = true;
    self.F6SelectedView = s62;
    [v3 addSubview:s62];
    s62.tag = 1000062;
    s62.delegate = self;
    
    MyLabel * l7 = [[MyLabel alloc] init];
    l7.text = @"贷款申请年限 :";
    l7.textAlignment = NSTextAlignmentRight;
    [v4 addSubview:l7];
    l7.hidden = true;
    
    UITextField * f7 = [[UITextField alloc] init];
    f7.backgroundColor = BackgroundColor;
    [v4 addSubview:f7];
    f7.borderStyle = UITextBorderStyleRoundedRect;
    f7.inputView = self.pickerView;
    f7.inputAccessoryView = self.accessoryBar;
    self.tf7 = f7;
    f7.hidden = true;
    
    MyLabel * l8 = [[MyLabel alloc] init];
    l8.text = @"个人信用等级 :";
    l8.textAlignment = NSTextAlignmentRight;
    [v4 addSubview:l8];
    l8.hidden = true;
    
    SelectionView * s81 = [[SelectionView alloc] init];
    s81.textLabel.text = @"AAA";
    s81.textLabel.textAlignment = NSTextAlignmentLeft;
    s81.textLabel.font = [UIFont systemFontOfSize:12];
    [v4 addSubview:s81];
    s81.tag = 1000081;
    s81.delegate = self;
    s81.hidden = true;
    
    SelectionView * s82 = [[SelectionView alloc] init];
    s82.textLabel.text = @"AA";
    s82.textLabel.textAlignment = NSTextAlignmentLeft;
    s82.textLabel.font = [UIFont systemFontOfSize:12];
    [v4 addSubview:s82];
    s82.tag = 1000082;
    s82.delegate = self;
    s82.hidden = true;
    
    SelectionView * s83 = [[SelectionView alloc] init];
    s83.textLabel.text = @"其他";
    s83.textLabel.textAlignment = NSTextAlignmentLeft;
    s83.textLabel.font = [UIFont systemFontOfSize:12];
    s83.selected = true;
    self.F8SelectedView = s83;
    [v4 addSubview:s83];
    s83.tag = 1000083;
    s83.delegate = self;
    s83.hidden = true;

    
    
    l1.frame = CGRectMake(0, v1.bounds.size.height * 0.285714 * 0.5, k_screen_width * 0.45, v1.bounds.size.height * 0.285714);
    f1.frame = CGRectMake(k_screen_width * 0.6 - k_margin_horizontal, v1.bounds.size.height * 0.285714 * 0.5, k_screen_width * 0.4, v1.bounds.size.height * 0.285714);

    l2.frame = CGRectMake(0, v1.bounds.size.height * 0.285714 * 2, k_screen_width * 0.45, v1.bounds.size.height * 0.285714);
    f2.frame = CGRectMake(k_screen_width * 0.6 - k_margin_horizontal, v1.bounds.size.height * 0.285714 * 2, k_screen_width * 0.4, v1.bounds.size.height * 0.285714);
    
    l3.frame = CGRectMake(0, v2.bounds.size.height * 0.285714 * 0.5, k_screen_width * 0.45, v2.bounds.size.height * 0.285714);
    f3.frame = CGRectMake(k_screen_width * 0.6 - k_margin_horizontal, v2.bounds.size.height * 0.285714 * 0.5, k_screen_width * 0.4, v2.bounds.size.height * 0.285714);
    
    l4.frame = CGRectMake(0, v2.bounds.size.height * 0.285714 * 2, k_screen_width * 0.45, v2.bounds.size.height * 0.285714);
    f4.frame = CGRectMake(k_screen_width * 0.6 - k_margin_horizontal, v2.bounds.size.height * 0.285714 * 2, k_screen_width * 0.4, v2.bounds.size.height * 0.285714);
    
    l5.frame = CGRectMake(0, v2.bounds.size.height * 0.285714 * 0.5, k_screen_width * 0.57, v2.bounds.size.height * 0.285714);

    f5.frame = CGRectMake(k_screen_width * 0.65 - k_margin_horizontal, v2.bounds.size.height * 0.285714 * 0.5, k_screen_width * 0.35, v2.bounds.size.height * 0.285714);
    
    l6.frame = CGRectMake(0, v2.bounds.size.height * 0.285714 * 2, k_screen_width * 0.45, v2.bounds.size.height * 0.285714);
    
    s61.frame = CGRectMake(k_screen_width * 0.55 - 2 * k_margin_horizontal, v2.bounds.size.height * 0.285714 * 2, k_screen_width * 0.25, v2.bounds.size.height * 0.285714);
    s62.frame = CGRectMake(k_screen_width * 0.8 - k_margin_horizontal, v2.bounds.size.height * 0.285714 * 2, k_screen_width * 0.2, v2.bounds.size.height * 0.285714);
    
    l7.frame = CGRectMake(0, v2.bounds.size.height * 1/8, k_screen_width * 0.45, v2.bounds.size.height * 0.285714);
    f7.frame = CGRectMake(k_screen_width * 0.6 - k_margin_horizontal, v2.bounds.size.height * 1/8, k_screen_width * 0.4, v2.bounds.size.height * 0.285714);

    l8.frame = CGRectMake(0, v2.bounds.size.height * 4/8, k_screen_width * 0.45, v2.bounds.size.height * 0.285714);
    
    s81.frame = CGRectMake(k_screen_width * 0.55 - 2 * k_margin_horizontal, v2.bounds.size.height * 4/8, k_screen_width * 0.15, v2.bounds.size.height * 0.285714);
    s82.frame = CGRectMake(k_screen_width * 0.68 - k_margin_horizontal, v2.bounds.size.height * 4/8, k_screen_width * 0.15, v2.bounds.size.height * 0.285714);
    s83.frame = CGRectMake(k_screen_width * 0.84 - k_margin_horizontal, v2.bounds.size.height * 4/8, k_screen_width * 0.15, v2.bounds.size.height * 0.285714);
    
    
    UIButton * btn = [[UIButton alloc] init];
    [btn setTitle:@"开始计算" forState:UIControlStateNormal];
    [v4 addSubview:btn];
    btn.backgroundColor = BarColor;
    [btn addTarget:self action:@selector(btnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(k_screen_width * 2.5/8, v2.bounds.size.height * 7.5/8, k_screen_width * 3/8, 1.25 * 0.285714 * v2.bounds.size.height);
    
    UIButton * clearBtn = [[UIButton alloc] init];
    [clearBtn setTitle:@"清空重填" forState:UIControlStateNormal];
    [v4 addSubview:clearBtn];
    clearBtn.frame = CGRectMake(btn.frame.origin.x + btn.frame.size.width + k_margin_horizontal, btn.frame.origin.y + 0.333333 * btn.frame.size.height, k_screen_width * 1.5/8, 1.25 * 0.285714 * 0.33333 * v2.bounds.size.height);
    [clearBtn setTitleColor:BarColor forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [clearBtn addTarget:self action:@selector(clearInput) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clearInput {
    for (UIView *view in self.scrollView.subviews) {
        for (UITextField *tf in view.subviews) {
            if ([tf isKindOfClass:[UITextField class]]) {
                tf.text = @"";
            }
        }
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _scrollView.backgroundColor = BackgroundColor;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.delegate = self;
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
        [_scrollView addGestureRecognizer:tapGes];
    }
    return _scrollView;
}

- (void)keyboardHide {
    [self.view endEditing:true];
}


- (void)selection:(SelectionView *)selectionView didChangeSelected:(BOOL)selected {
    
    if (selectionView.tag > 1000080) {
        if (self.F8SelectedView.tag == selectionView.tag && !selected) {
            self.F8SelectedView.selected = true;
        } else if (self.F8SelectedView.tag != selectionView.tag && selected) {
            SelectionView * hhh = self.F8SelectedView;
            self.F8SelectedView = selectionView;
            hhh.selected = false;
        }
    } else {
        if (self.F6SelectedView.tag == selectionView.tag && !selected) {
            self.F6SelectedView.selected = true;
        } else if (self.F6SelectedView.tag != selectionView.tag && selected) {
            SelectionView * hhh = self.F6SelectedView;
            self.F6SelectedView = selectionView;
            hhh.selected = false;
        }
    }
    
}


- (void)btnButtonClick {
    
    if (self.tf5.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请输入房屋评估价值" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }



    
    [GJJAPI loanAmountCalculation_职工编号:[UserAccountInfo sharedUserAccountInfo].staffNumber 购房类型:@"01" 购房面积:@"0" 购房总价:self.tf5.text completionHandler:^(id result, NSURLResponse *response, NSError *error) {
        NSLog(@"%@", result);
        if ([result isKindOfClass:[NSDictionary class]] && ![result[@"ret"] isKindOfClass:[NSNull class]] && [result[@"ret"] isEqualToString:@"0"] && [[result[@"data"] lastObject][@"v_min_dkqx"] isEqualToString:@"0"]) {
            
            FDSJXQViewController *tmp = [FDSJXQViewController new];
            tmp.maxLoanAmount = [result[@"data"] lastObject][@"zgdkje"];
            tmp.maxLoanDate = [result[@"data"] lastObject][@"zcdkqx"];
            [self.navigationController pushViewController:tmp animated:true];
        }
    }];
    
    


}




- (TQYYAccessoryBar *)accessoryBar {
    if (_accessoryBar == nil) {
        _accessoryBar = [[TQYYAccessoryBar alloc] init];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *selectionItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(selectionButtonClickFix)];
        [_accessoryBar setItems:@[spaceItem, selectionItem]];
    }
    return _accessoryBar;
}


- (void)selectionButtonClickFix {
    self.tf7.text = self.pickerData[self.selectedIndexPath.row];
    [self.view endEditing:true];
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:component];
}

- (NSArray *)pickerData {
    if (_pickerData == nil) {
        _pickerData = @[
                         @"1年(12期)",
                         @"2年(24期)",
                         @"3年(36期)",
                         @"4年(48期)",
                         @"5年(60期)",
                         @"6年(72期)",
                         @"7年(84期)",
                         @"8年(96期)",
                         @"9年(108期)",
                         @"10年(120期)",
                         @"11年(132期)",
                         @"12年(144期)",
                         @"13年(156期)",
                         @"14年(168期)",
                         @"15年(180期)",
                         @"16年(192期)",
                         @"17年(204期)",
                         @"18年(216期)",
                         @"19年(228期)",
                         @"20年(240期)",
                         @"21年(252期)",
                         @"22年(264期)",
                         @"23年(276期)",
                         @"24年(288期)",
                         @"25年(300期)",
                         @"26年(312期)",
                         @"27年(324期)",
                         @"28年(336期)",
                         @"29年(348期)",
                         @"30年(360期)",
                         @"31年(372期)",
                         @"32年(384期)",
                         @"33年(396期)",
                         @"34年(408期)",
                         @"35年(420期)",
                         @"36年(432期)",
                         @"37年(444期)",
                         @"38年(456期)",
                         @"39年(468期)",
                         @"40年(480期)",
                         @"41年(492期)",
                         @"42年(504期)",
                         @"43年(516期)",
                         @"44年(528期)",
                         @"45年(540期)",
                         @"46年(552期)",
                         @"47年(564期)",
                         @"48年(576期)",
                         @"49年(588期)",
                         @"50年(600期)",
                        ];
    }
    return _pickerData;
}

@end
