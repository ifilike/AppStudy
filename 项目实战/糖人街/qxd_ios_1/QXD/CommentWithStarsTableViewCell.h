//
//  CommentWithStarsTableViewCell.h
//  QXD
//
//  Created by wzp on 15/12/14.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductCommentModel;
@class CommentModel;

@interface CommentWithStarsTableViewCell : UITableViewCell

@property(nonatomic,retain)UIImageView * iconImageView;
@property(nonatomic,retain)UILabel * nameLabel;
@property(nonatomic,retain)UILabel * timeLabel;
@property(nonatomic,retain)UILabel * commentLabel;
@property(nonatomic,retain)UIView * startsView;


@property(nonatomic,assign)float cellHigh;



- (void)setProductCommentModel:(ProductCommentModel*)model;
- (void)setZTCommentModel:(CommentModel*)model;



@end
