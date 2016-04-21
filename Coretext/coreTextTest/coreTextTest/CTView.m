//
//  CTView.m
//  coreTextTest
//
//  Created by babbage on 16/4/19.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "CTView.h"
#import <CoreText/CoreText.h>
#import "MarkupParser.h"

@implementation CTView

@synthesize attString;
@synthesize frames;

//at the bottom of the file
-(void)dealloc
{
    self.attString = nil;
    self.frames = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)buildFrames{
    frameXOffset = 20; //1
    frameYOffset = 20;
    self.pagingEnabled = YES;
    self.delegate = self;
    self.frames = [NSMutableArray array];
    
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectInset(self.bounds, frameXOffset, frameYOffset);
    CGPathAddRect(path, NULL, textFrame );
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    
    int textPos = 0; //3
    int columnIndex = 0;
    
    while (textPos < [attString length]) { //4
        CGPoint colOffset = CGPointMake( (columnIndex+1)*frameXOffset + columnIndex*(textFrame.size.width/2), 20 );
        CGRect colRect = CGRectMake(0, 0 , textFrame.size.width/2-10, textFrame.size.height-40);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        //use the column path
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame); //5
        
        //create an empty column view
        CTColumnView* content = [[CTColumnView alloc] initWithFrame: CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
        content.backgroundColor = [UIColor clearColor];
        content.frame = CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height) ;
        
        //set the column view contents and add it as subview
        [content setCTFrame:(__bridge id)frame];  //6
        [self.frames addObject: (__bridge id)frame];
        [self addSubview: content];
        
        //prepare for next frame
        textPos += frameRange.length;
        
        //CFRelease(frame);
        CFRelease(path);
        
        columnIndex++;
    }
    
    //set the total width of the scroll view
    int totalPages = (columnIndex+1) / 2; //7
    self.contentSize = CGSizeMake(totalPages*self.bounds.size.width, textFrame.size.height);

}



-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //*这是很简单的代码，它只是把内容通过变换视图的上下文。每一次你做的绘图时，只需复制/粘贴它。
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //1. 在这里，您需要创建一个路径，该路径将在您将绘制文本的区域中创建一个路径。在Mac上的核心文本支持不同的形状如矩形和圆，但目前iOS只支持矩形为核心文本绘制。在这个简单的例子中，你可以使用整个视图边界为矩形，您将创建一个cgpath self.bounds参考图。
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds );
    
    //2. 核心文本你不会使用NSString，而是nsattributedstring，如下所示。nsattributedstring是一个非常强大的NSString衍生物类，它允许你使用格式属性的文本。目前我们将不会使用格式化了，这只会创建一个字符串，保持纯文本。
//    NSAttributedString* attString = [[NSAttributedString alloc]
//                                      initWithString:@"你好，我叫朱杰"];
    
//    MarkupParser* p = [[MarkupParser alloc] init];
//    NSAttributedString* attString = [p attrStringFromMarkup: @"Hello <font color=\"red\">core text <font color=\"blue\">world!"];
    
    //3. ctframesetter是使用核心绘制文本时，最重要的一类。它管理您的字体引用和您的文本绘图框架。眼下你需要知道的是，ctframesettercreatewithattributedstring创建一个ctframesetter你保留它并将它初始化与提供的属性字符串。在这一节中，当你创建一个框架framesetter，你给ctframesettercreateframe一系列字符串渲染（我们这里选择整个字符串）和矩形，文本将出现拉。
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame =
    CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path, NULL);
    
    //4. 这里ctframedraw得出在给定的上下文中提供的框架。
    CTFrameDraw(frame, context);
    
    //5. 最后，所有使用的对象被释放。
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

@end
