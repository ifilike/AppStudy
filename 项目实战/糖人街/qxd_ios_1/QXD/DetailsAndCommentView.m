//
//  DetailsAndCommentView.m
//  QXD
//
//  Created by WZP on 15/11/20.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "DetailsAndCommentView.h"
#import "MutibleLabel.h"
#import "ProductCommentModel.h"
#import "CommentTableViewCell.h"

@implementation DetailsAndCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.productCommentModelArr=[NSMutableArray arrayWithCapacity:1];
        self.height=0;
        
        NSArray * buttonArr=[NSArray arrayWithObjects:@"商品详情",@"用户评论", nil];
        
        _detailsControl=[[UISegmentedControl alloc] initWithItems:buttonArr];
        _detailsControl.frame=CGRectMake(16*PROPORTION_WIDTH, 0, 343*PROPORTION_WIDTH, 36*PROPORTION_WIDTH);
        _detailsControl.tintColor=[self colorWithHexString:@"#FD681F"];
        _detailsControl.selectedSegmentIndex=0;
        [self addSubview:_detailsControl];
        
        
        _height+=36*PROPORTION_WIDTH;
        
        //添加商品详情
        
        _mutibleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16*PROPORTION_WIDTH, 64*PROPORTION_WIDTH, frame.size.width-32*PROPORTION_WIDTH, 40)];
        [_mutibleLabel setTextColor:[self colorWithHexString:@"#555555"]];
        [_mutibleLabel setNumberOfLines:0];
        _mutibleLabel.font=[UIFont systemFontOfSize:12];
        _mutibleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //        NSString *labelText = @"可以自己按照宽高，字体大小，来计算有多少行。。然后。。。每行画一个UILabel。。高度自己可以控制把这个写一个自定义的类。 ";
        //
        //        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        //        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //        [paragraphStyle setLineSpacing:5];//调整行间距
        //        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        //        _mutibleLabel.attributedText = attributedString;
        NSLog(@"高5555度是:%f",_mutibleLabel.frame.size.height);
        
        //  [_mutibleLabel sizeToFit];
        NSLog(@"高度是:%f",_mutibleLabel.frame.size.height);
        
        [self addSubview:_mutibleLabel];
        
        self.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _mutibleLabel.frame.size.height+64*PROPORTION_WIDTH+28*PROPORTION_WIDTH);
        
    }
    
    return self;
    
}
//更新数据:商品说明和图片
- (void)reloadDataWithDetailsText:(NSString*)text{
    
    _contentText=[NSString stringWithString:text];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    _mutibleLabel.attributedText = attributedString;
    NSLog(@"高5555度是:%f",_mutibleLabel.frame.size.height);
    
    [_mutibleLabel sizeToFit];
    NSLog(@"高度是:%f",_mutibleLabel.frame.size.height);
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _mutibleLabel.frame.size.height+64*PROPORTION_WIDTH+28*PROPORTION_WIDTH);
    
}

- (void)commentWithNumberOfCommnet:(int)number{
    [self addCommentTableViewWithNumber:number];
}
- (void)addCommentTableViewWithNumber:(int)number{
    
    
    //移除详情文字和图片
    [_mutibleLabel removeFromSuperview];
    //    //添加用户评论图
    _countLabel=[[UILabel alloc] initWithFrame:CGRectMake(16*PROPORTION_WIDTH, 76*PROPORTION_WIDTH, self.frame.size.width-32*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
    _countLabel.font=[UIFont systemFontOfSize:17*PROPORTION_WIDTH];
    NSString * str=@"所有";
    NSString * num=[NSString stringWithFormat:@"%d",number];
    NSString * str2=@"条评论";
    NSString * allStr=[NSString stringWithFormat:@"%@%@%@",str,num,str2];
    
    NSInteger loca=[allStr length];
    NSLog(@"%ld",loca);
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#555555"] range:NSMakeRange(0,2)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#FD681F"] range:NSMakeRange(2,loca-5)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:@"#555555"] range:NSMakeRange(loca-3,3)];
    _countLabel.attributedText=attributeStr;
    [self addSubview:_countLabel];
    
    
    _lienView=[[UIView alloc] initWithFrame:CGRectMake(0, 105*PROPORTION_WIDTH, WIDTH, 0.5)];
    _lienView.backgroundColor=[self colorWithHexString:@"#DDDDDD"];
    [self addSubview:_lienView];
    
    
    
    //判断评论条数,决定_commentTableView的高度
    if (number>4) {
        //多于4条评论,只展示4条
        number=4;
    }
    _commentTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 106*PROPORTION_WIDTH, self.frame.size.width, 94*number*PROPORTION_WIDTH)];
    _commentTableView.tag=10;
    _commentTableView.bounces=NO;
    _commentTableView.scrollEnabled=NO;
    _commentTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self addSubview:_commentTableView];
    
    //查看更多的按钮
    _moreCommentBut=[[UIButton alloc] initWithFrame:CGRectMake(0, 96*PROPORTION_WIDTH+18*PROPORTION_WIDTH+94*number*PROPORTION_WIDTH, self.frame.size.width, 18*PROPORTION_WIDTH)];
    [_moreCommentBut setTitleColor:[self colorWithHexString:@"#999999"] forState:0];
    //    [_moreCommentBut setTitle:@"查看更多" forState:0];
    _moreCommentBut.titleLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
    [self addSubview:_moreCommentBut];
    
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 96*PROPORTION_WIDTH+36*PROPORTION_WIDTH+94*number*PROPORTION_WIDTH);
    
    
}

- (void)addDetailsImageView{
    //移除用户评论列表图
    [_countLabel removeFromSuperview];
    [_lienView removeFromSuperview];
    [_moreCommentBut removeFromSuperview];
    [_commentTableView removeFromSuperview];
    
    //添加商品详情图
    _mutibleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16*PROPORTION_WIDTH, 64*PROPORTION_WIDTH, self.frame.size.width-32*PROPORTION_WIDTH, 40)];
    //        [_mutibleLabel setBackgroundColor:[UIColor blackColor]];
    [_mutibleLabel setTextColor:[self colorWithHexString:@"#555555"]];
    [_mutibleLabel setNumberOfLines:0];
    _mutibleLabel.font=[UIFont systemFontOfSize:12];
    _mutibleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_contentText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_contentText length])];
    _mutibleLabel.attributedText = attributedString;
    NSLog(@"高5555度是:%f",_mutibleLabel.frame.size.height);
    
    [_mutibleLabel sizeToFit];
    NSLog(@"高度是:%f",_mutibleLabel.frame.size.height);
    
    [self addSubview:_mutibleLabel];
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _mutibleLabel.frame.size.height+64*PROPORTION_WIDTH+28*PROPORTION_WIDTH);
    
    
}



- (void)details{
    [self addDetailsImageView];
    
    
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
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
