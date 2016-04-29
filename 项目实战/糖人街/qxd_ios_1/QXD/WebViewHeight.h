//
//  WebViewHeight.h
//  QXD
//
//  Created by wzp on 16/1/23.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewHeight : UIView<UIWebViewDelegate>



@property(nonatomic,retain)UIWebView * webview;
@property(nonatomic,retain)NSMutableArray * heightArr;



- (NSMutableArray*)getWebViewHeightArrWithMoxuanModelArr:(NSMutableArray*)moxuanModelArr;



@end
