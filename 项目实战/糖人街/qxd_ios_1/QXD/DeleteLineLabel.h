//
//  DeleteLineLabel.h
//  QXD
//
//  Created by WZP on 15/11/18.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteLineLabel : UILabel


- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString*)title;

- (instancetype)initWithFrame2:(CGRect)frame withTitle:(NSString*)title;

- (void)changeTextWith:(NSString*)string;

@end
