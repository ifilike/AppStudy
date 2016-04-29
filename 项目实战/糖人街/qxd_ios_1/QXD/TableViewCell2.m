//
//  TableViewCell2.m
//  QXD
//
//  Created by WZP on 15/11/17.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "TableViewCell2.h"
#import "DefaultModel.h"
#import "ByxxrMode.h"
#import "ProductListModel.h"
#import "SubGoodsView.h"
#import "FoundImageButton.h"
#import "FoundModel.h"



#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation TableViewCell2

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加展示图片的Button
        _imageBut=[[FoundImageButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT/4-10)];
        _imageBut.backgroundColor=[UIColor yellowColor];
        [_imageBut setBackgroundImage:[UIImage imageNamed:@"照片"] forState:0];
        [self addSubview:_imageBut];
        //添加滚动视图
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, HEIGHT/4, WIDTH, WIDTH/3+50)];
        _scrollView.delegate=self;
        _scrollView.bounces=NO;
        [self addSubview:_scrollView];
        
    }
    
    return self;
    
}
- (void)setModel:(DefaultModel *)model{
    
    NSDictionary * foundDic=model.found;
    FoundModel * foundModel=[[FoundModel alloc] init];
    [foundModel setValuesForKeysWithDictionary:foundDic];
    if (![foundModel.IMG isEqualToString:@""]) {
        [_imageBut setModel:foundModel];
    }
    
    self.subViewArr=[NSMutableArray arrayWithCapacity:1];
    [self.subViewArr removeAllObjects];
    for (id  view in [self.scrollView subviews]) {
        [view removeFromSuperview];
    }
    NSArray * productArr=model.productList;
    int number=(int)[productArr count];
    NSLog(@"有%d个小商品",number);
    float setX=0;
    for (int i=0; i<number+1; i++) {
        if (i==number) {
            _allGoodsBut=[[UIButton alloc] initWithFrame:CGRectMake(setX, 0, WIDTH/3, WIDTH/3)];
            _allGoodsBut.tag=i;
            [_allGoodsBut setTitle:@"查看全部" forState:0];
            _allGoodsBut.backgroundColor=[UIColor orangeColor];
            
            [self.scrollView addSubview:_allGoodsBut];
            setX+=WIDTH/3;
            self.scrollView.contentSize=CGSizeMake(setX, HEIGHT/4-10);
        }else{
            ProductListModel * productModel=[[ProductListModel alloc] init];
            NSDictionary * listdic=productArr[i];
            [productModel setValuesForKeysWithDictionary:listdic];
            
            SubGoodsView * subGood=[[SubGoodsView alloc] initWithFrame:CGRectMake(setX, 0, WIDTH/3, HEIGHT/4-10)];
            subGood.tag=i;
            [subGood setModel:productModel];
            [self.scrollView addSubview:subGood];
            [_subViewArr addObject:subGood];
            setX+=WIDTH/3+10;
            NSLog(@"%f",setX);
        }
        
        
    }
    NSLog(@"%f",setX);
    
    
    NSLog(@"滚动视图的内容大小%f",setX);
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
