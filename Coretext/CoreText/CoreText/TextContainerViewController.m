//
//  TextContainerViewController.m
//  CoreText
//
//  Created by babbage on 16/4/18.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "TextContainerViewController.h"
#import "RegexKitLite.h"
#import "ZJAttributeLabel.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "TExamTextField.h"


@interface TextContainerViewController ()<ZJAttributeLabelDelegate>
@property (nonatomic,strong) ZJAttributeLabel *label;
@property (nonatomic,strong) ZJTextContainer *textContainer;
@property (nonatomic,strong) NSAttributedString *attString;
@property (nonatomic,weak) TPKeyboardAvoidingScrollView *scrollView;

@property (nonatomic,strong) NSArray *answerArray;
@end

#define RGB(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kExamTextFieldWidth 80
#define kExamTextFieldHeight 20
#define kAttrLabelWidth (CGRectGetWidth(self.view.frame)-20)
#define kTextFieldTag 1000

@implementation TextContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _answerArray = @[@"白露为霜",@"所谓伊人",@"道阻且跻",@"蒹葭采采",@"白露未已",@"宛在水中沚",@"企慕"];
    [self createTextContainer];
    
    [self addScrollView];
    
    [self addTextAttributedLabel];
    
    [self addSubmitAnswerBtn];
}
- (void)addScrollView
{
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
}

- (void)createTextContainer
{
    NSString *text = @"<img>蒹葭-云歌\n蒹葭苍苍，[@]。所谓伊人，在水一方。溯洄从之，道阻且长，溯游从之，宛在水中央。\n蒹葭萋萋，白露未晞。[@]，在水之湄。溯洄从之，[@]。溯游从之，宛在水中坻。\n[@]，[@]。所谓伊人，在水之涘。溯洄从之，道阻且右。溯游从之，[@]。\n注解:\n《蒹葭》，[haha]出自《诗经·国风·秦风》，是一首描写对意中人深深的[@]和求而不得的惆怅的诗。\n";
    
    // 属性文本生成器
    ZJTextContainer *textContainer = [[ZJTextContainer alloc]init];
    textContainer.text = text;
    
    // 文字样式
    ZJTextStorage *textStorage = [[ZJTextStorage alloc]init];
    textStorage.range = [text rangeOfString:@"蒹葭"];
    textStorage.font = [UIFont systemFontOfSize:18];
    textStorage.textColor = RGB(206, 39, 206, 1);
    [textContainer addTextStorage:textStorage];
    
    // 文字样式
    ZJTextStorage *textStorage1 = [[ZJTextStorage alloc]init];
    textStorage1.range = [text rangeOfString:@"注解:"];
    textStorage1.font = [UIFont systemFontOfSize:17];
    textStorage1.textColor = RGB(209, 162, 74, 1);
    [textContainer addTextStorage:textStorage1];
    
    // 下划线文字
    ZJLinkTextStorage *linkTextStorage = [[ZJLinkTextStorage alloc]init];
    linkTextStorage.range = [text rangeOfString:@"《蒹葭》"];
    linkTextStorage.linkData = @"点击了 《蒹葭》";
    [textContainer addTextStorage:linkTextStorage];
    
    ZJLinkTextStorage *linkTextStorage1 = [[ZJLinkTextStorage alloc]init];
    linkTextStorage1.range = [text rangeOfString:@"《诗经·国风·秦风》"];
    linkTextStorage1.linkData = @"点击了 《诗经·国风·秦风》";
    [textContainer addTextStorage:linkTextStorage1];
    
    // url图片
    ZJImageStorage *imageUrlStorage = [[ZJImageStorage alloc]init];
    imageUrlStorage.range = [text rangeOfString:@"<img>"];
    imageUrlStorage.imageURL = [NSURL URLWithString:@"http://imgbdb2.bendibao.com/beijing/201310/21/2013102114858726.jpg"];
    imageUrlStorage.size = CGSizeMake(kAttrLabelWidth, 343*kAttrLabelWidth/600);
    [textContainer addTextStorage:imageUrlStorage];
    
    // image图片
    ZJImageStorage *imageStorage = [[ZJImageStorage alloc]init];
    imageStorage.range = [text rangeOfString:@"[haha]"];
    imageStorage.imageName = @"haha";
    imageStorage.size = CGSizeMake(15, 15);
    [textContainer addTextStorage:imageStorage];
    
    // 填空题
    NSArray *blankStorage = [self.class parseTextFieldsWithString:text];
    [textContainer addTextStorageArray:blankStorage];
    
    // 生成 NSAttributedString
    //_attString = [textContainer createAttributedString];
    
    // 或者 生成 TYTextContainer
    _textContainer = [textContainer createTextContainerWithTextWidth:kAttrLabelWidth];
    
}

// 解析填空
+ (NSArray *)parseTextFieldsWithString:(NSString *)string
{
    NSMutableArray *textFieldArray = [NSMutableArray array];
    [string enumerateStringsMatchedByRegex:@"\\[@\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if (captureCount > 0) {
            TExamTextField *textField = [[TExamTextField alloc]initWithFrame:CGRectMake(0, 0, kExamTextFieldWidth, kExamTextFieldHeight)];
            textField.textColor = [UIColor colorWithRed:255.0/255 green:155.0/255 blue:26.0/255 alpha:1];
            textField.textAlignment = NSTextAlignmentCenter;
            textField.font = [UIFont systemFontOfSize:16];
            ZJViewStorage *viewStorage = [[ZJViewStorage alloc]init];
            viewStorage.range = capturedRanges[0];
            viewStorage.view = textField;
            viewStorage.tag = kTextFieldTag + textFieldArray.count;;
            
            [textFieldArray addObject:viewStorage];
        }
    }];
    
    return textFieldArray.count > 0 ?[textFieldArray copy] : nil;
}

- (void)addTextAttributedLabel
{
    ZJAttributeLabel *label = [[ZJAttributeLabel alloc]initWithFrame:CGRectMake(10, 0, kAttrLabelWidth, 0)];
    [_scrollView addSubview:label];
    _label = label;
    label.delegate = self;
    
    label.textContainer = _textContainer;
    
    // 或者设置 attString
    //label.attributedText = _attString;
    
    [label sizeToFit];
    
    [_scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(label.frame)+10)];
}

- (void)addSubmitAnswerBtn
{
    UIButton *submitAnswerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitAnswerBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 100 -20, CGRectGetMaxY(_label.frame)+15, 100, 32);
    [submitAnswerBtn setTitle:@"提交答案" forState:UIControlStateNormal];
    [submitAnswerBtn setTitle:@"重新作答" forState:UIControlStateSelected];
    submitAnswerBtn.backgroundColor = RGB(80, 180, 20, 1);
    [submitAnswerBtn addTarget:self action:@selector(checkAnswerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:submitAnswerBtn];
    
    [_scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(submitAnswerBtn.frame)+20)];
}

#pragma mark - action

- (void)checkAnswerAction:(UIButton *)sender
{
    __typeof (self) __weak weakSelf = self;
    if (!sender.isSelected) {
        [self enumerateTextFieldStorageUseBlock:^(ZJViewStorage *viewStorage) {
            if (viewStorage.tag >= kTextFieldTag && viewStorage.tag - kTextFieldTag < _answerArray.count ) {
                [weakSelf judgeTextFieldState:(TExamTextField *)viewStorage.view answer:_answerArray[viewStorage.tag - kTextFieldTag]];
            }
        }];
    }else {
        [self enumerateTextFieldStorageUseBlock:^(ZJViewStorage *viewStorage) {
            [weakSelf resetTextFieldState:(TExamTextField *)viewStorage.view];
        }];
    }
    sender.selected = !sender.isSelected;
}

// 遍历出 textfiled
- (void)enumerateTextFieldStorageUseBlock:(void(^)(ZJViewStorage *viewStorage))block
{
    for (ZJTextStorage *textStorage in _textContainer.textStorages) {
        if ([textStorage isKindOfClass:[ZJViewStorage class]]) {
            ZJViewStorage *viewStorage = (ZJViewStorage *)textStorage;
            if ([viewStorage.view isKindOfClass:[TExamTextField class]]) {
                if (block) {
                    block(viewStorage);
                }
            }
        }
    }
}

// 判断 对错
- (void)judgeTextFieldState:(TExamTextField *)textField answer:(NSString *)answer
{
    // 判断对错
    if ([textField.text isEqualToString: answer]) {
        textField.examState = TExamTextFieldStateCorrect;
    }else {
        textField.examState = TExamTextFieldStateError;
    }
}

// 重置textfield
- (void)resetTextFieldState:(TExamTextField *)textField
{
    textField.text = nil;
    textField.examState = TExamTextFieldStateNormal;
}

#pragma mark - delegate

- (void)attributedLabel:(ZJAttributeLabel *)attributedLabel textStorageClicked:(id<ZJTextStorageProtocol>)TextRun atPoint:(CGPoint)point
{
    NSLog(@"textStorageClickedAtPoint");
    if ([TextRun isKindOfClass:[ZJLinkTextStorage class]]) {
        
        id linkStr = ((ZJLinkTextStorage*)TextRun).linkData;
        if ([linkStr isKindOfClass:[NSString class]]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:linkStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }else if ([TextRun isKindOfClass:[ZJImageStorage class]]) {
        ZJImageStorage *imageStorage = (ZJImageStorage *)TextRun;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"点击提示" message:[NSString stringWithFormat:@"你点击了%@图片",imageStorage.imageName? imageStorage.imageName: imageStorage.imageURL] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
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
