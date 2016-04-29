//
//  WithUnderLienTextFieldView.h
//  QXD
//
//  Created by wzp on 16/2/17.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithUnderLienTextFieldView : UIView


@property(nonatomic,strong)UIView * underlienView;
@property(nonatomic,strong)UITextField * textField;



- (instancetype)initWithFrame:(CGRect)frame withPlaceholder:(NSString*)placeText;

@end
