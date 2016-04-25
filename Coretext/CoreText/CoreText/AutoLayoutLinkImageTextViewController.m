//
//  AutoLayoutLinkImageTextViewController.m
//  CoreText
//
//  Created by babbage on 16/4/18.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "AutoLayoutLinkImageTextViewController.h"
#import "ZJAttributeLabel.h"
#import "RegexKitLite.h"

@interface AutoLayoutLinkImageTextViewController ()<ZJAttributeLabelDelegate>
@property (nonatomic, strong) ZJAttributeLabel *label1;
@property (nonatomic, strong) ZJAttributeLabel *label2;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

#define RGB(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation AutoLayoutLinkImageTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addScrollView];
    
    [self addClickAttributedLabel];
    // appendAttributedText
    [self addTextAttributedLabel1];
    
    [self layoutAttributedLabel];
}

- (void)addScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
}

- (void)addClickAttributedLabel
{
    ZJAttributeLabel *label = [ZJAttributeLabel new];
    [label appendLinkWithText:@"Try Click Here to add some randomˊ_>ˋ" linkFont:[UIFont systemFontOfSize:30] linkData:nil];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.delegate = self;
    _label1 = label;
}

- (void)layoutAttributedLabel
{
    [self.scrollView addSubview:self.label1];
    [self.scrollView addSubview:self.label2];
    
    self.label1.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame);
    self.label2.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame);
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[label1]-0-|" options:0 metrics:nil views:@{@"label1":self.label1}]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[label2]-0-|" options:0 metrics:nil views:@{@"label2":self.label2}]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[label1]-[label2]-0-|" options:0 metrics:nil views:@{@"label1":self.label1, @"label2":self.label2}]];
}

// appendAttributedText
- (void)addTextAttributedLabel1
{
    ZJAttributeLabel *label = [[ZJAttributeLabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0)];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    _label2 = label;
}

- (void)appendTextToLabel:(ZJAttributeLabel *)label
{
    NSString *text = @"\t总有一天你将破蛹而出，成长得比人们期待的还要美丽。\n\t但这个过程会很痛，会很辛苦，有时候还会觉得灰心。\n\t面对着汹涌而来的现实，觉得自己渺小无力。\n\t但这，也是生命的一部分，做好现在你能做的，然后，一切都会好的。\n\t我们都将孤独地长大，不要害怕。";
    
    // 分割文本到数组
    NSArray *textArray = [text componentsSeparatedByString:@"\n\t"];
    NSArray *colorArray = @[RGB(213, 0, 0, 1),RGB(0, 155, 0, 1),RGB(103, 0, 207, 1),RGB(209, 162, 74, 1),RGB(206, 39, 206, 1)];
    
    NSInteger index = 0;
    
    for (NSString *text in textArray) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
        
        if (index != 4) {
            // 添加属性
            [attributedString addAttributeTextColor:colorArray[index%5]];
            [attributedString addAttributeFont:[UIFont systemFontOfSize:15+arc4random()%4]];
            
            // 追加(添加到最后)文本
            [label appendTextAttributedString:attributedString];
            [label appendImageWithName:@"haha"];
            [label appendText:@"\n\t"];
        } else {
            [label appendImageWithName:@"avatar" size:CGSizeMake(60, 60)];
            [label appendText:text];
        }
        index++;
    }
}

- (void)appendImageToLabel:(ZJAttributeLabel *)label
{
    // 追加 图片Url
    ZJImageStorage *imageUrlStorage = [[ZJImageStorage alloc]init];
    imageUrlStorage.imageURL = [NSURL URLWithString:@"http://imgbdb2.bendibao.com/beijing/201310/21/2013102114858726.jpg"];
    imageUrlStorage.size = CGSizeMake(CGRectGetWidth(label.frame), 343*CGRectGetWidth(label.frame)/600);
    [label appendTextStorage:imageUrlStorage];
}

#pragma mark - deleagte

- (void)attributedLabel:(ZJAttributeLabel *)attributedLabel textStorageClicked:(id<ZJTextStorageProtocol>)textStorage atPoint:(CGPoint)point
{
    BOOL addText = arc4random()%2;
    ZJAttributeLabel *addedLabel = (arc4random()%2==0)?self.label1:self.label2;
    if (addText) {
        [self appendTextToLabel:addedLabel];
    } else {
        [self appendImageToLabel:addedLabel];
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
