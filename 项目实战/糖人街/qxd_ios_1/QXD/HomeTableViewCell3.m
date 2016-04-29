//
//  HomeTableViewCell3.m
//  QXD
//
//  Created by wzp on 15/12/23.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "HomeTableViewCell3.h"
#import "DefaultModel.h"
#import "ByxxrMode.h"
#import "SubGoodsView.h"
#import "FoundImageButton.h"
#import "FoundModel.h"

#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation HomeTableViewCell3


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加展示图片的Button
        float YY=0;

        _imageBut=[[FoundImageButton alloc] initWithFrame:CGRectMake(0,YY, 375*PROPORTION_WIDTH, 281 * PROPORTION_WIDTH)];
        [_imageBut setBackgroundImage:[UIImage imageNamed:@"33"] forState:0];
        [self addSubview:_imageBut];
        YY+=281;

        //添加滚动视图
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, (YY)*PROPORTION_WIDTH, WIDTH, 186*PROPORTION_WIDTH+48)];
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
    if (![foundModel.img isEqualToString:@""]) {
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
    float setX=15*PROPORTION_WIDTH;
    for (int i=0; i<number+1; i++) {
        if (i==number) {
            _allGoodsBut=[[UIButton alloc] initWithFrame:CGRectMake(setX, 20*PROPORTION_WIDTH, 144*PROPORTION_WIDTH, 125*PROPORTION_WIDTH)];
            _allGoodsBut.tag=i;
            [_allGoodsBut setTitle:@"查看全部" forState:0];
            _allGoodsBut.backgroundColor=[UIColor orangeColor];
            
            [self.scrollView addSubview:_allGoodsBut];
            setX+=159*PROPORTION_WIDTH;
            self.scrollView.contentSize=CGSizeMake(setX, HEIGHT/4-10);
        }else{
            ByxxrMode * productModel=[[ByxxrMode alloc] init];
            NSDictionary * listdic=productArr[i];
            
            
            [productModel setValuesForKeysWithDictionary:listdic];
                        SubGoodsView * subGood=[[SubGoodsView alloc] initWithFrame:CGRectMake(setX, 20*PROPORTION_WIDTH, 144*PROPORTION_WIDTH, 141*PROPORTION_WIDTH+50)withModel:productModel];
            subGood.tag=i;
            [self.scrollView addSubview:subGood];
            [_subViewArr addObject:subGood];
            setX+=150*PROPORTION_WIDTH;

            NSLog(@"%f",setX);
        }
    }
    NSLog(@"%f",setX);
    NSLog(@"滚动视图的内容大小%f",setX);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
