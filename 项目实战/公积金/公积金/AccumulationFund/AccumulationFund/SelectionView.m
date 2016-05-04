//
//  SelectionView.m
//  SelectedList
//
//  Created by mac on 15/11/14.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "SelectionView.h"
#import "SelectionIndicator.h"
#import "SelectionMultipleIndicator.h"



@interface SelectionView ()

@property (strong, nonatomic) UIView * indicatorView;

@end

@implementation SelectionView

- (instancetype)init {
    self = [self initWithType:SelectionViewTypeSingleSelection];
    if (self != nil) {
    }
    return self;
}

- (instancetype)initWithType:(SelectionViewType)type {
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        if (type == SelectionViewTypeSingleSelection) {
            self.indicatorView = [[SelectionIndicator alloc] init];
        } else if (type == SelectionViewTypeMultipleIndicator) {
            self.indicatorView = [[SelectionMultipleIndicator alloc] init];
        } else {
            NSAssert(0, @"SelectionView -> initWithType: Crash");
        }
        
        [self addSubview:self.indicatorView];
        [self addSubview:self.textLabel];
        
        NSMutableArray * constraints = [NSMutableArray array];
        
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-5]];
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self addConstraints:constraints];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        [self.indicatorView setValue:@(selected) forKey:@"selected"];
        if ([self.delegate respondsToSelector:@selector(selection:didChangeSelected:)]) {
            [self.delegate selection:self didChangeSelected:selected];
        }
    }
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
    }
    return _textLabel;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.indicatorView.backgroundColor = backgroundColor;
}



@end
