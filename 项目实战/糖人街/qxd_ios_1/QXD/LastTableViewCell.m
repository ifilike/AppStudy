//
//  LastTableViewCell.m
//  QXD
//
//  Created by zhujie on 平成27-11-18.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "LastTableViewCell.h"
#import "LastCollectionViewCell.h"
#import "LastCollectionModel.h"
#import "DeTaiilsViewController2.h"
#import "SubGoodsView.h"
#import "DeleteLienLabel.h"


@interface LastTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UICollectionView *collectionView;
//@property(nonatomic,assign) NSInteger count;
@end

@implementation LastTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
//-(void)setupCellWithArray:(NSArray *)array{
//    [self.scroll setScrollEnabled:YES];
//    [self.scroll setShowsVerticalScrollIndicator:YES];
//    for (int i = 0 ; i < [array count]; i ++ ) {
//        //根据数据解析数据 然后添加到scroll上去 先不用这个方法
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 330, 330)];
//        [self.scroll addSubview:view];
//    }
//    [self.scroll setContentSize:CGSizeMake(330, 200)];
//    self.scroll.delegate = self;
//    [self addSubview:self.scroll];
//}



#pragma mark -- UICollectionViewDelegate --
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_dataArray.count % 2 == 0) {
        self.collectionView.frame = CGRectMake(20*PROPORTION_WIDTH, 0, 350*PROPORTION_WIDTH, 272*PROPORTION_WIDTH*(_dataArray.count / 2));
    }else{
    self.collectionView.frame = CGRectMake(20*PROPORTION_WIDTH, 0, 334*PROPORTION_WIDTH, 272*PROPORTION_WIDTH*(1+ _dataArray.count / 2));
    }
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LastCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"abced" forIndexPath:indexPath];
    LastCollectionModel *modle = [self.dataArray objectAtIndex:indexPath.row];
    [cell configCollectionCellWithModel:modle];
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(WIDTH/2 -20, WIDTH/2 - 20 + (WIDTH/4-10));
    return CGSizeMake(158*PROPORTION_WIDTH, 218*PROPORTION_WIDTH);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(22*PROPORTION_WIDTH,4.5*PROPORTION_WIDTH, 0*PROPORTION_WIDTH, 4.5*PROPORTION_WIDTH);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.1*PROPORTION_WIDTH;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 22*PROPORTION_WIDTH;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"------click---%ld",(long)indexPath.row);
    
    LastCollectionModel *model = self.dataArray[indexPath.row];
    DeTaiilsViewController2 *detail = [[DeTaiilsViewController2 alloc] init];
    detail.productID = model.productId;
//    SubGoodsView *sub = [[SubGoodsView alloc] init];
//    sub.productID = model.selfID;
//    sub.buyPrice = model.yestodayPriceLabel;
//    sub.goodsNameLable.text = model.titleLabel;
//    sub.oldProice.text = model.todayPriceLabel;
//    sub.product_stanard = model.detailLabel;
//    detail.MainGoods = sub;
    
    [self.VC.navigationController pushViewController:detail animated:YES];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH,  (WIDTH/2  + (WIDTH/4-10))) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[LastCollectionViewCell class] forCellWithReuseIdentifier:@"abced"];
    
        _collectionView.backgroundColor = [UIColor whiteColor];
        //[_collectionView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PK_profile_bg"]]];
        [self addSubview:_collectionView];
    }
    return self;
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

