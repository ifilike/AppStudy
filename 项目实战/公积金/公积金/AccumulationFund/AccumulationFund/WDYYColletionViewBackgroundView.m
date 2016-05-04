//
//  WDYYColletionViewBackgroundView.m
//  AccumulationFund
//
//  Created by mac on 15/11/16.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "WDYYColletionViewBackgroundView.h"
#import "FundReferences.h"

@implementation WDYYColletionViewBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = BackgroundColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rect.size.width/2.0, 0);
    CGPathAddLineToPoint(path, NULL, rect.size.width/2.0, rect.size.height - k_button_size.height);
    CGContextAddPath(ctx, path);
    CGContextSetLineWidth(ctx, 3);
    [BarColor setStroke];
    CGContextStrokePath(ctx);
    
}


@end
