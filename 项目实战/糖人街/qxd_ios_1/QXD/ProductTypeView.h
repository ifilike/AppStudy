//
//  ProductTypeView.h
//  QXD
//
//  Created by WZP on 15/11/18.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTypeView : UIView


- (instancetype)initWithFrame:(CGRect)frame buttonNameArr:(NSArray*)buttonNameArr;

- (void)changeContentWithButtonArr:(NSArray*)buttonArr;



@end
