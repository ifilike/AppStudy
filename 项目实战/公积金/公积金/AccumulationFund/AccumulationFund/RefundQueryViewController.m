//
//  RefundQueryViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/19.
//  Copyright © 2015年 huancun. All rights reserved.
//

#define krefundCell @"refundIdentifier"

#import "RefundQueryViewController.h"
#import "FundReferences.h"
#import "UIColor+Hex.h"
#import "UIView+CG.h"

#import "RefundQueryTableViewCell.h"
#import "AccountInfoCenter.h"

@interface RefundQueryViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UIView *_tableHeadView;
}
@property (nonatomic,strong)UITableView *refundTableView;
@property (strong, nonatomic) UILabel *borrowerLabel;
@property (strong, nonatomic) UILabel *loanStateLabel;
@property (strong, nonatomic) UILabel *balanceLabel;

@end

@implementation RefundQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ececec" alpha:0.8];
    self.navigationItem.title = @"还款查询";
    [self.view addSubview:self.refundTableView];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"开始监听还款查询信息通知");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loanRepaymentInformationDidLoad) name:@"loanRepaymentInformationDidLoadNotification" object:nil];
    [self setHeaderInfos];
}

- (void)setHeaderInfos {
    self.borrowerLabel.text = self.repayment[@"header"][@"借款人"];
    self.loanStateLabel.text = self.repayment[@"header"][@"贷款状态"];
    self.balanceLabel.text = self.repayment[@"header"][@"本金余额"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.repayment[@"detail"] count] == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"未找到您的还款记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:true completion:nil];
    }
}



- (void)loanRepaymentInformationDidLoad {
    self.repayment = [AccountInfoCenter sharedAccountInfoCenter].repaymentInfo;
    [self setHeaderInfos];
    [self.refundTableView reloadData];
}

- (void)createUI
{
    _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, k_screen_width , 95 + 10)];
    _tableHeadView.backgroundColor = [UIColor colorWithHexString:@"ececec" alpha:0.8];
    _refundTableView.tableHeaderView = _tableHeadView;
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, k_screen_width - 20, 95 )];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 3;
    [_tableHeadView addSubview:backView];
    
    //借款人
    UILabel *label11 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, backView.width / 2 - 10, 20)];
    label11.text = @"借款人 :";
    label11.font = YFont(17);
    label11.textColor = [UIColor darkGrayColor];
    [backView addSubview:label11];
    
    UILabel *label12 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label11.frame), CGRectGetMinY(label11.frame), backView.width / 2 - 10, label11.height)];
    self.borrowerLabel = label12;
    label12.font = YFont(16);
    label12.textColor = [UIColor grayColor];
    label12.textAlignment = NSTextAlignmentRight;
    [backView addSubview:label12];
    
    //贷款状态
    UILabel *label21 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(label11.frame), CGRectGetMaxY(label11.frame) + 8 , label11.width, label11.height)];
    label21.text = @"借款状态 : ";
    label21.font = YFont(17);
    label21.textColor = [UIColor darkGrayColor];
    [backView addSubview:label21];
    
    UILabel *label22 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label21.frame), CGRectGetMinY(label21.frame), label11.width, label11.height)];
    self.loanStateLabel = label22;
    label22.font = YFont(16);
    label22.textColor = [UIColor grayColor];
    label22.textAlignment = NSTextAlignmentRight;
    [backView addSubview:label22];
    
    //借款人
    UILabel *label31 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(label11.frame), CGRectGetMaxY(label21.frame) + 8 , label11.width, label11.height)];
    label31.text = @"本金余额 : ";
    label31.font = YFont(17);
    label31.textColor = [UIColor darkGrayColor];
    [backView addSubview:label31];
    
    UILabel *label32 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label31.frame), CGRectGetMinY(label31.frame), label11.width, label11.height)];
    self.balanceLabel = label32;
    label32.font = YFont(16);
    label32.textColor = [UIColor grayColor];
    label32.textAlignment = NSTextAlignmentRight;
    [backView addSubview:label32];
}

- (UITableView *)refundTableView
{
    if (_refundTableView == nil) {
        _refundTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _refundTableView.delegate = self;
        _refundTableView.dataSource = self;
        _refundTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _refundTableView.backgroundColor = [UIColor colorWithHexString:@"ececec"];
        _refundTableView.showsVerticalScrollIndicator = NO;
    }
    return _refundTableView;
}

#pragma mark - UITableView代理方法实现

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.repayment[@"detail"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView registerClass:[RefundQueryTableViewCell class] forCellReuseIdentifier:krefundCell];
    RefundQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:krefundCell];
    if (!cell) {
        cell = [[RefundQueryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:krefundCell];
        }
    cell.dict = self.repayment[@"detail"][indexPath.row];
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

@end
