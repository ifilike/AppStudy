//
//  WJCalculatorCell.m
//  漳州公积金
//
//  Created by fengwujie on 16/1/6.
//  Copyright © 2016年 vision-soft. All rights reserved.
//

#import "WJNewsCommonCell.h"
#import "WJNews.h"
@implementation WJNewsCommonCell

#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"Calculator";
    WJNewsCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WJNewsCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置标题的字体
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        
        // 去除cell的默认背景色
        self.backgroundColor = [UIColor clearColor];
        
        // 设置背景view
        self.backgroundView = [[UIImageView alloc] init];
        self.selectedBackgroundView = [[UIImageView alloc] init];
    }
    return self;
}

- (void)setNews:(WJNews *)news{
    _news = news;
    self.textLabel.text = news.FTitle;
    self.detailTextLabel.text = news.cIndate;
}

#pragma mark - 调整子控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //    if ([self.item isKindOfClass:[WJCommonCenterItem class]]) {
    //        self.textLabel.centerX = self.width * 0.5;
    //        self.textLabel.centerY = self.height * 0.5;
    //    } else {
    //        self.textLabel.x = 10;
    if (self.news) {
        if (self.news.Indate) {
            self.detailTextLabel.width = 100;
            self.detailTextLabel.x = self.width - self.detailTextLabel.width - 10;
            self.textLabel.width = self.width - self.detailTextLabel.width - 25;
//            WJLog(@"textLabel.width--%f,self.width--%f,detailTextLabel.width---%f",self.textLabel.width,self.width,self.detailTextLabel.width);
//            if ((self.textLabel.width) > (self.width - self.detailTextLabel.width - 10)) {
//                self.textLabel.width = self.textLabel.width - self.detailTextLabel.width - 5;
//                return;
//            }
        }
    }
//    // 调整子标题的x
//    self.detailTextLabel.x = CGRectGetMaxX(self.textLabel.frame) + 5;
    //    }
}

#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(NSUInteger)rows
{
    // 1.取出背景view
    UIImageView *bgView = (UIImageView *)self.backgroundView;
    UIImageView *selectedBgView = (UIImageView *)self.selectedBackgroundView;
    
    // 2.设置背景图片
    if (rows == 1) {
        bgView.image = [UIImage resizedImage:@"common_card_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_background_highlighted"];
    } else if (indexPath.row == 0) { // 首行
        bgView.image = [UIImage resizedImage:@"common_card_top_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_top_background_highlighted"];
    } else if (indexPath.row == rows - 1) { // 末行
        bgView.image = [UIImage resizedImage:@"common_card_bottom_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted"];
    } else { // 中间
        bgView.image = [UIImage resizedImage:@"common_card_middle_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_middle_background_highlighted"];
    }
}


@end
