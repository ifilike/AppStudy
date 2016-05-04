//
//  LoanScheduleViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/19.
//  Copyright © 2015年 huancun. All rights reserved.
//

#define kLoanCell @"loanScheduleCell"

#import "LoanScheduleViewController.h"
#import "FundReferences.h"
#import "UIColor+Hex.h"
#import "UIView+CG.h"

#import "LoanScheduleTableViewCell.h"
#import "AccountInfoCenter.h"

@interface LoanScheduleViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UIView *_headView;
}
@property (nonatomic,strong)UITableView *loanTableView;
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;
@property (strong, nonatomic) UILabel *label3;
@property (strong, nonatomic) UILabel *label4;

@end

@implementation LoanScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"贷款进度";
    
    [self.view addSubview:self.loanTableView];
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"开始监听贷款进度信息通知");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loanProgressInformationDidLoad) name:@"loanProgressInformationDidLoadNotification" object:nil];
    [self setHeaderInfos];
}

- (void)loanProgressInformationDidLoad {
    self.loanProgress = [AccountInfoCenter sharedAccountInfoCenter].loanProgress;
    [self.loanTableView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setHeaderInfos];
}


- (void)setHeaderInfos {
    
    NSMutableString *money = [NSMutableString stringWithString:self.loanProgress[@"header"][@"sqje"]];
    if (money.length >= 4) {
        [money insertString:@" " atIndex:money.length - 3];
    }
    if (money.length >=8 ) {
        [money insertString:@" " atIndex:money.length - 7];
    }
    if (money.length >= 12) {
        [money insertString:@" " atIndex:money.length - 11];
    }

    self.label1.text = [[[self.loanProgress[@"detail"] firstObject][@"blsj"] substringToIndex:10] stringByAppendingString:@" 您向中心申请公积金贷款"];
    self.label2.text = [money.copy stringByAppendingString:@" 元"];
    self.label3.text = self.loanProgress[@"header"][@"hkfs"];
    self.label4.text = [self.loanProgress[@"header"][@"hkqc"] stringByAppendingString:@" 期"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.loanProgress[@"detail"] count] == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有贷款或非贷款主借款人" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (void)createUI
{
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, k_screen_width, k_screen_width / 3 * 2 - 11)];
    _headView.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    _loanTableView.tableHeaderView = _headView;
    
    //第一行
    UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, k_screen_width, k_screen_width / 9)];
    v1.backgroundColor = [UIColor whiteColor];
//    [_headView addSubview:v1];
    
    //内容
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, v1.height / 2 - 9, k_screen_width - 40, 18)];
    label1.textColor = [UIColor darkGrayColor];
    label1.font = YFont(14);
    [v1 addSubview:label1];
    self.label1 = label1;
    
    [_headView addSubview:v1];
    //第二行
    UIView *v2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(v1.frame) + 10, k_screen_width, v1.height)];
    v2.backgroundColor = [UIColor whiteColor];
//    [_headView addSubview:v2];
    
    UILabel *label21 = [[UILabel alloc]initWithFrame:CGRectMake(20, v2.height / 2 - 9, 60, 18)];
    label21.textColor = [UIColor darkGrayColor];
    label21.font = YFont(14);
    label21.text = @"申请金额";
    
    UILabel *label22 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label21.frame) + 20, CGRectGetMinY(label21.frame) , 150, label21.height)];
    label22.textColor = BarColor;
    label22.font = YFont(14);
    self.label2 = label22;
    
    [v2 addSubview:label21];
    [v2 addSubview:label22];
    [_headView addSubview:v2];
    
    //线
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(v2.frame), k_screen_width - 20, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    [_headView addSubview:line1];
    
    //第三行
    UIView *v3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(v2.frame) + 1, k_screen_width, v1.height)];
    v3.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:v3];
    
    UILabel *label31 = [[UILabel alloc]initWithFrame:CGRectMake(20, v2.height / 2 - 9, 60, 18)];
    label31.textColor = [UIColor darkGrayColor];
    label31.font = YFont(14);
    label31.text = @"还款方式";
    
    UILabel *label32 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label31.frame) + 20, CGRectGetMinY(label31.frame) , 150, label31.height)];
    label32.textColor = [UIColor lightGrayColor];
    label32.font = YFont(14);
    self.label3 = label32;
    
    [v3 addSubview:label31];
    [v3 addSubview:label32];
    
    //线
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(v3.frame), k_screen_width - 20, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    [_headView addSubview:line2];
    
    //第四行
    UIView *v4 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(v3.frame) + 1, k_screen_width, v1.height)];
    v4.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:v4];
    
    UILabel *label41 = [[UILabel alloc]initWithFrame:CGRectMake(20, v4.height / 2 - 9, 60, 18)];
    label41.textColor = [UIColor darkGrayColor];
    label41.font = YFont(14);
    label41.text = @"还款期数";
    
    UILabel *label42 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label41.frame) + 20, CGRectGetMinY(label41.frame) , 150, label41.height)];
    label42.textColor = [UIColor lightGrayColor];
    label42.font = YFont(14);
    self.label4 = label42;

    
    [v4 addSubview:label41];
    [v4 addSubview:label42];
    
    //第五行
    UIView *v5 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(v4.frame) + 10, k_screen_width, v1.height)];
    v5.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:v5];
    
    UILabel *label51 = [[UILabel alloc]initWithFrame:CGRectMake(20, v5.height / 2 - 9, 60, 18)];
    label51.textColor = [UIColor darkGrayColor];
    label51.font = YFont(14);
    label51.text = @"进度追踪";

    [v5 addSubview:label51];

    //线
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(v5.frame), k_screen_width - 20, 1)];
    line3.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    [_headView addSubview:line3];
}

- (UITableView *)loanTableView
{
    if (_loanTableView == nil) {
        _loanTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _loanTableView.delegate = self;
        _loanTableView.dataSource = self;
        _loanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;    //取消cell分割线
        _loanTableView.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    }
    return _loanTableView;
}

#pragma mark - UiTableView 代理方法实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.loanProgress[@"detail"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[LoanScheduleTableViewCell class] forCellReuseIdentifier:kLoanCell];
    LoanScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLoanCell];
    if (!cell) {
        cell = [[LoanScheduleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLoanCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = self.loanProgress[@"detail"][indexPath.row];
    cell.contentL.text = [NSString stringWithFormat:@" %@  %@  %@", [dict[@"lcjd"] isKindOfClass:[NSNull class]] ? @"暂无审批意见" : dict[@"lcjd"], [dict[@"blsj"] substringToIndex:10], dict[@"bz"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return k_screen_width / 6;
}

@end
