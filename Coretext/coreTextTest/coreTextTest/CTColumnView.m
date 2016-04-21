//
//  CTColumnView.m
//  coreTextTest
//
//  Created by babbage on 16/4/20.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "CTColumnView.h"


@implementation CTColumnView

-(void)setCTFrame:(id)f{
    ctFrame = f;
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Flip th coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw((CTFrameRef)ctFrame, context);
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
