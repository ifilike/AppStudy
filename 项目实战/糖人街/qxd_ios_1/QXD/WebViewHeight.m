//
//  WebViewHeight.m
//  QXD
//
//  Created by wzp on 16/1/23.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "WebViewHeight.h"
#import "MoxuanshiModel.h"


@implementation WebViewHeight



- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.webview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        _webview.delegate=self;
        //关闭滚动效果
        _webview.scrollView.scrollEnabled=NO;
        
        [self addSubview:_webview];
        self.heightArr=[NSMutableArray arrayWithCapacity:1];

        
    }
    
    return self;
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //   NSString * htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    //
    //    NSLog(@"%@",htmlHeight);
    //
    //    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"]floatValue];
    //    NSLog(@"%f",webViewHeight);
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
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
    
    
    
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, newFrame.size.width, newFrame.size.height);
    
    NSString * height=[NSString stringWithFormat:@"%f",newFrame.size.height];
    
    
    [self.heightArr addObject:height];
    
    
}
- (NSMutableArray*)getWebViewHeightArrWithMoxuanModelArr:(NSMutableArray*)moxuanModelArr{
    for (int i=0; i<[moxuanModelArr count]; i++) {
        MoxuanshiModel * model=moxuanModelArr[i];
        [self.webview loadHTMLString:model.viewpoint baseURL:nil];
    }
    
    
    
    return self.heightArr;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
