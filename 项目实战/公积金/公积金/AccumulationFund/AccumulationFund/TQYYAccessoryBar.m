//
//  TQYYAccessoryBar.m
//  AccumulationFund
//
//  Created by mac on 15/12/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "TQYYAccessoryBar.h"
#import "FundReferences.h"

@implementation TQYYAccessoryBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, k_screen_width, 44);

        self.translucent = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
