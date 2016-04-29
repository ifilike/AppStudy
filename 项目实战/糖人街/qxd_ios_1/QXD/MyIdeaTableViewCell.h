//
//  MyIdeaTableViewCell.h
//  QXD
//
//  Created by wzp on 16/1/20.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyIdeaWebView;
@class MoxuanshiModel;



@protocol SizeDelegate <NSObject>

@required

- (void)HeightWith:(CGFloat)height withIndex:(NSInteger)index;


@end



@interface MyIdeaTableViewCell : UITableViewCell<UIWebViewDelegate>



@property(nonatomic,retain)UIImageView * headImageView;
@property(nonatomic,retain)UILabel * jobLabel;
@property(nonatomic,retain)UILabel * contentLabel;
@property(nonatomic,retain)UILabel * productLabel;

@property(nonatomic,retain)UIView * leftLien;
@property(nonatomic,retain)UIView * rightLien;
@property(nonatomic,retain)UILabel * ideaLabel;




@property(nonatomic,assign)id <SizeDelegate> delegate;
@property(nonatomic,retain)UIWebView * webview;
@property(nonatomic,assign)float viewHigh;
@property(nonatomic,assign)NSInteger index;




- (void)setMoxuanModel:(MoxuanshiModel*)model withIndex:(NSInteger)index;



@end
