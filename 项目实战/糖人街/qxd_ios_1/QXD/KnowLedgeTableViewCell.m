//
//  KnowLedgeTableViewCell.m
//  QXD
//
//  Created by wzp on 16/1/27.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "KnowLedgeTableViewCell.h"
#import "MyIdeaWebView.h"
#import "FoundModel.h"

@implementation KnowLedgeTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.konwLedgeView=[[MyIdeaWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
        [self addSubview:_konwLedgeView];
        
    }
    return self;
}

- (void)setFoundModel:(FoundModel*)model withHeight:(float)height{
    
    //设置行间距
//    NSString *webviewText = @"<style>body{line-height: 25px}</style>";
    NSString *webviewText = @"<style>body{font:14px/24px Custom-Font-Name;}</style>";

    NSString *htmlString = [webviewText stringByAppendingFormat:@"%@", model.content];
    

    
    [_konwLedgeView loadDataWithHTMLString:htmlString];
    
    [_konwLedgeView changeFrameWithHeight:height];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
