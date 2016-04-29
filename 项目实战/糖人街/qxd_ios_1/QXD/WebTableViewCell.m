//
//  WebTableViewCell.m
//  QXD
//
//  Created by wzp on 16/1/27.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "WebTableViewCell.h"
#import "MoxuanshiModel.h"

@implementation WebTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
        self.webView.scrollView.scrollEnabled=NO;
        [self addSubview:_webView];
        [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;

}
- (void)setMoxuanshiModel:(MoxuanshiModel*)model withIndex:(NSInteger)index{

    [self.webView loadHTMLString:model.viewpoint baseURL:nil];
    
    self.index=index;


}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
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
    





}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        float webViewHeight = [[_webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        CGRect newFrame	   = _webView.frame;
        newFrame.size.height  = webViewHeight;
        self.viewHigh=webViewHeight;
        _webView.frame = newFrame;
        
        [self.delegate HeightWith:webViewHeight withIndex:self.index];
        
        //返回Cell的高度
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
