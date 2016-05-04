//
//  WJBadgeView.m
//  数字提醒控件
//

#import "WJBadgeView.h"

@implementation WJBadgeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setBackgroundImage:[UIImage resizedImage:@"main_badge"] forState:UIControlStateNormal];
        // 按钮的高度就是背景图片的高度
        self.height = self.currentBackgroundImage.size.height;
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = [badgeValue copy];
    
    // 设置文字
    [self setTitle:badgeValue forState:UIControlStateNormal];
    
    // 根据文字计算自己的尺寸
    CGSize titleSize = [badgeValue sizeWithFont:self.titleLabel.font];
    CGFloat bgW = self.currentBackgroundImage.size.width;
    if (titleSize.width < bgW) {
        self.width = bgW;
    } else {
        self.width = titleSize.width + 10;
    }
}

@end
