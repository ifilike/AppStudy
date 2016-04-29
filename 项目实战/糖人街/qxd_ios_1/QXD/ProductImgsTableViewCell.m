//
//  ProductImgsTableViewCell.m
//  QXD
//
//  Created by wzp on 16/1/29.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "ProductImgsTableViewCell.h"

@implementation ProductImgsTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self ) {
        self.imageView2=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 375)];
        
        
        [self addSubview:_imageView2];
    }
    return self;

}

- (void)setImageWithUrlStr:(NSString*)urlStr{
    NSURL * url=[NSURL URLWithString:urlStr];
    [self.imageView2 sd_setImageWithURL:url];

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
