//
//  ZJLayer.m
//  CAlayer
//
//  Created by babbage on 16/4/12.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ZJLayer.h"

@implementation ZJLayer
-(void)drawInContext:(CGContextRef)ctx{
    
    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    
    CGContextMoveToPoint(ctx, 50, 0);
    CGContextAddLineToPoint(ctx, 0, 100);
    CGContextAddLineToPoint(ctx, 100, 100);
    CGContextClosePath(ctx);
    
    CGContextFillPath(ctx);
    
}

@end
