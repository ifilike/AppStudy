//
//  CommentTableViewCell9.h
//  QXD
//
//  Created by wzp on 16/2/2.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductCommentModel;


@interface CommentTableViewCell9 : UITableViewCell

@property(nonatomic,retain)UIImageView * iconImageView;
@property(nonatomic,retain)UILabel * nameLabel;
@property(nonatomic,retain)UILabel * timeLabel;
@property(nonatomic,retain)UILabel * commentLabel;
@property(nonatomic,assign)float cellHigh;



- (void)setProductCommentModel:(ProductCommentModel*)model;


@end
