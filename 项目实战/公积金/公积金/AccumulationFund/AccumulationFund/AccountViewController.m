//
//  AccountViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "AccountViewController.h"
#import "FundReferences.h"
#import "UIColor+Hex.h"
#import "UIView+CG.h"

#import "AccountQueryViewController.h"
#import "LoanQueryViewController.h"
#import "RefundQueryViewController.h"
#import "LoanScheduleViewController.h"
#import "DepositeDetailViewController.h"
#import "AccountInfoCenter.h"
#import "UserAccountInfo.h"
#import "LoginViewController.h"

@interface AccountViewController ()<UIGestureRecognizerDelegate>
{
    UIView *_accountQueryView;       //账户查询
    UIView *_loanQueryView;          //贷款查询
    UIView *_refundQueryView;        //还款查询
    UIView *_loanScheduleView;       //贷款进度
    UIView *_depositeDetailView;     //缴存明细
}

@property (strong, nonatomic) UIAlertController *alertController;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    [self createUI];
}

- (void)createUI
{
//账户查询
    _accountQueryView = [[UIView alloc]initWithFrame:CGRectMake(k_screen_width / 35, k_screen_width / 36 + 64, k_screen_width / 35 * 33 , k_screen_width / 3 * 2)];
    _accountQueryView.backgroundColor = [UIColor whiteColor];
    _accountQueryView.layer.cornerRadius = 4;
    [self.view addSubview:_accountQueryView];
    
    //添加tap 点击事件 (账户查询)
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(accountQuery:)];
    tap1.delegate = self;
    [_accountQueryView addGestureRecognizer:tap1];
    
    //添加图片
    UIImageView *accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(k_screen_width / 2 - k_screen_width / 8,  k_screen_width / 12 , k_screen_width / 4, k_screen_width / 4)];
    accountImageView.image = [UIImage imageNamed:@"账户查询"];
    
    //按钮标题
    UILabel *accountTitleL = [[UILabel alloc]initWithFrame:CGRectMake(k_screen_width / 2 - k_screen_width / 8, CGRectGetMaxY(accountImageView.frame) + 10, k_screen_width / 4, k_screen_width / 13)];
    accountTitleL.text = @"账户查询";
    accountTitleL.textAlignment = NSTextAlignmentCenter;
    accountTitleL.font = YFont(16);
    accountTitleL.textColor = [UIColor blackColor];
    
    //提示信息
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(k_screen_width / 2  - 70, CGRectGetMaxY(accountTitleL.frame) + 15, 150, 20)];
    label1.textColor = [UIColor colorWithHexString:@"333333" alpha:0.7];
    label1.font = YFont(12);
    label1.text = @"查询个人公积金账户信息";
    
    //小图标
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(label1.frame) - 18, CGRectGetMinY(label1.frame), 15, 15)];
    imageView1.image = [UIImage imageNamed:@"accounticon"];
    [_accountQueryView addSubview:accountImageView];
    [_accountQueryView addSubview:accountTitleL];
    [_accountQueryView addSubview:label1];
    [_accountQueryView addSubview:imageView1];
    
//贷款查询
    _loanQueryView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_accountQueryView.frame ) + k_screen_width / 36, k_screen_width / 2, (k_screen_height - 49 - CGRectGetMaxY(_accountQueryView.frame) - k_screen_width / 36 * 2 ) / 2 )];
    _loanQueryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_loanQueryView];
    
    //添加tap 点击事件 (贷款查询)
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loanQuery:)];
    tap2.delegate = self;
    [_loanQueryView addGestureRecognizer:tap2];
    
    //添加图片
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(_loanQueryView.width / 2 - _loanQueryView.width / 8, _loanQueryView.height / 6, _loanQueryView.width / 4, _loanQueryView.width / 4)];
    imageView2.image = [UIImage imageNamed:@"贷款查询"];
    
    //添加按钮标题文字
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(_loanQueryView.width / 2 - _loanQueryView.width / 4, CGRectGetMaxY(imageView2.frame ) + 15, _loanQueryView.width / 2, 20)];
    label2.text = @"贷款查询";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor blackColor];
    label2.font = YFont(15);
    
    [_loanQueryView addSubview:imageView2];
    [_loanQueryView addSubview:label2];
    
//还款查询
    _refundQueryView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_loanQueryView.frame), CGRectGetMinY(_loanQueryView.frame), _loanQueryView.width, _loanQueryView.height)];
    _refundQueryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_refundQueryView];
    
    //添加tap 点击事件 (还款查询)
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(refundQuery:)];
    tap3.delegate = self;
    [_refundQueryView addGestureRecognizer:tap3];
    
    //添加图片
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(_refundQueryView.width / 2 - _refundQueryView.width / 8, _refundQueryView.height / 6, _refundQueryView.width / 4, _refundQueryView.width / 4)];
    imageView3.image = [UIImage imageNamed:@"还款查询"];
    
    //添加按钮标题文字
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(_refundQueryView.width / 2 - _refundQueryView.width / 4, CGRectGetMaxY(imageView3.frame ) + 15, _refundQueryView.width / 2, 20)];
    label3.text = @"还款查询";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.textColor = [UIColor blackColor];
    label3.font = YFont(15);
    
    [_refundQueryView addSubview:imageView3];
    [_refundQueryView addSubview:label3];
    
//贷款进度
    _loanScheduleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_loanQueryView.frame), _loanQueryView.width, _loanQueryView.height)];
    _loanScheduleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_loanScheduleView];
    
    //添加tap 点击事件 (贷款进度)
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loanSchedule:)];
    tap4.delegate = self;
    [_loanScheduleView addGestureRecognizer:tap4];
    
    //添加图片
    UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(_loanScheduleView.width / 2 - _loanScheduleView.width / 8, _loanScheduleView.height / 6, _loanScheduleView.width / 4, _loanScheduleView.width / 4)];
    imageView4.image = [UIImage imageNamed:@"贷款进度"];
    
    //添加按钮标题文字
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(_loanScheduleView.width / 2 - _loanScheduleView.width / 4, CGRectGetMaxY(imageView4.frame ) + 15, _loanScheduleView.width / 2, 20)];
    label4.text = @"贷款进度";
    label4.textAlignment = NSTextAlignmentCenter;
    label4.textColor = [UIColor blackColor];
    label4.font = YFont(15);
    
    [_loanScheduleView addSubview:imageView4];
    [_loanScheduleView addSubview:label4];
    
//缴存明细
    _depositeDetailView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_refundQueryView.frame), CGRectGetMaxY(_refundQueryView.frame), _refundQueryView.width, _refundQueryView.height)];
    _depositeDetailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_depositeDetailView];
    
    //添加tap 点击事件 (缴存明细)
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(depositeDetail:)];
    tap5.delegate = self;
    [_depositeDetailView addGestureRecognizer:tap5];
    
    //添加图片
    UIImageView *imageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(_depositeDetailView.width / 2 - _depositeDetailView.width / 8, _depositeDetailView.height / 6, _depositeDetailView.width / 4, _depositeDetailView.width / 4)];
    imageView5.image = [UIImage imageNamed:@"缴存明细"];
    
    //添加按钮标题文字
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(_depositeDetailView.width / 2 - _depositeDetailView.width / 4, CGRectGetMaxY(imageView5.frame ) + 15, _depositeDetailView.width / 2, 20)];
    label5.text = @"缴存明细";
    label5.textAlignment = NSTextAlignmentCenter;
    label5.textColor = [UIColor blackColor];
    label5.font = YFont(15);
    
    [_depositeDetailView addSubview:imageView5];
    [_depositeDetailView addSubview:label5];
    
    //添加中间的两根线条
    //横线
    UIView *hLine = [[UIView alloc]initWithFrame:CGRectMake(k_screen_width / 35, CGRectGetMaxY(_loanQueryView.frame) - 1, k_screen_width / 35 * 33, 2)];
    hLine.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    [self.view addSubview:hLine];
    
    //竖线
    UIView *vLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_loanQueryView.frame) - 1, CGRectGetMinY(_loanQueryView.frame) + k_screen_width / 36, 2, _loanQueryView.height * 2 - k_screen_width / 18)];
    vLine.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    [self.view addSubview:vLine];
}

#pragma marl - tap点击事件
- (UIAlertController *)alertController {
    if (_alertController == nil) {
        _alertController = [UIAlertController alertControllerWithTitle:@"您的账户未登录" message:@"请登录后再执行此操作" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [_alertController addAction:action1];

        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
            UINavigationController * navc = [sb instantiateInitialViewController];
            LoginViewController *loginVC = navc.viewControllers.lastObject;
            loginVC.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:loginVC animated:true];
            
        }];
        [_alertController addAction:action2];
    }
    return _alertController;
}


- (void)navigationControllerWillPushViewController:(UIViewController *)vc animated:(BOOL)animated {
    if ([UserAccountInfo sharedUserAccountInfo].account.length > 0) {
        [self.navigationController pushViewController:vc animated:animated];
        return;
    }
    [self presentViewController:self.alertController animated:true completion:nil];
}


- (void)accountQuery:(UITapGestureRecognizer *)tap
{
    NSLog(@"账户查询");
    AccountQueryViewController *accountQueryVC = [[AccountQueryViewController alloc]init];
    accountQueryVC.hidesBottomBarWhenPushed = true;
    accountQueryVC.userAccountDict = [AccountInfoCenter sharedAccountInfoCenter].userAccount;
    [self navigationControllerWillPushViewController:accountQueryVC animated:true];
}

- (void)loanQuery:(UITapGestureRecognizer *)tap
{
    NSLog(@"贷款查询");
    LoanQueryViewController *loanQueryVC = [[LoanQueryViewController alloc]init];
    loanQueryVC.hidesBottomBarWhenPushed = true;
    loanQueryVC.loanInfo = [AccountInfoCenter sharedAccountInfoCenter].loanInformation;
    [self navigationControllerWillPushViewController:loanQueryVC animated:true];
    
}

- (void)refundQuery:(UITapGestureRecognizer *)tap
{
    NSLog(@"还款进度");
    RefundQueryViewController *refundQueryVC = [[RefundQueryViewController alloc]init];
    refundQueryVC.hidesBottomBarWhenPushed = true;
    refundQueryVC.repayment = [AccountInfoCenter sharedAccountInfoCenter].repaymentInfo;
    [self navigationControllerWillPushViewController:refundQueryVC animated:true];
    
}

- (void)loanSchedule:(UITapGestureRecognizer *)tap
{
    NSLog(@"贷款进度");
    LoanScheduleViewController *loanScheduleVC = [[LoanScheduleViewController alloc]init];
    loanScheduleVC.hidesBottomBarWhenPushed = true;
    loanScheduleVC.loanProgress = [AccountInfoCenter sharedAccountInfoCenter].loanProgress;
    [self navigationControllerWillPushViewController:loanScheduleVC animated:true];
}

- (void)depositeDetail:(UITapGestureRecognizer *)tap
{
    NSLog(@"缴存明细");
    DepositeDetailViewController *depositeDetailVC = [[DepositeDetailViewController alloc]init];
    depositeDetailVC.hidesBottomBarWhenPushed = true;
    depositeDetailVC.depositDetail = [AccountInfoCenter sharedAccountInfoCenter].depositDetail;
    [self navigationControllerWillPushViewController:depositeDetailVC animated:true];
}



@end
