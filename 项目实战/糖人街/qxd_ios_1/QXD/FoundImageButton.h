//
//  FoundImageButton.h
//  QXD
//
//  Created by wzp on 15/12/10.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FoundModel;

@interface FoundImageButton : UIButton


@property(nonatomic,retain)NSString * BIG_TYPE_NAME;
@property(nonatomic,retain)NSString * TIME;
@property(nonatomic,retain)NSString * SMALL_TYPE_NAME;
@property(nonatomic,retain)NSString * SMALL_TYPE_ID;
@property(nonatomic,retain)NSString * BIG_TYPE_ID;
@property(nonatomic,retain)NSString * ID;
@property(nonatomic,retain)NSString * IS_DELETE;
@property(nonatomic,retain)NSString * IMG;
@property(nonatomic,retain)NSString * TITLE;


- (void)setModel:(FoundModel*)model;


@end
