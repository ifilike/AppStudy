//
//  ZJCityGroupCell.m
//  cityChose
//
//  Created by babbage on 16/4/2.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ZJCityGroupCell.h"
#import "ZJCity.h"

@implementation ZJCityGroupCell

- (void)awakeFromNib {
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.noDataLabel];
    }
    return self;
}
#pragma mark -Getter
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _titleLabel;
}
-(UILabel *)noDataLabel{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        [_noDataLabel setText:@"暂无数据"];
        [_noDataLabel setTextColor:[UIColor grayColor]];
        [_noDataLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _noDataLabel;
}
-(NSMutableArray *)arrayCityButtons{
    if (!_arrayCityButtons) {
        _arrayCityButtons = [[NSMutableArray alloc] init];
    }
    return _arrayCityButtons;
}
- (void) setCityArray:(NSArray *)cityArray{
    _cityArray = cityArray;
    [self.noDataLabel setHidden:(cityArray != nil && cityArray.count > 0)];
    
    for (int i = 0; i < cityArray.count; i ++) {
        ZJCity *city = [cityArray objectAtIndex:i];
        UIButton *button = nil;
        if (i < self.arrayCityButtons.count) {
            button = [self.arrayCityButtons objectAtIndex:i];
        }else{
            button = [[UIButton alloc] init];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:2.0f];
            [button.layer setBorderColor:[[UIColor colorWithWhite:0.8 alpha:1.0] CGColor]];
            [button addTarget:self action:@selector(cityButtonDown:) forControlEvents:UIControlEventTouchUpInside];
            [self.arrayCityButtons addObject:button];
            [self addSubview:button];
        }
        [button setTitle:city.cityName forState:UIControlStateNormal];
        button.tag = i;
    }
    while (cityArray.count < self.arrayCityButtons.count) {
        [self.arrayCityButtons removeAllObjects];
    }
}
#pragma mark - Event Response
-(void)cityButtonDown:(UIButton *)sender{
    //点击button事件
    ZJCity *city = [self.cityArray objectAtIndex:sender.tag];
    if (_delegate && [_delegate respondsToSelector:@selector(cityGroupCellDidSelectCity:)]) {
        [_delegate cityGroupCellDidSelectCity:city];
    }
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    float x = WIDTH_LEFT;
    float y = 5;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [self.titleLabel setFrame:CGRectMake(x, y, self.frame.size.width - x, size.height)];
    y += size.height + 3;
    [self.noDataLabel setFrame:CGRectMake(x+5, y, self.frame.size.width - x - 5, self.titleLabel.frame.size.height)];
    
    y += 7;
    float space = MIN_SPACE;        //最小间隙
    float width = MIN_WIDTH_BUTTON;//button最小宽度
    int t = (self.frame.size.width - WIDTH_LEFT - WIDTH_RIGHT + space)/(width +space);
    
    //修正空隙宽度
    space = (self.frame.size.width - WIDTH_LEFT - WIDTH_RIGHT - width *t)/(t - 1);
    
    if (space > MAX_SPACE) {                                                  // 修正button宽度
        width += (space - MAX_SPACE) * (t - 1) / t;
        space = MAX_SPACE;
    }
    //button layoutSubView
    for (int i = 0; i < self.arrayCityButtons.count; i ++ ) {
        UIButton *button = [self.arrayCityButtons objectAtIndex:i];
        [button setFrame:CGRectMake(x, y, width, HEIGHT_BUTTON)];
        if ((i + 1) % t == 0) {
            y += HEIGHT_BUTTON + 5;
            x = WIDTH_LEFT;
        }else{
            x += width + space;
        }
    }
}
+(CGFloat)getCellHeightOfCityArray:(NSArray *)cityArray{
    float h = 30;
    if (cityArray != nil && cityArray.count > 0) {
        float space = MIN_SPACE;
        float width = MIN_WIDTH_BUTTON;
        int t = ([UIScreen mainScreen].bounds.size.width - WIDTH_LEFT - WIDTH_RIGHT +space)/(width + space);
        space = ([UIScreen mainScreen].bounds.size.width - WIDTH_LEFT - WIDTH_RIGHT - width * t)/(t  - 1);//修正空隙宽度
       
        if (space > MAX_SPACE) {
            width += (space - MAX_SPACE)*(t - 1) / t;
            space = MAX_SPACE;
        }
        h += (10 + (HEIGHT_BUTTON + 5)*(cityArray.count / t + (cityArray.count % t == 0?0:1)));
    }else{
        h += 17;
    }
    return h;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
