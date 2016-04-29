//
//  DetailsAndCommentView.h
//  QXD
//
//  Created by WZP on 15/11/20.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MutibleLabel;
//@class ProductCommentModel;

@interface DetailsAndCommentView : UIView<UIScrollViewDelegate>


@property(nonatomic,retain)UILabel * countLabel;
@property(nonatomic,retain)UIView * lienView;



@property(nonatomic,retain)UITableView * commentTableView;
@property(nonatomic,retain)UILabel * mutibleLabel;
@property(nonatomic,assign)float height;
@property(nonatomic,retain)UIButton * detailsBut;
@property(nonatomic,retain)UIButton * commentBut;
@property(nonatomic,retain)UIButton * moreCommentBut;
@property(nonatomic,retain)NSMutableArray * productCommentModelArr;
//@property(nonatomic,assign)BOOL comment;
@property(nonatomic,retain)UISegmentedControl * detailsControl;


@property(nonatomic,retain)NSString * contentText;





- (void)commentWithNumberOfCommnet:(int)number;
- (void)reloadDataWithDetailsText:(NSString*)text;
- (void)details;


@end
