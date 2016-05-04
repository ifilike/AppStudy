//
//  NewFeatureViewController.m
//  AccumulationFund
//
//  Created by SL🐰鱼子酱 on 15/11/14.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "NewFeatureCell.h"
#import "UserAccountInfo.h"

@interface NewFeatureViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionViewFlowLayout * fl;
@property (strong, nonatomic) UICollectionView * flView;

@end

@implementation NewFeatureViewController

static NSString * const reuseIdentifier = @"NewsFeatureCell";

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[
                        @{
                            @"icon" : @"new_feature1",
                            @"title" : @"账户信息，尽在你的掌控"
                            },
                        @{
                            @"icon" : @"new_feature2",
                            @"title" : @"还款信息一目了然"
                            },
                        @{
                            @"icon" : @"new_feature3",
                            @"title" : @"带你找到最近最方便的公积金管理中心"
                            }
                        ];
    }
    return _dataSource;
}

- (UICollectionViewFlowLayout *)fl {
    if (_fl == nil) {
        _fl = [[UICollectionViewFlowLayout alloc] init];
    }
    return _fl;
}

- (UICollectionView *)flView {
    if (_flView == nil) {
        _flView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.fl];
    }
    return _flView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.flView];
    self.flView.dataSource = self;
    self.flView.delegate = self;
    
    [self.flView registerClass:[NewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.fl.minimumInteritemSpacing = 0;
    self.fl.minimumLineSpacing = 0;
    self.fl.itemSize = self.view.bounds.size;
    self.fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.flView.pagingEnabled = true;
    self.flView.showsHorizontalScrollIndicator = false;
    self.flView.bounces = false;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewFeatureCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.imageIndex = indexPath.item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *className = @"MainViewController";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootViewControllerNotification" object:nil userInfo:@{@"className" : className}];
}

@end
