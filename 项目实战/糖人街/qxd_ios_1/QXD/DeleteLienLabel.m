//
//  DeleteLienLabel.m
//  轻轻巧巧
//
//  Created by wzp on 16/1/29.
//  Copyright © 2016年 wzp. All rights reserved.
//

#import "DeleteLienLabel.h"

@implementation DeleteLienLabel





- (instancetype)initWithFrame:(CGRect)frame content:(NSString*)text textColor:(UIColor*)textColor textSize:(CGFloat)textSize deleteColor:(UIColor*)deleteColor{

    self=[super initWithFrame:frame];
    if (self) {
        
        self.attributeDic=@{NSFontAttributeName:[UIFont systemFontOfSize:textSize],
                            NSForegroundColorAttributeName:textColor,
                            NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                            NSStrikethroughColorAttributeName:deleteColor};
        
        NSAttributedString *attrStr =
        [[NSAttributedString alloc]initWithString:text
                                       attributes:self.attributeDic];
        self.attributedText = attrStr;
    }
    return self;
}

- (void)changeTextWithNewText:(NSString*)newText{

    
    NSAttributedString * attrStr=[[NSAttributedString alloc] initWithString:newText attributes:self.attributeDic];
    self.attributedText=attrStr;



}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
