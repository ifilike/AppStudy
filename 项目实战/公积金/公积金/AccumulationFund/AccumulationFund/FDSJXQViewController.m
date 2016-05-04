//
//  FDSJXQViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/18.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "FDSJXQViewController.h"
#import "FDJSHeaderView.h"
#import "FDJSTableViewCell.h"
#import "DKYYViewController.h"
#import "GJJAPI.h"
#import "UserAccountInfo.h"
#import "FDJSHeaderInputView.h"
#import "SVProgressHUD.h"

@interface FDSJXQViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) FDJSHeaderInputView *headerView;

// 贷款利息
@property (copy, nonatomic) NSString *loanInterest;
// 贷款贷款期限
@property (copy, nonatomic) NSString *needLoanDate;
// 选择贷款金额
@property (copy, nonatomic) NSString *needLoanAmount;

@end

@implementation FDSJXQViewController

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithArray:
  @[
   [NSMutableDictionary dictionaryWithDictionary:
@{
   @"title" : @"等额本息还款",
   @"data" : [NSMutableArray arrayWithArray:@[
                                              [NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"贷款总额",
                                                                                              @"string" : @"20000000元"}],
                                              [NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"还款总额",
                                                                                              @"string" : @"31334854.97元"}],
                                              [NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"支付利息",
                                                                                              @"string" : @"11334854.97元"}],
                                              [NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"贷款月数",
                                                                                              @"string" : @"360月"}],
                                              [NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"月均还款",
                                                                                              @"string" : @"87041.26元"}],
                                              ]]
   }],
   [NSMutableDictionary dictionaryWithDictionary:
@{
   @"title" : @"等额本金还款",
   @"data" : [NSMutableArray arrayWithArray:@[
                                              [NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"贷款总额",
                                                                                              @"string" : @"20000000元"}],
                                              [NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"还款总额",
                                                                                              @"string" : @"29777083.33元"}],
                                              [NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"支付利息",
                                                                                              @"string" : @"977083.33元"}],
                                              [NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"贷款月数",
                                                                                              @"string" : @"360月"}],
                                              [NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"首月还款",
                                                                                              @"string" : @"109722.22元"}],
                                              ]]
   }],
                                                       ]];
    }
    return _dataSource;
}

- (void)keyboardHide {
    [self.view endEditing:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"房贷计算详情";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    FDJSHeaderInputView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"FDJSHeaderInputView" owner:nil options:nil] lastObject];
    self.headerView = headerView;
    [headerView.calculationButton addTarget:self action:@selector(calculationButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:headerView];
    headerView.frame = CGRectMake(0, -180, self.view.frame.size.width, 170);
    self.tableView.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
    [self.tableView addGestureRecognizer:tapGes];
    
}

- (void)calculationButtonClick {
    
    if (self.headerView.needAmoutLabel.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请输入的您需要的贷款金额" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if ([self.headerView.needAmoutLabel.text integerValue] > [self.maxLoanAmount integerValue]) {
        [SVProgressHUD showErrorWithStatus:@"请输入的贷款额度超过最大限额" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    self.needLoanAmount = self.headerView.needAmoutLabel.text;
    
    if (self.headerView.needLoanDateLabel.text.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"请输入的您需要的贷款时间" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    NSString *str = [self.maxLoanDate componentsSeparatedByString:@"年"][0];
    if ([self.headerView.needLoanDateLabel.text integerValue] > [str integerValue]) {
        [SVProgressHUD showErrorWithStatus:@"请输入的贷款期限超过最大期限" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    self.needLoanDate = self.headerView.needLoanDateLabel.text;

    [self.view endEditing:true];
    [GJJAPI fundLoanRates_贷款年限:str 消息:nil completionHandler:^(id result, NSURLResponse *response, NSError *error) {
       if ([result isKindOfClass:[NSDictionary class]] && [result[@"ret"] isEqualToString:@"0"]) {
           self.loanInterest = [result[@"data"] lastObject][@"dklv"];
           [self calculationAndRefresh];
       }
    }];
}

- (void)calculationAndRefresh {
    NSMutableArray *array1 = self.dataSource[0][@"data"];
    array1[0][@"string"] = self.needLoanAmount;
    double pur = [self.needLoanAmount doubleValue];
    double ln = [self.loanInterest doubleValue]/100;
    NSInteger lm = [self.needLoanDate integerValue] * 12;
    
    double sum = (pur * ln/12 *  pow((1 + ln/12), lm) / (pow((1 + ln/12), lm) - 1)) * lm;

    array1[1][@"string"] = [NSString stringWithFormat:@"%.2lf", sum];
    array1[2][@"string"] = [NSString stringWithFormat:@"%.2lf", sum - pur];
    array1[3][@"string"] = [NSString stringWithFormat:@"%li", lm];
    array1[4][@"string"] = [NSString stringWithFormat:@"%.2lf", sum/lm];
    
    NSMutableArray *arrayLM = [NSMutableArray arrayWithCapacity:lm];
    
    double balanceSum = 0;
    double totalSum = 0;
    double balancePerM = pur/lm;
    for (NSInteger i = 1; i <= lm; i++) {
        double month = pur/lm + (pur - balanceSum)*(ln/12);
        balanceSum = balanceSum + balancePerM;
        totalSum = totalSum + month;
        [arrayLM addObject:[NSString stringWithFormat:@"%.2lf", month]];
    }
    
    
    NSMutableArray *array2 = self.dataSource[1][@"data"];
    array2[0][@"string"] = self.needLoanAmount;
    array2[1][@"string"] = [NSString stringWithFormat:@"%.2lf", totalSum];
    array2[2][@"string"] = [NSString stringWithFormat:@"%.2lf", (lm + 1) * pur * ln/12 /2];
    array2[3][@"string"] = [NSString stringWithFormat:@"%li", lm];
    array2[4][@"string"] = arrayLM.firstObject;
    
    self.mxDataSource = arrayLM.copy;
    
    [self.tableView reloadData];
}

- (void)setMxDataSource:(NSArray *)mxDataSource {
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSInteger i = 0; i < mxDataSource.count; i++) {
        
        NSDictionary *dict = @{
                               @"no" : [NSString stringWithFormat:@"%li", i + 1],
                               @"count" : mxDataSource[i]
                               };
        [arrayM addObject:dict];
    }
    _mxDataSource = arrayM.copy;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.headerView.maxAmoutLabel.text = [self.maxLoanAmount stringByAppendingString:@"元"];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section][@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dict = self.dataSource[indexPath.section][@"data"][indexPath.row];
    FDJSTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FDJSCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FDJSTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.titleLabel.text = dict[@"title"];
    cell.dataLabel.text = dict[@"string"];
    
    cell.detailButton.hidden = true;
    if (indexPath.section == 1 && indexPath.row == 4) {
        cell.detailButton.hidden = false;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FDJSHeaderView * headerView = [[[NSBundle mainBundle] loadNibNamed:@"FDJSHeaferView" owner:nil options:nil] lastObject];
    
    headerView.titleLabel.text = self.dataSource[section][@"title"];
    [headerView.wyyyButton addTarget:self action:@selector(wyyyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 40;
}


- (void)wyyyButtonClick:(UIButton *)sender {
    [self.navigationController pushViewController:[DKYYViewController new] animated:true];
    
}



@end
