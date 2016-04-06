//
//  ViewController.m
//  cityChose
//
//  Created by babbage on 16/4/2.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ViewController.h"
#import "ZJChooseCityController.h"
#import "ZJCity.h"

@interface ViewController ()<ZJChooseCityDelegate>{
    UIButton *chooseCityBtn;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor = [UIColor yellowColor];
    chooseCityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    chooseCityBtn.center = self.view.center;
    [chooseCityBtn setTitle:@"选择城市" forState:UIControlStateNormal];
    [chooseCityBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [chooseCityBtn addTarget:self action:@selector(onClickChooseCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseCityBtn];
}
-(void)onClickChooseCity:(id)sender{
    ZJChooseCityController *cityPickerVC = [[ZJChooseCityController alloc] init];
    [cityPickerVC setDelegate:self];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityPickerVC] animated:YES completion:^{
        
    }];
}

#pragma mark ZJCityPickerDelegate
-(void)cityPickerControllerDidCancel:(ZJChooseCityController *)chooseCityController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void) cityPickerController:(ZJChooseCityController *)chooseCityController didSelectCity:(ZJCity *)city{
    [chooseCityBtn setTitle:city.cityName forState:UIControlStateNormal];
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
