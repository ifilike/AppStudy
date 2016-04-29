//
//  MoxuanshiView.m
//  QXD
//
//  Created by wzp on 16/1/31.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "MoxuanshiView.h"
#import "MoxuanshiModel.h"

@implementation MoxuanshiView






- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        //头像
        self.headImageView=[[UIImageView alloc] initWithFrame:CGRectMake((WIDTH-70*PROPORTION_WIDTH)/2, 20*PROPORTION_WIDTH, 70*PROPORTION_WIDTH, 70*PROPORTION_WIDTH)];
        _headImageView.image=[UIImage imageNamed:@"设计师"];
        _headImageView.layer.cornerRadius=_headImageView.frame.size.width/2;
        _headImageView.layer.masksToBounds = YES;
        [self addSubview:_headImageView];
        
        //工作
        self.jobLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 105*PROPORTION_WIDTH, WIDTH, 20*PROPORTION_WIDTH)];
        _jobLabel.textAlignment=1;
        _jobLabel.text=@"短发YOYO  设计师";
//        _jobLabel.backgroundColor=[UIColor redColor];
        _jobLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        _jobLabel.textColor=[self colorWithHexString:@"#666666"];
        [self addSubview:_jobLabel];
        
        //内容
        self.contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(75*PROPORTION_WIDTH, 125*PROPORTION_WIDTH, WIDTH-150*PROPORTION_WIDTH, 50*PROPORTION_WIDTH)];
//        _contentLabel.backgroundColor=[UIColor blueColor];
        _contentLabel.numberOfLines=2;
        _contentLabel.textColor=[self colorWithHexString:@"#999999"];
        _contentLabel.font=[UIFont systemFontOfSize:12*PROPORTION_WIDTH];
        
        NSString *labelText = @"如果你无法间接地表达你的想法,那只能说明你还不够了解你还不够了解它";
        
        //设置行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        self.contentLabel.attributedText = attributedString;
        self.contentLabel.textAlignment=1;

        [self addSubview:_contentLabel];
        
        //产品名称
        self.productLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 200*PROPORTION_WIDTH, WIDTH, 20*PROPORTION_WIDTH)];
        _productLabel.textAlignment=1;
        _productLabel.text=@"试用: SNP动物补水保湿面膜";
        _productLabel.textColor=[self colorWithHexString:@"FD681F"];
        _productLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        [self addSubview:_productLabel];
        
        
        //我的观点的标志
        _leftLien=[[UIView alloc] initWithFrame:CGRectMake(15*PROPORTION_WIDTH, 300*PROPORTION_WIDTH, 133*PROPORTION_WIDTH, 1)];
        _leftLien.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
        
        _rightLien=[[UIView alloc] initWithFrame:CGRectMake(WIDTH-148*PROPORTION_WIDTH, 300*PROPORTION_WIDTH, 133*PROPORTION_WIDTH, 1)];
        _rightLien.backgroundColor=[self colorWithHexString:@"#E4E4E4"];
        
        _ideaLabel=[[UILabel alloc] initWithFrame:CGRectMake(159*PROPORTION_WIDTH, 285*PROPORTION_WIDTH, WIDTH-318*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
        _ideaLabel.text=@"我的观点";
        _ideaLabel.textAlignment=1;
        _ideaLabel.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        _ideaLabel.textColor=[self colorWithHexString:@"#FD681F"];
        
        [self addSubview:_leftLien];
        [self addSubview:_rightLien];
        [self addSubview:_ideaLabel];

        
        
        self.webview=[[UIWebView alloc] initWithFrame:CGRectMake(0, 315*PROPORTION_WIDTH, WIDTH, 200)];
        self.webview.scrollView.scrollEnabled=NO;
        _webview.delegate=self;
        [self addSubview:_webview];

        

        
        self.backgroundColor=[UIColor whiteColor];
        
    }


    return self;


}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#555555'"];
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth = screen.width-15;" // UIWebView中显示的图片宽度
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
    
    
    
    [_webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        float webViewHeight = [[_webview stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        CGRect newFrame	   = _webview.frame;
        newFrame.size.height  = webViewHeight;
        _webview.frame = newFrame;

        [self.delegate changeHeightWith:webViewHeight withIndex:self.index];
    
        
    }
}







- (void)setMoxuanshiModel:(MoxuanshiModel*)model withIndex:(NSInteger)index{

    NSURL * url=[NSURL URLWithString:model.head_img];
    [_headImageView sd_setImageWithURL:url];
    
    
    _jobLabel.text=[NSString stringWithFormat:@"%@  %@",model.name,model.occupation];
    
    
    
//    NSString *labelText = model.introduces;
//    
//    //设置行间距
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5];//调整行间距
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
//    self.contentLabel.attributedText = attributedString;
    
    _contentLabel.textAlignment=1;
    
    NSString * productName=[NSString stringWithFormat:@"%@%@",@"试用: ",model.product_name];
    _productLabel.text=productName;
    
    
    
    
    
    //设置行间距
    //    NSString *webviewText = @"<style>body{line-height: 25px}</style>";
    NSString *webviewText = @"<style>body{font:14px/24px Custom-Font-Name;}</style>";
    
    NSString *htmlString = [webviewText stringByAppendingFormat:@"%@", model.viewpoint];
    
    [self.webview loadHTMLString:htmlString baseURL:nil];


    self.index=index;


}


- (void)removeFromSuperview{
    [_webview.scrollView removeObserver:self
                                    forKeyPath:@"contentSize" context:nil];
}



- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
