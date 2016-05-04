//
//  TQHKXQCollectionViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/18.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "TQHKXQCollectionViewController.h"
#import "TQHKXQCollectionViewCell.h"
#import "FundReferences.h"

@interface TQHKXQCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionViewFlowLayout * flowLayout;
@property (strong, nonatomic) UICollectionView * collectionView;

@property (strong, nonatomic) NSArray * dataSource;

@end

@implementation TQHKXQCollectionViewController

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[
                            @{
                                @"title" : @"原月还款额",
                                @"detail" : @"2185.42元"
                                },
                            @{
                                @"title" : @"原最后还款期",
                                @"detail" : @"2015年8月"
                                },
                            @{
                                @"title" : @"已还利息额",
                                @"detail" : @"10907.37元"
                                },
                            @{
                                @"title" : @"已还款总额",
                                @"detail" : @"26225.05元"
                                },
                            @{
                                @"title" : @"该月一次还款额",
                                @"detail" : @"102185.42元"
                                },
                            @{
                                @"title" : @"下月起月还款额",
                                @"detail" : @"2146.18元"
                                },
                            @{
                                @"title" : @"节省利息支出",
                                @"detail" : @"41554.46"
                                },
                            @{
                                @"title" : @"新的最后还款期",
                                @"detail" : @"2020年4月"
                                }
                        ];
    }
    return _dataSource;
}

static NSString * const reuseIdentifier = @"tqhkxqCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提前还款详情";
    [self.view addSubview:self.collectionView];

    UINib * nib = [UINib nibWithNibName:@"TQHKXQCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake((k_screen_width - 4 * k_margin_vertical) * 0.5 - 2, (k_screen_height - 4 * k_margin_vertical) * 0.20);
        _flowLayout.minimumInteritemSpacing = 2;
        _flowLayout.minimumLineSpacing = 2;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
        self.collectionView.backgroundColor = BackgroundColor;
        self.collectionView.contentInset = UIEdgeInsetsMake(2 * k_margin_vertical, 2 * k_margin_vertical, 2 * k_margin_vertical, 2 * k_margin_vertical);
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TQHKXQCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary * dict = self.dataSource[indexPath.item];
    cell.titleLabel.text = dict[@"title"];
    cell.detailLabel.text = dict[@"detail"];
    
    return cell;
}

@end
