//
//  ToolsViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "ToolsViewController.h"
#import "FundReferences.h"
#import "ToolsCollectionViewCell.h"
#import "WDYYViewController.h"
#import "DKYYViewController.h"
#import "TQYYViewController.h"
#import "FDJSViewController.h"
#import "TQHKViewController.h"
#import "WDCXViewController.h"
#import "WDYY2ViewController.h"
#import "ConvenientTools.h"
#import "UserAccountInfo.h"
#import "LoginViewController.h"

@interface ToolsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray * dataSource;
@property (strong, nonatomic) UICollectionViewFlowLayout * flowLayout;
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) UIAlertController *alertController;

@end

@implementation ToolsViewController

static NSString * const reuseIdentifier = @"toolsCell";

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[
                            @{
                                @"name" : @"网点查询",
                                @"icon" : @"网点查询"
                                },
                            @{
                                @"name" : @"提前还款",
                                @"icon" : @"提前还款"
                                },
                            @{
                                @"name" : @"房贷计算",
                                @"icon" : @"房贷计算"
                                },
                            @{
                                @"name" : @"提取预约",
                                @"icon" : @"提取预约"
                                },
                            @{
                                @"name" : @"贷款预约",
                                @"icon" : @"贷款预约"
                                },
                            @{
                                @"name" : @"我的预约",
                                @"icon" : @"我的预约"
                                }
                    ];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title = @"";

    
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.collectionView registerClass:[ToolsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.flowLayout.minimumLineSpacing = k_collection_cell_margin;
    self.flowLayout.minimumInteritemSpacing = k_collection_cell_margin;
    self.flowLayout.itemSize = CGSizeMake(k_collection_cell_side, k_collection_cell_side);
    self.flowLayout.sectionInset = UIEdgeInsetsMake((k_screen_height - k_collection_cell_side * 3 - k_collection_cell_margin * 2 - 64 - 49) * 0.5, (k_screen_width - k_collection_cell_side - k_collection_cell_margin) * 0.25, 0, (k_screen_width - k_collection_cell_side - k_collection_cell_margin) * 0.25);
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
        bgView.image = [UIImage imageNamed:@"便民工具背景"];
        _collectionView.scrollEnabled = false;
        _collectionView.backgroundView = bgView;
        _collectionView.canCancelContentTouches = false;
        _collectionView.delaysContentTouches = false;
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
        return CGSizeMake(k_collection_cell_side, k_collection_cell_side);
//    } else if (indexPath.section == 1) {
//        return CGSizeMake(k_collection_cell_side * 2 + k_collection_cell_margin, k_collection_cell_side);
//    }
//    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ToolsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary * info = self.dataSource[indexPath.item];
    
    cell.icon = info[@"name"];
    cell.title = info[@"icon"];
    
    cell.backgroundColor = [UIColor colorWithRed:41/255.0 green:174/255.0 blue:239/255.0 alpha:0.9];
    
    return cell;
}


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



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    ToolsCollectionViewCell * cell = (ToolsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    if (!([UserAccountInfo sharedUserAccountInfo].account.length > 0)) {
        [self presentViewController:self.alertController animated:true completion:nil];
        return;
    }
    
    UIViewController * vc;
    if ([cell.title isEqualToString:@"网点查询"]){
        vc = [[WDCXViewController alloc] init];
        ((WDCXViewController *)vc).mapBranches = [ConvenientTools sharedConvenientTools].mapBranchs;
    } else if ([cell.title isEqualToString:@"提前还款"]){
        vc = [[TQHKViewController alloc] init];
    } else if ([cell.title isEqualToString:@"房贷计算"]){
        vc = [[FDJSViewController alloc] init];
    } else if ([cell.title isEqualToString:@"提取预约"]){
        vc = [[TQYYViewController alloc] init];
        ((TQYYViewController *)vc).drawReason = [ConvenientTools sharedConvenientTools].drawReason;
    } else if ([cell.title isEqualToString:@"贷款预约"]){
        vc = [[DKYYViewController alloc] init];
        DKYYViewController *tempVC = (DKYYViewController *)vc;
        tempVC.purchaseType = [ConvenientTools sharedConvenientTools].purchaseType;
        tempVC.appointmentBranch = [ConvenientTools sharedConvenientTools].appointmentBranch;
    } else if ([cell.title isEqualToString:@"我的预约"]){
        vc = [[WDYY2ViewController alloc] init];
        ((WDYY2ViewController *)vc).appointedInfo = [ConvenientTools sharedConvenientTools].appointedInfo;
        
    }
    
    vc.hidesBottomBarWhenPushed = true;
    if (vc != nil) {
        [self.navigationController pushViewController:vc animated:true];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    ToolsCollectionViewCell * cell = (ToolsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:41/255.0 green:174/255.0 blue:239/255.0 alpha:0.9];
}


@end
