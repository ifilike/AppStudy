//
//  KnowLedgeTableViewCell.h
//  QXD
//
//  Created by wzp on 16/1/27.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyIdeaWebView;
@class FoundModel;

@interface KnowLedgeTableViewCell : UITableViewCell



@property(nonatomic,retain)MyIdeaWebView * konwLedgeView;




- (void)setFoundModel:(FoundModel*)model withHeight:(float)height;



@end
