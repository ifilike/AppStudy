//
//  CommentTableViewCell.h
//  QXD
//
//  Created by WZP on 15/11/19.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModel;
@class ProductCommentModel;


@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *userID;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

- (void)setModel:(CommentModel*)model;


- (void)setProductCommentModel:(ProductCommentModel*)model;










@end
