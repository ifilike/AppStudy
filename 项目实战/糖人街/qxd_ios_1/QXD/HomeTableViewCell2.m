//
//  HomeTableViewCell2.m
//  QXD
//
//  Created by wzp on 15/11/30.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "HomeTableViewCell2.h"
#import "HomeModel2.h"
#import "SubGoodsView.h"
#import "ByxxrMode.h"

@implementation HomeTableViewCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setByxxrModel:(ByxxrMode*)model withModelArr:(NSMutableArray*)modelArr{
    self.subViewArr=[NSMutableArray arrayWithCapacity:1];
    NSInteger count=[modelArr count];
    NSLog(@"小鲜肉赋值 %ld",(long)count);
    float setX=8;
    for (int i=0; i<count; i++) {
       ByxxrMode * model=modelArr[i];
        SubGoodsView * subView=[[SubGoodsView alloc] initWithFrame:CGRectMake(setX, 0, (WIDTH-26)/3, (WIDTH-26)/3+40) withModel:model];
        subView.tag=i+1;
        
        [self.scrollView addSubview:subView];
        [self.subViewArr addObject:subView];
        setX+=(WIDTH-26)/3+5;
        NSLog(@"添加了1个");
    }
    NSLog(@"***");
    self.scrollView.contentSize=CGSizeMake(setX, WIDTH/3);


}

- (void)setModel:(HomeModel2*)model{
    
    
    
    
    
}




@end
