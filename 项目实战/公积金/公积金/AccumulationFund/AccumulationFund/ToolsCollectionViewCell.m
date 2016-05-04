//
//  ToolsCollectionViewCell.m
//  AccumulationFund
//
//  Created by SL🐰鱼子酱 on 15/11/13.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "ToolsCollectionViewCell.h"
#import "FundReferences.h"

@interface ToolsCollectionViewCell ()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * titleLabel;

@end

@implementation ToolsCollectionViewCell

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = [UIColor colorWithRed:93/255.0 green:184/255.0 blue:196/255.0 alpha:0.5];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.bounds, point)) {
        [self touchesEnded:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = [UIColor colorWithRed:41/255.0 green:174/255.0 blue:239/255.0 alpha:0.9];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        
        NSDictionary * subviews = @{
                                    @"image" : self.imageView,
                                    @"label" : self.titleLabel
                                    };
        NSDictionary * metrics = @{
                                   @"side" : @(k_collection_cell_icon_side),
                                   @"top" : @(frame.size.height * 0.2),
                                   @"margin" : @(k_collection_cell_margin)
                                   };
        
        NSMutableArray * constraints = [NSMutableArray array];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[image(side)]-margin-[label]|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:subviews]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:k_collection_cell_icon_side]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:frame.size.width]];
        
        [self.contentView addConstraints:constraints];
        
        
    }
    return self;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _titleLabel;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    self.imageView.image = [UIImage imageNamed:icon];
}

@end
