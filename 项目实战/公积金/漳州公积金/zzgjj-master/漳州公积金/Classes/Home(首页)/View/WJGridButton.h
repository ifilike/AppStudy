//
//  WJHomeButton.h
//  testtt
//
//  Created by fengwujie on 16/1/15.
//  Copyright © 2016年 dw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJGridButton : UIButton

/**
 *  设置按钮的图片和文字
 *
 *  @param imageName 图片名称
 *  @param text      文字内容
 *  @param fontSize  字体大小
 */
- (void)setImageName:(NSString *)imageName text:(NSString *)text fontSize:(float)fontSize;


@end
