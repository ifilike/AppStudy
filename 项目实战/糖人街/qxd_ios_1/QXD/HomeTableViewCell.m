//
//  HomeTableViewCell.m
//  QXD
//
//  Created by WZP on 15/11/20.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#define  abc WIDTH/375.0
#import "HomeTableViewCell.h"
#import "HomeModel.h"
#import "MutibleLabel.h"
#import "SubGoodsView.h"
#import "ByxxrMode.h"




#define HEIGHT [[UIScreen mainScreen] bounds].size.height


@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.labelView.textColor=[self colorWithHexString:@"#555555"];
    [self.detailsBut setTitleColor:[self colorWithHexString:@"#FD681F"] forState:0];
    self.detailsBut.titleLabel.font=[UIFont systemFontOfSize:14];

    //按iPhone6来设计的,375代表第一张图片在iphon6上的宽度,281代表第一张图片在iphon6上的高度
    //375*PROPORTION_WIDTH 代表此图片在当前机型上得宽度
    //281 * PROPORTION_WIDTH 代表此图片在当前机型上得高度
    //15*PROPORTION_WIDTH 代表一个View在当前机型左边的边距
    //(15+YY)*PROPORTION_WIDTH 代表这个view和上面的view有15*PROPORTION_WIDTH的距离
    float YY=0;
    self.imageView2.frame=CGRectMake(0,YY, 375*PROPORTION_WIDTH, 281 * PROPORTION_WIDTH);
    YY+=281;
    self.labelView.frame=CGRectMake(15*PROPORTION_WIDTH, (8+YY)*PROPORTION_WIDTH, 345*PROPORTION_WIDTH, 50*PROPORTION_WIDTH);
    self.labelView.numberOfLines=2;
//    self.labelView.backgroundColor=[UIColor redColor];
    self.labelView.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];

    YY+=50;
    self.detailsBut.frame=CGRectMake(151*PROPORTION_WIDTH, (10+YY)*PROPORTION_WIDTH, 61*PROPORTION_WIDTH, 22*PROPORTION_WIDTH);
    self.detailsBut.titleLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    self.detailsView.frame=CGRectMake(217*PROPORTION_WIDTH, (15+YY)*PROPORTION_WIDTH, 12*PROPORTION_WIDTH, 12*PROPORTION_WIDTH);
    YY+=22;
    
    
    
    
    self.productListView.frame=CGRectMake(0, (YY)*PROPORTION_WIDTH, WIDTH, 171*PROPORTION_WIDTH+50);
    self.productListView.showsHorizontalScrollIndicator=NO;
    
    
    
    self.lienView=[[UIView alloc] initWithFrame:CGRectMake(0, (YY+5)*PROPORTION_WIDTH+171*PROPORTION_WIDTH+51, WIDTH, 0.5)];
    _lienView.backgroundColor=[self colorWithHexString:@"#DDDDDD"];
    [self addSubview:_lienView];

    
    float high=544*PROPORTION_WIDTH+50-((YY+5)*PROPORTION_WIDTH+171*PROPORTION_WIDTH+51.5);
    
    self.grayView=[[UIView alloc] initWithFrame:CGRectMake(0, (YY+5)*PROPORTION_WIDTH+171*PROPORTION_WIDTH+51.5, WIDTH, high)];
    _grayView.backgroundColor=[self colorWithHexString:@"F7F7F7"];
    [self addSubview:_grayView];
    
    
    
}


- (void)setModel:(HomeModel*)model{
    NSURL * imageUrl=[NSURL URLWithString:model.img];
    [self.imageView2 sd_setImageWithURL:imageUrl];
//    self.imageView2.backgroundColor=[UIColor redColor];
    //设置行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.title];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.title length])];
    self.labelView.attributedText = attributedString;

    self.subViewArr=[NSMutableArray arrayWithCapacity:1];
    int count=(int)[model.products count];
    float setX=15*PROPORTION_WIDTH;
    for (int i=0; i<count; i++) {
        NSLog(@"添加第%d个",i);
        NSDictionary * byxxrDic=model.products[i];
        ByxxrMode * byxxrModel=[[ByxxrMode alloc] init];
        [byxxrModel setValuesForKeysWithDictionary:byxxrDic];

        SubGoodsView * subGood=[[SubGoodsView alloc] initWithFrame:CGRectMake(setX, 20*PROPORTION_WIDTH, 144*PROPORTION_WIDTH, 141*PROPORTION_WIDTH+50)withModel:byxxrModel];
        subGood.tag=i;
        [self.productListView addSubview:subGood];
        [_subViewArr addObject:subGood];
        setX+=150*PROPORTION_WIDTH;
    }
    self.productListView.contentSize=CGSizeMake(setX+9*PROPORTION_WIDTH, 10);
    NSLog(@"滚动视图的内容大小%f",setX);

}
- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}



- (UIImage*)getImageWithUrlString:(NSString*)urlStr{
    NSURL * url=[NSURL URLWithString:urlStr];
    NSData * data=[NSData dataWithContentsOfURL:url];
    UIImage * image=[UIImage imageWithData:data];
    return image;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
