//
//  ViewController.m
//  coreTextTest
//
//  Created by babbage on 16/4/19.
//  Copyright © 2016年 babbage. All rights reserved.
//
//https://www.raywenderlich.com/
//http://www.raywenderlich.com/tutorials
//https://www.raywenderlich.com/4147/core-text-tutorial-for-ios-making-a-magazine-app
//

#import "ViewController.h"
#import "CTView.h"
#import "MarkupParser.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    float frameXOffset;
    float frameYOffset;
    NSAttributedString *attString;
}

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) CTView *cTView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _cTView = [[CTView alloc] init];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *5);
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
//    [scrollView addSubview:_cTView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
    NSString* text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    MarkupParser* p = [[MarkupParser alloc] init];
//    NSAttributedString* attString = [p attrStringFromMarkup: text];
    attString = [p attrStringFromMarkup: text];
    [_cTView setAttString: attString];
//    [(CTView *)_cTView buildFrames];
    [self buildFrames];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _cTView.backgroundColor = [UIColor whiteColor];
    _cTView.frame = CGRectMake(0, 20, self.view.frame.size.width, 5*self.view.frame.size.height);
}
-(void)buildFrames{
    frameXOffset = 20; //1
    frameYOffset = 20;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
//    self.scrollView.frames = [NSMutableArray array];
    
    CGMutablePathRef path = CGPathCreateMutable(); //2
    CGRect textFrame = CGRectInset(self.scrollView.bounds, frameXOffset, frameYOffset);
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
        CTColumnView* content = [[CTColumnView alloc] initWithFrame: CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
        content.backgroundColor = [UIColor clearColor];
        content.frame = CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height) ;
        
        //set the column view contents and add it as subview
        [content setCTFrame:(__bridge id)frame];  //6
//        [self.scrollView.frames addObject: (__bridge id)frame];
        [self.scrollView addSubview: content];
        
        //prepare for next frame
        textPos += frameRange.length;
        
        //CFRelease(frame);
        CFRelease(path);
        
        columnIndex++;
    }
    
    //set the total width of the scroll view
    int totalPages = (columnIndex+1) / 2; //7
    self.scrollView.contentSize = CGSizeMake(totalPages*self.scrollView.bounds.size.width, textFrame.size.height);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
