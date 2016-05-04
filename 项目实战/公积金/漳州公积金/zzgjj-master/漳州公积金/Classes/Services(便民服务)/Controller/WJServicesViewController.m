//
//  WJServicesViewController.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/4.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJServicesViewController.h"
#import "WJWebViewController.h"
#import "WJCalculatorViewController.h"
#import "WJGridButton.h"
#import "WJSysTool.h"

@interface WJServicesViewController ()

/** 贷款指南 */
@property (nonatomic, strong) WJGridButton *dkzn;
/** 提取指南 */
@property (nonatomic, strong) WJGridButton *tqzn;
/** 开户指南 */
@property (nonatomic, strong) WJGridButton *kfzn;
/** 公积金利率 */
@property (nonatomic, strong) WJGridButton *gjjll;
/** 贷款计算器 */
@property (nonatomic, strong) WJGridButton *dkjsq;

@end

@implementation WJServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WJGlobalBg;
    [self setup];
}

/**
 初始化界面
 */
- (void) setup
{
    // 2.创建一个大窗口GridView
    UIView *gridView = [[UIView alloc] init];
    [self.view addSubview:gridView];
    gridView.backgroundColor = [UIColor clearColor];
    gridView.x = 0;
    gridView.y = 0;
    gridView.width = self.view.width;
    gridView.height = self.view.height - 64 - self.tabBarController.tabBar.height;
    
    float fontSize = 15;  //问候语字体大小
    float multiple = 1;  //第一行高度与宽度的倍数
    float multiple2 = 1.3;  //第二高度与宽度的倍数
    float margin = 5;   //网格间距
    DeviceModel deviceModel = [WJSysTool deviceModel];
    if (deviceModel == DeviceModeliPhone5) {
        fontSize = 15;
        multiple = 1;
        multiple2 = 1.5;
        margin = 6;
    }
    else if (deviceModel == DeviceModeliPhone6) {
        fontSize = 17;
        multiple = 1;
        multiple2 = 1.5;
        margin = 7;
    }
    else if(deviceModel== DeviceModeliPhone6Plus )
    {
        fontSize = 20;
        multiple = 1;
        multiple2 = 1.5;
        margin = 8;
    }
    
    float colWidth = (gridView.width - margin * 3) * 0.5;
    float firstRowHeight = (gridView.height - (margin * 3)) * 0.4;
    float secondRowHeight = (gridView.height - (margin * 3)) * 0.6;
    
    // 往GridView容器里面添加按钮
    // 2.1添加“贷款指南”
    WJGridButton *dkzn = [[WJGridButton alloc] init];
    [gridView addSubview:dkzn];
    self.dkzn = dkzn;
    dkzn.x = margin;
    dkzn.y = margin;
    dkzn.width = colWidth;
    dkzn.height = firstRowHeight;
    dkzn.backgroundColor = WJColorDKZN;
    [dkzn setImageName:@"ic_guide" text:@"贷款指南" fontSize:fontSize];
    [dkzn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.2添加“提取指南”
    WJGridButton *tqzn = [[WJGridButton alloc] init];
    [gridView addSubview:tqzn];
    self.tqzn = tqzn;
    tqzn.x = margin + CGRectGetMaxX(dkzn.frame);
    tqzn.y = dkzn.y;
    tqzn.width = colWidth;
    tqzn.height = firstRowHeight;
    tqzn.backgroundColor = WJColorTQZN;
    [tqzn setImageName:@"ic_material" text:@"提取指南" fontSize:fontSize];
    [tqzn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.3添加“开户指南”
    WJGridButton *kfzn = [[WJGridButton alloc] init];
    [gridView addSubview:kfzn];
    self.kfzn = kfzn;
    kfzn.x = margin;
    kfzn.y = margin + CGRectGetMaxY(dkzn.frame);
    kfzn.width = colWidth;
    kfzn.height = secondRowHeight;
    kfzn.backgroundColor = WJColorKFZN;
    [kfzn setImageName:@"ic_kfzn" text:@"开户指南" fontSize:fontSize];
    [kfzn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.4添加“公积金利率”
    WJGridButton *gjjll = [[WJGridButton alloc] init];
    [gridView addSubview:gjjll];
    self.gjjll = gjjll;
    gjjll.x = margin + CGRectGetMaxX(kfzn.frame);
    gjjll.y = kfzn.y;
    gjjll.width = colWidth;
    gjjll.height = (kfzn.height - margin) * 0.5;
    gjjll.backgroundColor = WJColorGJJLL;
    [gjjll setImageName:@"ic_gjjll" text:@"公积金利率" fontSize:fontSize];
    [gjjll addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.5添加“贷款计算器”
    WJGridButton *dkjsq = [[WJGridButton alloc] init];
    [gridView addSubview:dkjsq];
    self.dkjsq = dkjsq;
    dkjsq.x = gjjll.x;
    dkjsq.y = margin + CGRectGetMaxY(gjjll.frame);
    dkjsq.width = colWidth;
    dkjsq.height = gjjll.height;
    dkjsq.backgroundColor = WJColorDKJSQ;
    [dkjsq setImageName:@"ic_dkjsq" text:@"贷款计算器" fontSize:fontSize];
    [dkjsq addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}


/**
 初始化界面
 */
- (void) setup2
{
    // 2.创建一个大窗口GridView
    UIView *gridView = [[UIView alloc] init];
    [self.view addSubview:gridView];
    gridView.backgroundColor = [UIColor clearColor];
    gridView.x = 0;
    gridView.y = 0;
    gridView.width = self.view.width;
    gridView.height = self.view.height;
    
    float fontSize = 15;  //问候语字体大小
    float multiple = 1;  //第一行高度与宽度的倍数
    float multiple2 = 1.3;  //第二高度与宽度的倍数
    float margin = 5;   //网格间距
    DeviceModel deviceModel = [WJSysTool deviceModel];
    if (deviceModel == DeviceModeliPhone5) {
        fontSize = 15;
        multiple = 1;
        multiple2 = 1.5;
        margin = 6;
    }
    else if (deviceModel == DeviceModeliPhone6) {
        fontSize = 17;
        multiple = 1;
        multiple2 = 1.5;
        margin = 7;
    }
    else if(deviceModel== DeviceModeliPhone6Plus )
    {
        fontSize = 18;
        multiple = 1;
        multiple2 = 1.5;
        margin = 8;
    }

    // 往GridView容器里面添加按钮
    // 2.1添加“贷款指南”
    WJGridButton *dkzn = [[WJGridButton alloc] init];
    [gridView addSubview:dkzn];
    self.dkzn = dkzn;
    dkzn.x = margin;
    dkzn.y = margin;
    dkzn.width = (gridView.width - margin * 3) * 0.5;
    dkzn.height = dkzn.width * multiple;
    dkzn.backgroundColor = WJColorDKZN;
    [dkzn setImageName:@"ic_guide" text:@"贷款指南" fontSize:fontSize];
    [dkzn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.2添加“提取指南”
    WJGridButton *tqzn = [[WJGridButton alloc] init];
    [gridView addSubview:tqzn];
    self.tqzn = tqzn;
    tqzn.x = margin + CGRectGetMaxX(dkzn.frame);
    tqzn.y = dkzn.y;
    tqzn.width = dkzn.width;
    tqzn.height = tqzn.width * multiple;
    tqzn.backgroundColor = WJColorTQZN;
    [tqzn setImageName:@"ic_material" text:@"提取指南" fontSize:fontSize];
    [tqzn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.3添加“开户指南”
    WJGridButton *kfzn = [[WJGridButton alloc] init];
    [gridView addSubview:kfzn];
    self.kfzn = kfzn;
    kfzn.x = margin;
    kfzn.y = margin + CGRectGetMaxY(dkzn.frame);
    kfzn.width = dkzn.width;
    kfzn.height = kfzn.width * multiple2;
    kfzn.backgroundColor = WJColorKFZN;
    [kfzn setImageName:@"ic_kfzn" text:@"开户指南" fontSize:fontSize];
    [kfzn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.4添加“公积金利率”
    WJGridButton *gjjll = [[WJGridButton alloc] init];
    [gridView addSubview:gjjll];
    self.gjjll = gjjll;
    gjjll.x = margin + CGRectGetMaxX(kfzn.frame);
    gjjll.y = kfzn.y;
    gjjll.width = kfzn.width;
    gjjll.height = (kfzn.height - margin) * 0.5;
    gjjll.backgroundColor = WJColorGJJLL;
    [gjjll setImageName:@"ic_gjjll" text:@"公积金利率" fontSize:fontSize];
    [gjjll addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.5添加“贷款计算器”
    WJGridButton *dkjsq = [[WJGridButton alloc] init];
    [gridView addSubview:dkjsq];
    self.dkjsq = dkjsq;
    dkjsq.x = gjjll.x;
    dkjsq.y = margin + CGRectGetMaxY(gjjll.frame);
    dkjsq.width = gjjll.width;
    dkjsq.height = gjjll.height;
    dkjsq.backgroundColor = WJColorDKJSQ;
    [dkjsq setImageName:@"ic_dkjsq" text:@"贷款计算器" fontSize:fontSize];
    [dkjsq addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) buttonClick:(WJGridButton *)button
{
    WJWebViewController *webVC = [[WJWebViewController alloc] init];
    NSString *title = button.titleLabel.text;
    if ([button isEqual:self.dkjsq]) {
        WJCalculatorViewController *calculatorVC = [[WJCalculatorViewController alloc] init];
        calculatorVC.title = title;
        [self.navigationController pushViewController:calculatorVC animated:YES];
    }
    else
    {
        if ([button isEqual:self.dkzn]) {  //贷款指南
            webVC.strUrl = WJUrlDKZN;
        }
        else if ([button isEqual:self.tqzn]) {   //提取指南
            webVC.strUrl = WJUrlTQZN;
        }
        else if ([button isEqual:self.kfzn]) {   //开户指南
            webVC.strUrl = WJUrlKFZN;
        }
        else if ([button isEqual:self.gjjll]) {  //公积金利率
            webVC.strUrl = WJUrlGJJLL;
        }
        webVC.title = title;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

/**
 跳转到网页
 */
- (void)runWeb : (UIButton *)btn
{
    WJWebViewController *webVC = [[WJWebViewController alloc] init];
    if ([btn isEqual:self.dkzn]) {  //贷款指南
        webVC.strUrl = WJUrlDKZN;
    }
    else if ([btn isEqual:self.tqzn]) {   //提取指南
        webVC.strUrl = WJUrlTQZN;
    }
    else if ([btn isEqual:self.kfzn]) {   //开户指南
        webVC.strUrl = WJUrlKFZN;
    }
    else if ([btn isEqual:self.gjjll]) {   //公积金利率
        webVC.strUrl = WJUrlGJJLL;
    }
    webVC.title = btn.titleLabel.text;
    [self.navigationController pushViewController:webVC animated:YES];
}

/**
 *  跳转窗体
 */
- (void)runWindow:(UIButton *)btn
{
    if ([btn isEqual:self.dkjsq]) {   //贷款计算器
        WJCalculatorViewController *calculatorVC = [[WJCalculatorViewController alloc] init];
        calculatorVC.title = btn.titleLabel.text;
        [self.navigationController pushViewController:calculatorVC animated:YES];
    }
}
@end
