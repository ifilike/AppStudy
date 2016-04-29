//
//  MyIdeaWebView.h
//  QXD
//
//  Created by wzp on 16/1/23.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>











@interface MyIdeaWebView : UIView<UIWebViewDelegate>




@property(nonatomic,retain)UIWebView * webview;





- (void)loadDataWithHTMLString:(NSString*)string;



- (void)changeFrameWithHeight:(float)height;




@end
