//
//  ProductTypeView.m
//  QXD
//
//  Created by WZP on 15/11/18.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "ProductTypeView.h"




//#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation ProductTypeView

- (instancetype)initWithFrame:(CGRect)frame buttonNameArr:(NSArray*)buttonNameArr{
    self=[super initWithFrame:frame];
    int count=(int)[buttonNameArr count];
    float setX=0;
    float setY=0;
    if (self) {
        for (int i=0; i<count; i++) {
            NSLog(@"%d  %d",i,count);
            UIButton * typeBut=[[UIButton alloc] initWithFrame:CGRectMake(setX, setY, WIDTH/4, 30)];
            [typeBut setTitle:buttonNameArr[i] forState:0];
            [typeBut setTitleColor:[UIColor blackColor] forState:0];
            typeBut.tag=i+1;
            [self addSubview:typeBut];
            if (i%4==3&&i!=count-1) {
                setX=0;
                setY+=30;
                NSLog(@"换行");
            }else if(i==count-1){
                setY+=30;
                NSLog(@"高度 :%f",setY);
            }else{
                setX+=WIDTH/4;
            }
            
        }
    }
    self.frame=CGRectMake(frame.origin.x, frame.origin.y, WIDTH, setY);
    self.backgroundColor=[UIColor whiteColor];

    return self;
}

- (void)changeContentWithButtonArr:(NSArray*)buttonArr{
    NSArray * arr=[self subviews];
    for (UIButton * button in arr) {
        [button removeFromSuperview];
    }
    
    int count=(int)[buttonArr count];
    float setX=0;
    float setY=0;
    if (self) {
        for (int i=0; i<count; i++) {
            NSLog(@"%d  %d",i,count);

            UIButton * typeBut=[[UIButton alloc] initWithFrame:CGRectMake(setX, setY, WIDTH/4, 30)];
            [typeBut setTitle:buttonArr[i] forState:0];
            [typeBut setTitleColor:[UIColor blackColor] forState:0];
            typeBut.tag=i+1;
            [self addSubview:typeBut];
            if (i%4==3&&i!=count-1) {
                setX=0;
                setY+=30;
                NSLog(@"换行");
            }else if(i==count-1){
                setY+=30;
                NSLog(@"高度 :%f",setY);
            }else{
                setX+=WIDTH/4;
            }
        }
    }
    self.frame=CGRectMake(self.frame.origin.x,self.frame.origin.y, WIDTH, setY);
    self.backgroundColor=[UIColor whiteColor];



}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
