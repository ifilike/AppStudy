//
//  MoxuanshiView.h
//  QXD
//
//  Created by wzp on 16/1/31.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoxuanshiModel;






@protocol ViewSizeDelegate <NSObject>

@required

- (void)changeHeightWith:(CGFloat)height withIndex:(NSInteger)index;


@end







@interface MoxuanshiView : UIView<UIWebViewDelegate>


@property(nonatomic,retain)UIImageView * headImageView;
@property(nonatomic,retain)UILabel * jobLabel;
@property(nonatomic,retain)UILabel * contentLabel;
@property(nonatomic,retain)UILabel * productLabel;

@property(nonatomic,retain)UIView * leftLien;
@property(nonatomic,retain)UIView * rightLien;
@property(nonatomic,retain)UILabel * ideaLabel;



@property(nonatomic,retain)UIWebView * webview;
@property(nonatomic,retain)id <ViewSizeDelegate> delegate;
@property(nonatomic,assign)NSInteger index;



- (void)setMoxuanshiModel:(MoxuanshiModel*)model withIndex:(NSInteger)index;






@end
