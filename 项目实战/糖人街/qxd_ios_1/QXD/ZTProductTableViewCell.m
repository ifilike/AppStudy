//
//  ZTProductTableViewCell.m
//  QXD
//
//  Created by wzp on 15/12/7.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "ZTProductTableViewCell.h"
#import "ZTProductListModel.h"

@implementation ZTProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(ZTProductListModel*)model{
    [self getImageWithUrlString:model.product_img1];
    self.nameLabel.text=model.product_name;
    

}
- (void)getImageWithUrlString:(NSString*)urlString{
    NSURL * url=[NSURL URLWithString:urlString];
    NSData * data=[NSData dataWithContentsOfURL:url];
    UIImage * image=[UIImage imageWithData:data];
    self.imageView2.image=image;
}
- (void)getNameWithModle:(ZTProductListModel*)model{
    self.nameLabel.text=model.product_name;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
