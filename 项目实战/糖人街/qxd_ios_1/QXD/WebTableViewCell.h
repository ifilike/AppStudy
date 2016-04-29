//
//  WebTableViewCell.h
//  QXD
//
//  Created by wzp on 16/1/27.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoxuanshiModel;




@protocol SizeDelegate <NSObject>

@required

- (void)HeightWith:(CGFloat)height withIndex:(NSInteger)index;


@end


@interface WebTableViewCell : UITableViewCell<UIWebViewDelegate>


@property(nonatomic,assign)id <SizeDelegate> delegate;
@property(nonatomic,retain)UIWebView * webView;
@property(nonatomic,assign)float viewHigh;
@property(nonatomic,assign)NSInteger index;



- (void)setMoxuanshiModel:(MoxuanshiModel*)model withIndex:(NSInteger)index;

@end
