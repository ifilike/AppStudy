//
//  WJHomeViewController.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/4.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJHomeViewController.h"
#import "WJWebViewController.h"
#import "WJNewsCommonViewController.h"
#import "NSDate+WJ.h"
#import "WJSysTool.h"
#import "WJGridButton.h"
#import "WJUpdateTool.h"

@interface WJHomeViewController ()
/** 我的公积金 */
@property (nonatomic, strong) WJGridButton *gjj;
/** 贷款指南 */
@property (nonatomic, strong) WJGridButton *dkzn;
/** 提取指南 */
@property (nonatomic, strong) WJGridButton *tqzn;
/** 政策法规 */
@property (nonatomic, strong) WJGridButton *zcfg;
/** 办事指南 */
@property (nonatomic, strong) WJGridButton *bszn;

@end

@implementation WJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WJGlobalBg;
    UIButton *titleView = [[UIButton alloc] init];
    titleView.width=400;
    titleView.height=44;
    [titleView setTitle:@"漳州市住房公积金管理中心" forState:UIControlStateNormal];
    [titleView.titleLabel setFont:[WJSysTool navigationTitleFont]];
    [titleView setImage:[UIImage imageNamed:@"gjj_logo32"] forState:UIControlStateNormal];
    [titleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleView setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [titleView setUserInteractionEnabled:NO];
    self.navigationItem.titleView = titleView;
    [self setup];
    
    //[WJUpdateTool CheckUpdate : NO];
}

/**
 初始化界面
 */
- (void) setup
{
    UIImageView* topView = [[UIImageView alloc] init];
    [self.view addSubview:topView];
    float topViewH = 40;  //问候语的控件高度
    float welcomeFontSize = 12;  //问候语字体大小
    float fontSize = 15;  //按钮字体大小
//    float multiple = 1;  //第一行高度与宽度的倍数
//    float multiple2 = 1;  //第二高度与宽度的倍数
    float margin = 5;   //网格间距
//    float toobarHeight = 49;  //toolbar的高度
//    WJLog(@"self.toobar.height:%f",self.tabBarController.tabBar.height);
    DeviceModel deviceModel = [WJSysTool deviceModel];
    if (deviceModel == DeviceModeliPhone5) {
        topViewH = 40;
        welcomeFontSize = 12;
        fontSize = 15;
//        multiple = 1;
//        multiple2 = 1.3;
        margin = 6;
    }
    else if (deviceModel== DeviceModeliPhone6) {
        topViewH = 44;
        welcomeFontSize = 14;
        fontSize = 17;
//        multiple = 1;
//        multiple2 = 1.4;
        margin = 7;
    }
    else if(deviceModel == DeviceModeliPhone6Plus )
    {
        topViewH = 50;
        welcomeFontSize = 16;
        fontSize = 19;
//        multiple = 1;
//        multiple2 = 1.5;
        margin = 7;
//        toobarHeight = 60;
    }
    topView.x = 0;
    topView.y = 0;
    topView.width = self.view.width;
    topView.height = topViewH;
    topView.image = [UIImage imageNamed:@"image_bg"];
    
    // 1.创建label
    UILabel *topLable = [[UILabel alloc] init];
    [self.view addSubview:topLable];
    topLable.backgroundColor = [UIColor clearColor];
    topLable.frame = topView.frame;
    topLable.numberOfLines = 0;
    topLable.font = [UIFont systemFontOfSize:welcomeFontSize];
    topLable.textColor = WJColor(122, 122, 122);
    topLable.text =[self welcomeText];
    
    // 2.创建一个大窗口GridView
    UIView *gridView = [[UIView alloc] init];
    [self.view addSubview:gridView];
    gridView.backgroundColor = [UIColor clearColor];
    gridView.x = 0;
    gridView.y = CGRectGetMaxY(topLable.frame);
    gridView.width = self.view.width;
    gridView.height = self.view.height - gridView.y - self.tabBarController.tabBar.height - 64;
//    WJLog(@"gridView.height:%f,self.view.height:%f,gridView.y:%f,toobarHeight:%f",gridView.height,self.view.height, gridView.y,toobarHeight);
    
    float colWidth = (gridView.width - margin * 3) * 0.5;
    float firstRowHeight = (gridView.height - (margin * 3)) * 0.4;
    float secondRowHeight = (gridView.height - (margin * 3)) * 0.6;
    // 往GridView容器里面添加按钮
    // 2.1添加“我的公积金”
    WJGridButton *gjj = [[WJGridButton alloc] init];
    [gridView addSubview:gjj];
    self.gjj = gjj;
    gjj.x = margin;
    gjj.y = margin;
    gjj.width = colWidth;
    gjj.height = firstRowHeight;
    gjj.backgroundColor = WJColorGJJ;
    [gjj setImageName:@"ic_my_gjj" text:@"我的公积金" fontSize:fontSize];
    [gjj addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.2添加“政策法规”
    WJGridButton *zcfg = [[WJGridButton alloc] init];
    [gridView addSubview:zcfg];
    self.zcfg = zcfg;
    zcfg.x = margin + CGRectGetMaxX(gjj.frame);
    zcfg.y = gjj.y;
    zcfg.width = colWidth;
    zcfg.height = firstRowHeight;
    zcfg.backgroundColor = WJColorZCFG;
    [zcfg setImageName:@"ic_policy" text:@"政策法规" fontSize:fontSize];
    [zcfg addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.3添加“办事指南”
    WJGridButton *bszn = [[WJGridButton alloc] init];
    [gridView addSubview:bszn];
    self.bszn = bszn;
    bszn.x = margin;
    bszn.y = margin + CGRectGetMaxY(gjj.frame);
    bszn.width = colWidth;
    bszn.height = secondRowHeight;
    bszn.backgroundColor = WJColorBSZN;
    [bszn setImageName:@"ic_loan" text:@"办事指南" fontSize:fontSize];
    [bszn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.4添加“贷款指南”
    WJGridButton *dkzn = [[WJGridButton alloc] init];
    [gridView addSubview:dkzn];
    self.dkzn = dkzn;
    dkzn.x = margin + CGRectGetMaxX(bszn.frame);
    dkzn.y = bszn.y;
    dkzn.width = colWidth;
    dkzn.height = (bszn.height - margin) * 0.5;
    dkzn.backgroundColor = WJColorDKZN;
    [dkzn setImageName:@"ic_guide" text:@"贷款指南" fontSize:fontSize];
    [dkzn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.5添加“提取指南”
    WJGridButton *tqzn = [[WJGridButton alloc] init];
    [gridView addSubview:tqzn];
    self.tqzn = tqzn;
    tqzn.x = dkzn.x;
    tqzn.y = margin + CGRectGetMaxY(dkzn.frame);
    tqzn.width = colWidth;
    tqzn.height = dkzn.height;
    tqzn.backgroundColor = WJColorTQZN;
    [tqzn setImageName:@"ic_material" text:@"提取指南" fontSize:fontSize];
    [tqzn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}


/**
 初始化界面
 */
- (void) setup2
{
    UIImageView* topView = [[UIImageView alloc] init];
    [self.view addSubview:topView];
    float topViewH = 40;  //问候语的控件高度
    float welcomeFontSize = 12;  //问候语字体大小
    float fontSize = 15;  //按钮字体大小
    float multiple = 1;  //第一行高度与宽度的倍数
    float multiple2 = 1;  //第二高度与宽度的倍数
    float margin = 5;   //网格间距
    DeviceModel deviceModel = [WJSysTool deviceModel];
    if (deviceModel == DeviceModeliPhone5) {
        topViewH = 40;
        welcomeFontSize = 12;
        fontSize = 15;
        multiple = 1;
        multiple2 = 1.3;
        margin = 6;
    }
    else if (deviceModel== DeviceModeliPhone6) {
        topViewH = 44;
        welcomeFontSize = 14;
        fontSize = 17;
        multiple = 1;
        multiple2 = 1.4;
        margin = 7;
    }
    else if(deviceModel == DeviceModeliPhone6Plus )
    {
        topViewH = 50;
        welcomeFontSize = 16;
        fontSize = 18;
        multiple = 1;
        multiple2 = 1.5;
        margin = 8;
    }
    topView.x = 0;
    topView.y = 0;
    topView.width = self.view.width;
    topView.height = topViewH;
    topView.image = [UIImage imageNamed:@"image_bg"];
    
    // 1.创建label
    UILabel *topLable = [[UILabel alloc] init];
    [self.view addSubview:topLable];
    topLable.backgroundColor = [UIColor clearColor];
    topLable.frame = topView.frame;
    topLable.numberOfLines = 0;
    topLable.font = [UIFont systemFontOfSize:welcomeFontSize];
    topLable.textColor = WJColor(122, 122, 122);
    topLable.text =[self welcomeText];
    
    // 2.创建一个大窗口GridView
    UIView *gridView = [[UIView alloc] init];
    [self.view addSubview:gridView];
    gridView.backgroundColor = [UIColor clearColor];
    gridView.x = 0;
    gridView.y = CGRectGetMaxY(topLable.frame);
    gridView.width = self.view.width;
    gridView.height = self.view.height - gridView.y;
    
    // 往GridView容器里面添加按钮
    // 2.1添加“我的公积金”
    WJGridButton *gjj = [[WJGridButton alloc] init];
    [gridView addSubview:gjj];
    self.gjj = gjj;
    gjj.x = margin;
    gjj.y = margin;
    gjj.width = (gridView.width - margin * 3) * 0.5;
    gjj.height = gjj.width * multiple;
    gjj.backgroundColor = WJColorGJJ;
    [gjj setImageName:@"ic_my_gjj" text:@"我的公积金" fontSize:fontSize];
    [gjj addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.2添加“政策法规”
    WJGridButton *zcfg = [[WJGridButton alloc] init];
    [gridView addSubview:zcfg];
    self.zcfg = zcfg;
    zcfg.x = margin + CGRectGetMaxX(gjj.frame);
    zcfg.y = gjj.y;
    zcfg.width = gjj.width;
    zcfg.height = zcfg.width * multiple;
    zcfg.backgroundColor = WJColorZCFG;
    [zcfg setImageName:@"ic_policy" text:@"政策法规" fontSize:fontSize];
    [zcfg addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.3添加“办事指南”
    WJGridButton *bszn = [[WJGridButton alloc] init];
    [gridView addSubview:bszn];
    self.bszn = bszn;
    bszn.x = margin;
    bszn.y = margin + CGRectGetMaxY(gjj.frame);
    bszn.width = gjj.width;
    bszn.height = bszn.width * multiple2;
    bszn.backgroundColor = WJColorBSZN;
    [bszn setImageName:@"ic_loan" text:@"办事指南" fontSize:fontSize];
    [bszn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.4添加“贷款指南”
    WJGridButton *dkzn = [[WJGridButton alloc] init];
    [gridView addSubview:dkzn];
    self.dkzn = dkzn;
    dkzn.x = margin + CGRectGetMaxX(bszn.frame);
    dkzn.y = bszn.y;
    dkzn.width = bszn.width;
    dkzn.height = (bszn.height - margin) * 0.5;
    dkzn.backgroundColor = WJColorDKZN;
    [dkzn setImageName:@"ic_guide" text:@"贷款指南" fontSize:fontSize];
    [dkzn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2.5添加“提取指南”
    WJGridButton *tqzn = [[WJGridButton alloc] init];
    [gridView addSubview:tqzn];
    self.tqzn = tqzn;
    tqzn.x = dkzn.x;
    tqzn.y = margin + CGRectGetMaxY(dkzn.frame);
    tqzn.width = dkzn.width;
    tqzn.height = dkzn.height;
    tqzn.backgroundColor = WJColorTQZN;
    [tqzn setImageName:@"ic_material" text:@"提取指南" fontSize:fontSize];
    [tqzn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) buttonClick:(WJGridButton *)button
{
    if ([button isEqual:self.gjj]) {   //我的公积金
        WJWebViewController *webVC = [[WJWebViewController alloc] init];
        webVC.strUrl = WJUrlGJJ;
        webVC.title = button.titleLabel.text;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if ([button isEqual:self.dkzn]) {  //贷款指南
        WJWebViewController *webVC = [[WJWebViewController alloc] init];
        webVC.strUrl = WJUrlDKZN;
        webVC.title = button.titleLabel.text;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if ([button isEqual:self.tqzn]) {   //提取指南
        WJWebViewController *webVC = [[WJWebViewController alloc] init];
        webVC.strUrl = WJUrlTQZN;
        webVC.title = button.titleLabel.text;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if ([button isEqual:self.zcfg]) {   //政策法规
        WJNewsCommonViewController *newsVC = [[WJNewsCommonViewController alloc] init];
        newsVC.lmid = @5;
        newsVC.title = button.titleLabel.text;
        [self.navigationController pushViewController:newsVC animated:YES];
    }
    else if ([button isEqual:self.bszn]) {  //办事指南
        WJNewsCommonViewController *newsVC = [[WJNewsCommonViewController alloc] init];
        newsVC.lmid = @7;
        newsVC.title = button.titleLabel.text;
        [self.navigationController pushViewController:newsVC animated:YES];
    }
}
/**
 *  获得问候语
 */
- (NSString *)welcomeText
{
    NSDate *date = [NSDate date];
    int hour  = [date dateWithHour];
    if (hour >=6 && hour < 8) {
        return @"   尊敬的用户，早上好！\n   欢迎使用漳州市掌上住房公积金";
    }
    else if (hour >=8 && hour < 11)
    {
        return @"   尊敬的用户，上午好！\n   欢迎使用漳州市掌上住房公积金";
    }
    else if (hour >=11 && hour < 13)
    {
        return @"   尊敬的用户，中午好！\n   欢迎使用漳州市掌上住房公积金";
    }
    else if (hour >=13 && hour < 18)
    {
        return @"   尊敬的用户，下午好！\n   欢迎使用漳州市掌上住房公积金";
    }
    else
    {
        return @"   尊敬的用户，晚上好！\n   欢迎使用漳州市掌上住房公积金";
    }
}

@end
