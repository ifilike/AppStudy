//
//  ParseTextViewController.m
//  CoreText
//
//  Created by babbage on 16/4/18.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ParseTextViewController.h"
#import "ZJAttributeLabel.h"
#import "ZJTextStorageParser.h"


@interface ParseTextViewController ()<ZJAttributeLabelDelegate>
@property (nonatomic, weak) ZJAttributeLabel *label;

@end

@implementation ParseTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTextAttributedLabel];
    
    // jsonPath
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    
    // parseJson
    [self parseJsonFileWithPath:path];
    
    [_label sizeToFit];

}

- (void)addTextAttributedLabel
{
    ZJAttributeLabel *label = [[ZJAttributeLabel alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 0)];
    label.delegate = self;
    [self.view addSubview:label];
    _label = label;
}

- (void)parseJsonFileWithPath:(NSString *)filePath
{
    NSArray *textStorageArray = [ZJTextStorageParser parseWithJsonFilePath:filePath];
    
    if (textStorageArray.count > 0) {
        [_label appendTextStorageArray:textStorageArray];
    }
}

#pragma mark - TYAttributedLabelDelegate

- (void)attributedLabel:(ZJAttributeLabel *)attributedLabel textStorageClicked:(id<ZJTextStorageProtocol>)TextStorage atPoint:(CGPoint)point
{
    NSLog(@"textStorageClickedAtPoint");
    if ([TextStorage isKindOfClass:[ZJLinkTextStorage class]]) {
        NSString *linkStr = ((ZJLinkTextStorage*)TextStorage).linkData;
        
        if ([linkStr hasPrefix:@"http"]) {
            [ [ UIApplication sharedApplication] openURL:[ NSURL URLWithString:linkStr]];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:linkStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void)attributedLabel:(ZJAttributeLabel *)attributedLabel textStorageLongPressed:(id<ZJTextStorageProtocol>)textStorage onState:(UIGestureRecognizerState)state atPoint:(CGPoint)point
{
    NSLog(@"textStorageLongPressed");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
