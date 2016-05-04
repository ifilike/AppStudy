//
//  SelectionIndicator.m
//  SelectedList
//
//  Created by mac on 15/11/14.
//  Copyright © 2015年 huancun. All rights reserved.
//

#import "SelectionIndicator.h"

@implementation SelectionIndicator

static CGFloat const side = 16;
static CGFloat const inside = 8;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGRect selectionIndicatorRect = CGRectMake((rect.size.height - side) * 0.5, (rect.size.height - side) * 0.5, side, side);

    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:selectionIndicatorRect];
    [[UIColor colorWithRed:233/255.0 green:232/255.0 blue:232/255.0 alpha:1] setFill];
    [path fill];
    
    UIBezierPath * path2 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(selectionIndicatorRect.origin.x + inside * 0.5, selectionIndicatorRect.origin.y + inside * 0.5, inside, inside)];
    if (self.selected) {
        [[UIColor lightGrayColor] setFill];
    } else {
        [[UIColor colorWithRed:233/255.0 green:232/255.0 blue:232/255.0 alpha:1] setFill];
    }
    [path2 fill];
}

@end
