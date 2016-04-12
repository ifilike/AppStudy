//
//  ViewController.m
//  CAlayer
//
//  Created by babbage on 16/4/12.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ViewController.h"
#import "ZJLayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self CALayoutText1];
   
}
-(void)CALayoutText1{
    ZJLayer *zjLayer = [ZJLayer layer];
    
    zjLayer.bounds = CGRectMake(0, 0, 100, 100);
    zjLayer.position = CGPointMake(100, 100);
    
    [zjLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:zjLayer];
}

-(void)CALayoutText2{
    CALayer *layer = [CALayer layer];
    // 设置delegate
    layer.delegate = self;
    // 设置层的宽高
    layer.bounds = CGRectMake(0, 0, 100, 100);
    // 设置层的位置
    layer.position = CGPointMake(100, 100);
    // 开始绘制图层
    [layer setNeedsDisplay];
    [self.view.layer addSublayer:layer];
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    // 设置蓝色
    CGContextSetRGBStrokeColor(ctx, 0, 0, 1, 1);
    // 设置边框宽度
    CGContextSetLineWidth(ctx, 10);
    // 添加一个跟层一样大的矩形到路径中
    CGContextAddRect(ctx, layer.bounds);
    // 绘制路径
    CGContextStrokePath(ctx);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
