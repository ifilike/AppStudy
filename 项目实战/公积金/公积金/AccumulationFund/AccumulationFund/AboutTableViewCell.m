//
//  AboutTableViewCell.m
//  AccumulationFund
//
//  Created by mac on 15/11/13.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "AboutTableViewCell.h"
#import "FundReferences.h"

@interface AboutTableViewCell ()

@property (strong, nonatomic) UIImageView * iconView;
@property (strong, nonatomic) UILabel * nameLabel;

@end

@implementation AboutTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.nameLabel];

        NSDictionary *subviews = @{
                                   @"icon" : self.iconView,
                                   @"label" : self.nameLabel
                                   };
        NSDictionary * metrics = @{
                                   @"vmargin" : @(k_margin_vertical * 2),
                                   @"hmargin" : @(k_margin_horizontal * 2),
                                   @"side" : @(k_about_cell_icon_side),
                                   @"hside" : @(k_about_cell_icon_side)
                                   };
        
        NSMutableArray * constraints = [NSMutableArray array];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vmargin-[icon(side)]-vmargin-|" options:0 metrics:metrics views:subviews]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hmargin-[icon(hside)]-hmargin-[label]" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:subviews]];
        [self.contentView addConstraints:constraints];
    }
    return self;
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        _iconView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _nameLabel;
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name;
    if ([name isEqualToString:@"当前版本"]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.detailTextLabel.text = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    } else if ([name isEqualToString:@"服务热线"]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.detailTextLabel.text = @"12329";
    } else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.detailTextLabel.text = @"";
    }
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    self.iconView.image = [UIImage imageNamed:icon];
}


@end
