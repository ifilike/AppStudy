//
//  FDJSTableViewCell.m
//  AccumulationFund
//
//  Created by mac on 15/11/18.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "FDJSTableViewCell.h"
#import "FDJSMXViewController.h"
#import "FDSJXQViewController.h"

@implementation FDJSTableViewCell

- (void)awakeFromNib {

    
}
- (IBAction)mingXiButtonClick:(id)sender {
    UIResponder * responder = self.nextResponder;
    while (1) {
        responder = responder.nextResponder;
        if ([responder isKindOfClass:[FDSJXQViewController class]]) {
            break;
        }
    }
    
    FDJSMXViewController *tmp = [FDJSMXViewController new];
    tmp.dataSource = ((FDSJXQViewController *)responder).mxDataSource;
    
    [((FDSJXQViewController *)responder).navigationController pushViewController:tmp animated:true];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
