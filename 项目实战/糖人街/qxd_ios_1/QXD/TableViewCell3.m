//
//  TableViewCell3.m
//  QXD
//
//  Created by wzp on 15/12/23.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "TableViewCell3.h"
#import "FoundZTModel.h"

@implementation TableViewCell3

- (void)awakeFromNib {
    // Initialization code
}



- (void)setFoundZTModel:(FoundZTModel*)model{
    NSURL * url=[NSURL URLWithString:model.img];
    NSData * data=[NSData dataWithContentsOfURL:url];
    _imageView2.image=[UIImage imageWithData:data];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
