//
//  CommentTableViewCell.m
//  QXD
//
//  Created by WZP on 15/11/19.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "ProductCommentModel.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {

    _iconView.layer.cornerRadius=_iconView.frame.size.width/2;
    
    // Initialization code
}

- (void)setModel:(CommentModel*)model{
    self.userID.text=model.comment_customer_nickname;
    NSAttributedString * jjj=[[NSAttributedString alloc] initWithString:model.comment_content];

//    self.commentLabel.text=model.comment_content;
    self.commentLabel.attributedText=jjj;
    self.timeLabel.text=model.comment_time;
    [self requestIconWithUrlString:model.comment_customer_head];

}
- (void)setProductCommentModel:(ProductCommentModel*)model{
    self.userID.text=model.customer_nick_name;
    self.commentLabel.text=model.comment_content;
    self.timeLabel.text=model.create_time;
    [self requestIconWithUrlString:model.customer_head_portrait];
}


- (void)requestIconWithUrlString:(NSString*)iconUrlString{
    NSURL * iconURL=[NSURL URLWithString:iconUrlString];
    NSData * data=[NSData dataWithContentsOfURL:iconURL];
    self.iconView.image=[UIImage imageWithData:data];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
