//
//  WebViewHeight2.m
//  QXD
//
//  Created by wzp on 16/1/27.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "WebViewHeight2.h"

@implementation WebViewHeight2



- (instancetype)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if (self) {
        self.webview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
        _webview.delegate=self;
        _webview.scrollView.scrollEnabled=NO;
        [self addSubview:_webview];
        [_webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

        
    }
    return self;

}
- (void)loadDataWithHTMLString:(NSString*)string index:(NSInteger)index{
    [_webview loadHTMLString:string baseURL:nil];

    self.index=index;
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
    
    
    
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = 300.0;" // UIWebView中显示的图片宽度
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
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        float webViewHeight = [[_webview stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        
        [self.delegate getHeightWith:webViewHeight withIndex:self.index];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
