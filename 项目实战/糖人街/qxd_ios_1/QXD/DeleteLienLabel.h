//
//  DeleteLienLabel.h
//  轻轻巧巧
//
//  Created by wzp on 16/1/29.
//  Copyright © 2016年 wzp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteLienLabel : UILabel



@property(nonatomic,retain)NSDictionary * attributeDic;


- (instancetype)initWithFrame:(CGRect)frame content:(NSString*)text textColor:(UIColor*)textColor textSize:(CGFloat)textSize deleteColor:(UIColor*)deleteColor;



- (void)changeTextWithNewText:(NSString*)newText;


@end
