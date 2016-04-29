//
//  EightLabelView.h
//  QXD
//
//  Created by wzp on 16/1/9.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EightLabelView : UIView




- (instancetype)initWithFrame:(CGRect)frame withEffectStrArr:(NSArray*)effectArr;

- (void)reloadDataWithLabelArr:(NSArray*)effectStrArr;



@end
