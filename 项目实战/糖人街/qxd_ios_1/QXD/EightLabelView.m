//
//  EightLabelView.m
//  QXD
//
//  Created by wzp on 16/1/9.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "EightLabelView.h"

@implementation EightLabelView



- (instancetype)initWithFrame:(CGRect)frame withEffectStrArr:(NSArray*)effectArr{
    self=[super initWithFrame:frame];
    if (self) {
        int count=(int)[effectArr count];
        //  添加标签
        float setX=17*PROPORTION_WIDTH;
        float setY=0;
        for (int i=0; i<count; i++) {
            UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(setX, setY, 72.5*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
            lab.tag=i+1;
            lab.text=effectArr[i];
            lab.textAlignment=1;
            lab.textColor=[self colorWithHexString:@"#555555"];
            lab.backgroundColor=[UIColor whiteColor];
            lab.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
            lab.layer.borderWidth=0.5;
            lab.layer.cornerRadius=5;
            
            [self addSubview:lab];
            if (i%4==3&&i!=count-1) {
                setX=17*PROPORTION_WIDTH;
                setY+=40*PROPORTION_WIDTH;
            }else{
                setX+=72.5*PROPORTION_WIDTH+17*PROPORTION_WIDTH;
            }
        }
        
        if (count<=4) {
            self.frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 50*PROPORTION_WIDTH);
        }
        
        
    }
    return self;
}

- (void)reloadDataWithLabelArr:(NSArray*)effectStrArr{
    [self removeAllLabels];
    [self addLabelsWithEffectArr:effectStrArr];
    
}
//移除原有的标签
- (void)removeAllLabels{
    NSArray * subViewsArr=[self subviews];
    for (UILabel * label in subViewsArr) {
        [label removeFromSuperview];
    }
    int count=(int)[subViewsArr count];
    NSLog(@"移除了%d个",count);
    
}
- (void)addLabelsWithEffectArr:(NSArray*)effectArr{
    int count=(int)[effectArr count];
    if (count<=4) {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 50*PROPORTION_WIDTH);
    }else{
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 90*PROPORTION_WIDTH);
    }
    //  添加标签
    float setX=17*PROPORTION_WIDTH;
    float setY=0;
    for (int i=0; i<count; i++) {
        UILabel * lab=[[UILabel alloc] initWithFrame:CGRectMake(setX, setY, 72.5*PROPORTION_WIDTH, 30*PROPORTION_WIDTH)];
        lab.tag=i+1;
        lab.text=effectArr[i];
        lab.textAlignment=1;
        lab.textColor=[self colorWithHexString:@"#555555"];
        lab.backgroundColor=[UIColor whiteColor];
        lab.font=[UIFont systemFontOfSize:14*PROPORTION_WIDTH];
        lab.layer.borderWidth=0.5;
        lab.layer.cornerRadius=10;
        lab.backgroundColor=[self colorWithHexString:@"#FFFFFF"];
        lab.layer.borderColor=[self colorWithHexString:@"#DDDDDD"].CGColor;
        
        [self addSubview:lab];
        if (i%4==3&&i!=count-1) {
            setX=17*PROPORTION_WIDTH;
            setY+=10+30*PROPORTION_WIDTH;
        }else{
            setX+=72.5*PROPORTION_WIDTH+17*PROPORTION_WIDTH;
        }
    }
    
}


- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
