//
//  FindHeadView.m
//  QXD
//
//  Created by wzp on 15/12/22.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "FindHeadView.h"
#import "WithLabelImageView.h"
#import "FoundZTModel.h"

@implementation FindHeadView

#define HeIgHt frame.size.height
#define WiDtH frame.size.width


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        float setX=5;
        float width1=(WiDtH-20)/3;
        float width2=(WiDtH-15)/2;
        float height=(HeIgHt-15)/2;
        //轻拍轻点手势
        _imageView1=[[WithLabelImageView alloc] initWithFrame:CGRectMake(setX, 5, width1, height)];
        _imageView1.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap1=[[UITapGestureRecognizer alloc] init];
        [tap1 addTarget:self action:@selector(delegateDoSomethingOne)];
        [_imageView1 addGestureRecognizer:tap1];
        setX+=5+width1;
        _imageView2=[[WithLabelImageView alloc] initWithFrame:CGRectMake(setX, 5, width1, height)];
        _imageView2.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap2=[[UITapGestureRecognizer alloc] init];
        [tap2 addTarget:self action:@selector(delegateDoSomethingTwo)];

        [_imageView2 addGestureRecognizer:tap2];


        setX+=5+width1;
        _imageView3=[[WithLabelImageView alloc] initWithFrame:CGRectMake(setX, 5, width1, height)];
        _imageView3.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap3=[[UITapGestureRecognizer alloc] init];
        [tap3 addTarget:self action:@selector(delegateDoSomethingThree)];

        [_imageView3 addGestureRecognizer:tap3];


        _imageView4=[[WithLabelImageView alloc] initWithFrame:CGRectMake(5, height+10, width2, height)];
        _imageView4.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap4=[[UITapGestureRecognizer alloc] init];
        [tap4 addTarget:self action:@selector(delegateDoSomethingFour)];

        [_imageView4 addGestureRecognizer:tap4];


        _imageView5=[[WithLabelImageView alloc] initWithFrame:CGRectMake(width2+10, height+10, width2, height)];
        _imageView5.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap5=[[UITapGestureRecognizer alloc] init];
        [tap5 addTarget:self action:@selector(delegateDoSomethingFive)];

        [_imageView5 addGestureRecognizer:tap5];


        setX+=5;
        [self addSubview:_imageView1];
        [self addSubview:_imageView2];
        [self addSubview:_imageView3];
        [self addSubview:_imageView4];
        [self addSubview:_imageView5];
        
    }
    return self;

}

- (void)reloadDataWithFoundZTModelArr:(NSMutableArray*)modelArr{
    self.foundZTIDArr=[NSMutableArray arrayWithCapacity:1];
    
    FoundZTModel * mode1=modelArr[0];
    _imageView1.image=[self imageWithString:mode1.img];
    _imageView1.titleLabel.text=mode1.title;
    [_foundZTIDArr addObject:mode1.ID];
    
    FoundZTModel * mode2=modelArr[1];
    _imageView2.image=[self imageWithString:mode2.img];
    _imageView2.titleLabel.text=mode2.title;
    [_foundZTIDArr addObject:mode2.ID];



    FoundZTModel * mode3=modelArr[2];
    _imageView3.image=[self imageWithString:mode3.img];
    _imageView3.titleLabel.text=mode3.title;
    [_foundZTIDArr addObject:mode3.ID];



    FoundZTModel * mode4=modelArr[3];
    _imageView4.image=[self imageWithString:mode4.img];
    _imageView4.titleLabel.text=mode4.title;
    [_foundZTIDArr addObject:mode4.ID];



    FoundZTModel * mode5=modelArr[4];
    _imageView5.image=[self imageWithString:mode5.img];
    _imageView5.titleLabel.text=mode5.title;
    [_foundZTIDArr addObject:mode5.ID];


}

- (UIImage*)imageWithString:(NSString*)imageStr{
    NSURL * url=[NSURL URLWithString:imageStr];
    NSData * data=[NSData dataWithContentsOfURL:url];
    UIImage * image=[UIImage imageWithData:data];
    return image;
    
    
}


- (void)delegateDoSomethingOne{
    
    [self.delegate doSomethingWithString:_foundZTIDArr[0]];

}
- (void)delegateDoSomethingTwo{
    
    [self.delegate doSomethingWithString:_foundZTIDArr[1]];
    
}
- (void)delegateDoSomethingThree{
    
    [self.delegate doSomethingWithString:_foundZTIDArr[2]];
    
}
- (void)delegateDoSomethingFour{
    
    [self.delegate doSomethingWithString:_foundZTIDArr[3]];
    
}
- (void)delegateDoSomethingFive{
    
    [self.delegate doSomethingWithString:_foundZTIDArr[4]];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
