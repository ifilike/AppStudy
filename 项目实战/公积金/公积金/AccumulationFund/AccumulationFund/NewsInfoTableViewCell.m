//
//  NewsInfoTableViewCell.m
//  AccumulationFund
//
//  Created by mac on 15/12/9.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "NewsInfoTableViewCell.h"
#import "FundReferences.h"
#import "UIColor+Hex.h"

@implementation NewsInfoTableViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

- (void)setModel:(NewsModel *)model {
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.context;
    if (model.date.length > 16) {
        self.dateLabel.text = [model.date substringToIndex:16];
        return;
    }
    self.dateLabel.text = model.date;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
