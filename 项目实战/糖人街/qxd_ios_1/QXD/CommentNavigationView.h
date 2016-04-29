//
//  CommentNavigationView.h
//  QXD
//
//  Created by wzp on 16/2/2.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentNavigationView : UIView


@property(nonatomic,retain)UILabel * controllerName;
@property(nonatomic,retain)UIButton * cancellBut;



-  (instancetype)initWithFrame:(CGRect)frame withName:(NSString*)name;



@end
