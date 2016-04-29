//
//  MyIdeaWebView.m
//  QXD
//
//  Created by wzp on 16/1/23.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "MyIdeaWebView.h"
#import "MoxuanshiModel.h"

@implementation MyIdeaWebView






- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.webview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        _webview.delegate=self;
        //关闭滚动效果
        _webview.scrollView.scrollEnabled=NO;
        
        [self addSubview:_webview];
        
        
    }
    
    return self;
    
    
}
- (void)loadDataWithHTMLString:(NSString*)string{
    
    [_webview loadHTMLString:string baseURL:nil];
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //   NSString * htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    //
    //    NSLog(@"%@",htmlHeight);
    //
    //    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"]floatValue];
    //    NSLog(@"%f",webViewHeight);
    
    //   NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    //  [webView stringByEvaluatingJavaScriptFromString:str];
    
    
    //字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#555555'"];
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = screen.width-20;" // UIWebView中显示的图片宽度
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    
    //  [webView sizeToFit];
    
}
- (void)changeFrameWithHeight:(float)height{
    CGRect newFrame	   = _webview.frame;
    newFrame.size.height  = height;
    _webview.frame = newFrame;
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newFrame.size.height);
}


//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//     float webViewHeight = [[_webview stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//        CGRect newFrame	   = _webview.frame;
//        newFrame.size.height  = webViewHeight;
//        _webview.frame = newFrame;
//        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newFrame.size.height);
//
//    }
//}
//
//
//- (void)removeObserver{
//    [_webview.scrollView removeObserver:self
//                                    forKeyPath:@"contentSize" context:nil];
//}
//


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
