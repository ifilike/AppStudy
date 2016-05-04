//
//  WJHomeButtom.h
//  漳州公积金
//
//  Created by fengwujie on 16/1/8.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJHomeButton : UIView

+ (instancetype)homeButton;

- (void)setImageName:(NSString *)imageName text:(NSString *)text;
/**
 *  按钮文字
 */
@property (nonatomic, copy) NSString *text;

@end
