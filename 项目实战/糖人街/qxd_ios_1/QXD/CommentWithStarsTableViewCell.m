//
//  CommentWithStarsTableViewCell.m
//  QXD
//
//  Created by wzp on 15/12/14.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "CommentWithStarsTableViewCell.h"
#import "ProductCommentModel.h"
#import "CommentModel.h"

@implementation CommentWithStarsTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //头像
        self.iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, 32*PROPORTION_WIDTH, 32*PROPORTION_WIDTH)];
        
        [self addSubview:_iconImageView];
        _iconImageView.image=[UIImage imageNamed:@"头像"];
        //昵称
        self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(29*PROPORTION_WIDTH+32*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, 90*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
        _nameLabel.text=@"刘语熙";
        _nameLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        _nameLabel.textColor=[self colorWithHexString:@"#999999"];
        [self addSubview:_nameLabel];
        //日期
        self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(WIDTH-165*PROPORTION_WIDTH, 15*PROPORTION_WIDTH, 150*PROPORTION_WIDTH, 20*PROPORTION_WIDTH)];
        _timeLabel.text=@"2015 11 22";
        _timeLabel.textAlignment=2;
        _timeLabel.font=[UIFont systemFontOfSize:12*PROPORTION_WIDTH];
        _timeLabel.textColor=[self colorWithHexString:@"#BBBBBB"];
        [self addSubview:_timeLabel];
        //评论
        self.commentLabel=[[UILabel alloc] initWithFrame:CGRectMake(29*PROPORTION_WIDTH+32*PROPORTION_WIDTH, 39*PROPORTION_WIDTH, WIDTH-61*PROPORTION_WIDTH-23*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
        _commentLabel.numberOfLines=0;
        NSString * labelText =@"最近海狗这款太热SD卡积分距离地方十多个 爱上大概  阿什顿  打算 撒大哥 爱国啊撒旦噶打算 撒大哥  噶速度啊阿大使馆撒旦干撒 更多 多少分很高的发生过阿三哥";
        //设置行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        _commentLabel.attributedText = attributedString;
        _commentLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        _commentLabel.textColor=[self colorWithHexString:@"#555555"];
        [_commentLabel sizeToFit];
        [self addSubview:_commentLabel];
//        _commentLabel.backgroundColor=[UIColor blackColor];
    }
    return self;
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setZTCommentModel:(CommentModel*)model{
    NSURL * url=[NSURL URLWithString:model.comment_customer_head];
    [_iconImageView sd_setImageWithURL:url];
    NSLog(@"%@",model.comment_customer_head);
    if (model.comment_customer_head.length==0) {
        _iconImageView.image=[UIImage imageNamed:@"默认头像"];
    }
    
    
    _nameLabel.text=model.comment_customer_nickname;
    _timeLabel.text=model.comment_time;
   // [self.commentLabel removeFromSuperview];
    
    //评论
    
    
    self.commentLabel.frame=CGRectMake(29*PROPORTION_WIDTH+32*PROPORTION_WIDTH, 34*PROPORTION_WIDTH, WIDTH-61*PROPORTION_WIDTH-23*PROPORTION_WIDTH, 50*PROPORTION_WIDTH);
    
    
    NSString * labelText =model.comment_content;
    //设置行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    _commentLabel.attributedText = attributedString;
//    NSLog(@"%f",_commentLabel.frame.size.height);
    [_commentLabel sizeToFit];

//    _commentLabel.backgroundColor=[UIColor greenColor];
//    NSLog(@"-+-%f",_commentLabel.frame.size.height);

//    NSLog(@"****%f",_commentLabel.frame.size.height+34*PROPORTION_WIDTH);

    self.cellHigh=_commentLabel.frame.size.height+34*PROPORTION_WIDTH;
    
    
    
}


- (void)setProductCommentModel:(ProductCommentModel*)model{
    //头像
    NSURL * url=[NSURL URLWithString:model.customer_head_portrait];
    [_iconImageView sd_setImageWithURL:url];
    //昵称
    self.nameLabel.text=model.customer_nick_name;
    //时间
    self.timeLabel.text=model.create_time;
    //内容
    NSString * labelText =model.comment_content;
    //设置行间距
    _commentLabel.numberOfLines=0;

    self.commentLabel.frame=CGRectMake(29*PROPORTION_WIDTH+32*PROPORTION_WIDTH, 34*PROPORTION_WIDTH, WIDTH-61*PROPORTION_WIDTH-23*PROPORTION_WIDTH, 50*PROPORTION_WIDTH);
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    _commentLabel.attributedText = attributedString;
    [_commentLabel sizeToFit];
    self.cellHigh=_commentLabel.frame.size.height+34*PROPORTION_WIDTH;

}
- (void)addStarsWithNumber:(NSString*)number{

    int count=[number intValue];
    float setX=0;
    for (int i=0; i<count; i++) {
        UIImageView * start=[[UIImageView alloc] initWithFrame:CGRectMake(setX, 0, 30, 30)];
        UIImage * image=[UIImage imageNamed:@"星"];
        start.image=image;
        [self.startsView addSubview:start];
        setX+=30;
    }
    
}
- (void)drawRect:(CGRect)rect{
    _iconImageView.layer.cornerRadius=_iconImageView.frame.size.width/2;
    _iconImageView.layer.masksToBounds = YES;
}


@end
