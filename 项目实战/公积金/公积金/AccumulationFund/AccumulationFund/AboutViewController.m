//
//  AboutViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutTableViewCell.h"
#import "FundReferences.h"
#import "UserAccountInfo.h"
#import "AccountInfoCenter.h"
#import "LoginViewController.h"
#import "ResiveLoginKeyVC.h"

@interface AboutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray * dataSource;

@end

@implementation AboutViewController

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[
                        @{
                            @"name" : @"修改密码",
                            @"icon" : @"修改密码"
                            },
                        @{
                            @"name" : @"隐私声明",
                            @"icon" : @"隐私声明"
                            },
                        
                        @{
                            @"name" : @"当前版本",
                            @"icon" : @"当前版本"
                            },
                        
                        @{
                            @"name" : @"服务热线",
                            @"icon" : @"服务热线"
                            },
                        
                        @{
                            @"name" : @"帮助信息",
                            @"icon" : @"帮助信息"
                            },
                        
                        @{
                            @"name" : @"公积金微信",
                            @"icon" : @"公积金微信"
                            },
                        
                        @{
                            @"name" : @"公积金微博（新浪）",
                            @"icon" : @"公积金微博新浪"
                            },
                        
                        @{
                            @"name" : @"公积金微博（腾讯）",
                            @"icon" : @"公积金微博腾讯"
                            },
                        
                        @{
                            @"name" : @"退出当前账号",
                            @"icon" : @"退出当前账号"
                            }
                        ];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.profileTableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 66;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor = BackgroundColor;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AboutTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"aboutWeCell"];
    if (cell == nil) {
        cell = [[AboutTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"aboutWeCell"];
    }
    
    NSDictionary * dict = self.dataSource[indexPath.section];
    cell.icon = dict[@"icon"];
    cell.name = dict[@"name"];
    
    if (indexPath.section == self.dataSource.count - 1 && ![UserAccountInfo sharedUserAccountInfo].username.length > 0) {
        cell.name = @"登录";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        ResiveLoginKeyVC *rlVC = [[ResiveLoginKeyVC alloc] init];
        rlVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:rlVC animated:true];
    }
    
    if (indexPath.section == 3) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"呼叫服务热线" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *actionCell = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://12329"]];
        }];
        [alertController addAction:actionCancel];
        [alertController addAction:actionCell];
        [self presentViewController:alertController animated:true completion:nil];
    }
    
    if (indexPath.section == 8) {
        AboutTableViewCell *cell = [self.profileTableView cellForRowAtIndexPath:indexPath];
        if ([cell.name isEqualToString:@"登录"]) {
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
            UINavigationController * navc = [sb instantiateViewControllerWithIdentifier:@"loginNavigation"];
            LoginViewController *loginVC = navc.viewControllers.lastObject;
            loginVC.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:loginVC animated:true];
        } else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"在您退出当前账号后, 您的个人信息将被清除" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self clearDiskMemory];
                [self clearMemory];
                [self.profileTableView reloadSections:[NSIndexSet indexSetWithIndex:self.dataSource.count - 1] withRowAnimation:UITableViewRowAnimationNone];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertVC addAction:okAction];
            [alertVC addAction:cancelAction];
            [self presentViewController:alertVC animated:true completion:nil];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (void)clearDiskMemory {
    NSString *path =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dataDirectory = [path stringByAppendingPathComponent:@"datas"];
    [self fileManagerRemoveDirectoryPath:dataDirectory];
    NSString *userDirectory = [path stringByAppendingPathComponent:@"users"];
    [self fileManagerRemoveDirectoryPath:userDirectory];
}

- (void)clearMemory {
    UserAccountInfo *userInfo = [UserAccountInfo sharedUserAccountInfo];
    userInfo.username = nil;
    userInfo.cellphone = nil;
    userInfo.password = nil;
    userInfo.account = nil;
    userInfo.staffNumber = nil;
    userInfo.contractNumber = nil;
    
    AccountInfoCenter *dataInfo = [AccountInfoCenter sharedAccountInfoCenter];
    dataInfo.userAccount = nil;
    dataInfo.loanInformation = nil;
    dataInfo.repaymentInfo = nil;
    dataInfo.loanProgress = nil;
    dataInfo.depositDetail = nil;
}

- (void)fileManagerRemoveDirectoryPath:(NSString *)directoryPath {
    if([[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        BOOL success = [[NSFileManager defaultManager]  removeItemAtPath:directoryPath error:nil];
        if (!success) {
            NSLog(@"删除目录失败: %@", directoryPath);
        }
    }
}

@end
