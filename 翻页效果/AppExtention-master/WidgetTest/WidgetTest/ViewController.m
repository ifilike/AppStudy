//
//  ViewController.m
//  WidgetTest
//
//  Created by maqj on 15/9/14.
//  Copyright (c) 2015年 maqj. All rights reserved.
//

#import "ViewController.h"
#import "ChildViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ChildViewController *childVC1 = [[ChildViewController alloc] init];
    childVC1.name = @"V1";
    ChildViewController *childVC2 = [[ChildViewController alloc] init];
    childVC2.name = @"V2";

    [self addChildViewController:childVC1];
    [self addChildViewController:childVC2];
    [self.view addSubview:childVC1.view];
    
    [childVC1 didMoveToParentViewController:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self transitionFromViewController:childVC1
                          toViewController:childVC2
                                  duration:3
                                   options:UIViewAnimationOptionTransitionCurlDown
                                animations:^{
                                    
                                } completion:^(BOOL finished) {
                                    
                                }];
        
        [childVC1 willMoveToParentViewController:nil];
        [childVC1 removeFromParentViewController];
        [childVC1.view removeFromSuperview];

    });
    
    int x = 0;
    
//    NSLog(@"%d", 120/x);
    
//    [self.navigationController popViewControllerAnimated:<#(BOOL)#>]
}

- (void)moveToV2:(id)sender{
   
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSUserDefaults *user = [[NSUserDefaults alloc] initWithSuiteName:@"group.widgetmaqj"];
    self.textLabel.text = [user objectForKey:@"kWidgetValue"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
