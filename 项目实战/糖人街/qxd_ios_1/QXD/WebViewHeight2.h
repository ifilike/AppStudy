//
//  WebViewHeight2.h
//  QXD
//
//  Created by wzp on 16/1/27.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol WebViewSizeDelegate <NSObject>

@required

- (NSString*)getHeightWith:(CGFloat)height withIndex:(NSInteger)index;


@end




@interface WebViewHeight2 : UIView<UIWebViewDelegate>

@property(nonatomic,retain)UIWebView * webview;
@property(nonatomic,retain)id <WebViewSizeDelegate> delegate;
@property(nonatomic,assign)NSInteger index;



- (void)loadDataWithHTMLString:(NSString*)string index:(NSInteger)index;



@end
