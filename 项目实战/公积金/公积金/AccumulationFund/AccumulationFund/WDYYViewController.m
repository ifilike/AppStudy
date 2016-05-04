//
//  WDYYViewController.m
//  AccumulationFund
//
//  Created by mac on 15/11/14.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "WDYYViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "WDYYCollectionViewCell.h"
#import "FundReferences.h"
#import "WDYYCollectionView.h"
#warning 瀑布流

@interface WDYYViewController () <UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout>

@property (strong, nonatomic) WDYYCollectionView * collectionView;
@property (strong, nonatomic) CHTCollectionViewWaterfallLayout * layout;
@property (strong, nonatomic) NSArray * dataSource;
@property (strong, nonatomic) NSMutableDictionary * stringSizeCache;

@end

@implementation WDYYViewController

static NSString * const reusableIdentifier = @"WDYYCell";


- (NSArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = @[
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"爱存不存银行第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"
                            },
                        @{},
                        
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"爱存不存银行大帝国路黑几把街第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"
                            },
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"存存吧银行大帝国路黑几把街第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长"
                            },
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"爱存不存银行大帝国路第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"
                            },
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"爱存不存银行第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"
                            },
                        
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"爱存不存银行大帝国路黑几把街第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"
                            },
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"存存吧银行大帝国路黑几把街第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长"
                            },
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"爱存不存银行大帝国路第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"
                            },
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"爱存不存银行第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"
                            },
                        
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"爱存不存银行大帝国路黑几把街第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"
                            },
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"存存吧银行大帝国路黑几把街第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长"
                            },
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"爱存不存银行大帝国路第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"
                            },
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"爱存不存银行第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"
                            },
                        
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"爱存不存银行大帝国路黑几把街第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"
                            },
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"存存吧银行大帝国路黑几把街第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长"
                            },
                        @{
                            @"time" : @"2015-11-03",
                            @"type" : @"公积金贷款",
                            @"reservesDate" : @"2015-11-05",
                            @"outlet" : @"爱存不存银行大帝国路第213号分行",
                            @"tip" : @"你需要知道这句话长短, 但是我不知道长短, 长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长"
                            },
                        
                        ];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的预约";

    self.view.backgroundColor = BackgroundColor;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[WDYYCollectionViewCell class] forCellWithReuseIdentifier:reusableIdentifier];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"blankCell"];

}


- (CHTCollectionViewWaterfallLayout *)layout {
    if (_layout == nil) {
        _layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        _layout.columnCount = 2;
        _layout.minimumColumnSpacing = 45;
        _layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _layout.minimumContentHeight = 20;
        _layout.minimumInteritemSpacing = 40;
    }
    return _layout;
}


- (WDYYCollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[WDYYCollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = BackgroundColor;
        _collectionView.contentInset = UIEdgeInsetsMake(20, 0, 40, 0);
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
    
    if (indexPath.item == 1) {
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"blankCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    WDYYCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusableIdentifier forIndexPath:indexPath];
    [self infoStringWithIndexPath:indexPath callback:^(NSString *infoString, CGSize size) {
        cell.infoLabel.text = infoString;
    }];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == 1) {
        return CGSizeMake(20, 1);
    }
    __block CGSize mySize;
    [self infoStringWithIndexPath:indexPath callback:^(NSString *infoString, CGSize size) {
        mySize = size;
    }];
    return CGSizeMake(mySize.width + k_margin_horizontal * 2, mySize.height);
}


- (void)infoStringWithIndexPath:(NSIndexPath *)indexPath callback:(void(^)(NSString * infoString, CGSize size))callback {
    NSMutableString * str = [NSMutableString string];

    NSDictionary * infoDict = self.dataSource[indexPath.item];

    [str appendFormat:@"%@ 预约\n", infoDict[@"time"]];
    [str appendFormat:@"%@\n", infoDict[@"type"]];
    [str appendFormat:@"预约时间 %@\n", infoDict[@"reservesDate"]];
    [str appendFormat:@"预约网点 %@\n", infoDict[@"outlet"]];
    [str appendString:@"业务须知\n"];
    [str appendFormat:@"%@\n", infoDict[@"tip"]];

    CGSize strSize;
    if (self.stringSizeCache[indexPath] == nil) {
        strSize = [self getRectWithString:str.copy];
        [self.stringSizeCache setObject:[NSValue valueWithCGSize:strSize] forKey:indexPath];
    } else {
        strSize = [self.stringSizeCache[indexPath] CGSizeValue];
    }
    callback(str.copy,  strSize);
}


- (CGSize)getRectWithString:(NSString*)aString {
    CGSize size;
    UIFont *nameFont=[UIFont fontWithName:@"Helvetica" size:13];
    size=[aString sizeWithFont:nameFont constrainedToSize:CGSizeMake((k_screen_width - 45 - 40 - k_margin_horizontal * 4) * 0.5, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    return  size;
}


- (NSMutableDictionary *)stringSizeCache {
    if (_stringSizeCache == nil) {
        _stringSizeCache = [NSMutableDictionary dictionary];
    }
    return _stringSizeCache;
}


@end
