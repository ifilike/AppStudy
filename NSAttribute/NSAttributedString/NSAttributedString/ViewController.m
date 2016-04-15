//
//  ViewController.m
//  NSAttributedString
//
//  Created by babbage on 16/4/13.
//  Copyright © 2016年 babbage. All rights reserved.:smile:
//

#import "ViewController.h"
#import "NSString+Emoji.h"

#import "Utility.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self SystemEmoji];//系统表情相互转化测试 上传服务器之前转化，或者展示之前转化即可。
    
    //自定义表情，发送的可以根据用户点击的第一个cell然后给命名为[EmojiImage001];
    //从服务器获取[EmojiImage001]之后就可以使用下面的方法来展示
//    [self CustomEmoji];
    
    //上面的是表情（表情表达式） 和自定义表情（图片） 原理是用表情（或者图片）替代文字或者用文字替代表情（或者图片）
    //值得学习的是NSString+Emoji和Utility
    //下面的是NSAttributedString方法的简单实用使用
    [self NSAttributedStringUse];
    
    
}



#pragma mark --NSAttributedString--
-(void)NSAttributedStringUse{
    //Label 自适应高度
    NSString *string = @"Label的自适应高度，当Label的字符串长度很少的时候可以计算宽度，当很长的时候自动换行，宽度为你所定义的宽度，高度自适应，可以打印出宽高";
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:10.0];
    label.numberOfLines = 0;
    label.text = string;
    
//    [self NSAttributedStringText1:label string:string];//这个方法原理：字符串长度决定宽高然后从新赋值宽高
    [self NSAttributedStringText2:label string:string LineSpaceing:10 LabelFont:30];
    
    [self.view addSubview:label];
}
#pragma mark 字体行间距--NSAttributedString
-(void)NSAttributedStringText2:(UILabel *)label string:(NSString *)string LineSpaceing:(CGFloat)lineSpacing LabelFont:(CGFloat)labelFont{
    
    label.font = [UIFont systemFontOfSize:labelFont];

    //删除线颜色，字体颜色，
    NSDictionary *attributedDictory = @{NSFontAttributeName:[UIFont systemFontOfSize:labelFont],
                                        NSForegroundColorAttributeName:[UIColor redColor],
                                        NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                        NSStrikethroughColorAttributeName:[UIColor blueColor]};
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:string attributes:attributedDictory];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineSpacing:lineSpacing];
    [attributed addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, string.length)];//行间距
    [attributed addAttribute:NSKernAttributeName value:@(10.0f) range:NSMakeRange(0, string.length)];//字间距
    [attributed addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, string.length)];//下划线
    
    label.backgroundColor = [UIColor yellowColor];
    
    label.attributedText = attributed;

    //    [self sizeToFit:label labelFont:labelFont lineSpace:lineSpacing];//sizeToFit
    
        [self sizeThatFits:label labelFont:labelFont lineSpace:lineSpacing];//sizeThatFit
}

#pragma mark 自适应高度--sizeTahtFits--
-(void)sizeThatFits:(UILabel *)label labelFont:(CGFloat)labelFont lineSpace:(CGFloat)lineSpacing{
    
    //2.  不需要给label的frame进行赋值，因为在后面我们需要给一个size模板进行Fit
        CGSize size = CGSizeMake(375, MAXFLOAT);
        CGSize labelSize = [label sizeThatFits:size];//
    
    /**
    *  求label的行数目 只能粗略的计算label的行数 上下各留十一之一的间距
    */
    int labelHeithg = (int)labelSize.height;
    int font = labelFont * 1.2;
    NSInteger number = 0;
    if ( labelHeithg % font == 0) {
        number = labelHeithg / font;
    }else{
        number = 1 + labelHeithg / font;
    }
    
//    label.frame = CGRectMake(0, 120, labelSize.width, labelSize.height + number *lineSpacing);//无效测试
     label.frame = CGRectMake(0, 120, labelSize.width, labelSize.height);
}
#pragma mark 自适应高度--sizeToFits--
-(void)sizeToFit:(UILabel *)label labelFont:(CGFloat)labelFont lineSpace:(CGFloat)lineSpacing{
    label.frame = CGRectMake(0, 30, 200, 0);//当时用sizeToFit时候需要这个按照这个进行Fit
    
    //1. sizeToFit  需要给label.frame赋值，sizeToFit改变label的frame而sizeThatFit没有改变frame
    [label sizeToFit];//当使用这个方法时候，首先要给label的frame赋值，不然不知道按照什么样的size进行Fit。
    //    label.frame = CGRectMake(0, 30, 200, label.frame.size.height );//当有行间距时候这个不准确
    
    /**
     *  求label的行数目 只能粗略的计算label的行数 上下各留十一之一的间距
     *  这个不需要 只要放在最后面就不需要了 
     */
    int labelHeithg = (int)label.frame.size.height;
    int font = labelFont * 1.2;
    NSInteger number = 0;
    if ( labelHeithg % font == 0) {
        number = labelHeithg / font;
    }else{
        number = 1 + labelHeithg / font;
    }
//    label.frame = CGRectMake(0, 30, 200, label.frame.size.height + number *lineSpacing);//无效测试
    label.frame = CGRectMake(0, 30, 200, label.frame.size.height);
    
}

#pragma mark 自适应高度--Size方法--Rect方法--
-(void)NSAttributedStringText1:(UILabel *)label string:(NSString *)string{
    //当定义好了label的宽高时候，你打印的就是宽高，不会随着字符串的长度改变，可以使用重新计算string应该占用的宽高 然后再给label重新赋上frame 故不需要给frame赋值
    CGSize size = [string sizeWithFont:label.font constrainedToSize:CGSizeMake(200, 200)];
    NSLog(@"size.width:%f,size.heiht:%f",size.width,size.height);//此时的宽高由字符串来决定的
    
    //上面的方法更新为下面的方法 优化了无法修改字符串颜色等方法
    CGRect rect = [string boundingRectWithSize:CGSizeMake(200, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil];
    NSLog(@"rect.size.width:%f rect.size.width:%f",rect.size.width,rect.size.height);
    
    
    label.frame = CGRectMake(0, 20, size.width, size.height);
}

#pragma mark 自定义表情---文字转表情-见下面的方法，表情转文字-用collectionView点击的cell来打印文字
-(void)CustomEmoji{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 375, 40)];
    NSString *text = @"zhuye[主页]gognyi[公益]xingmu[项目]zhuye";
    NSMutableAttributedString *attribute = [Utility emotionStrWithString:text];
//    NSMutableAttributedString *attribute = [Utility emotionStrWithString:text plistName:@"emoticons.plist" y:10];
//    NSMutableAttributedString *attribute = [Utility exchangeString:@"zhuye" withText:text imageName:@"welfareSelected"];
    label.attributedText = attribute;
    [self.view addSubview:label];
}
#pragma mark 系统表情--下面是个测试
-(void)SystemEmoji{
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 375, 200)];
    text.layer.borderWidth = 1;
    text.delegate = self;
    [self.view addSubview:text];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark 系统表情--测试打印，
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
//    NSLog(@"_%@",[textField.text stringByReplacingEmojiCheatCodesWithUnicode]);
    NSLog(@"_%@",[textField.text stringByReplacingEmojiUnicodeWithCheatCodes]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
