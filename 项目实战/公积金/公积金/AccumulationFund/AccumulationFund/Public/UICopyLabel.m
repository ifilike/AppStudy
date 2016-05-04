//
//  UICopyLabel.m
//  AccumulationFund
//
//  Created by mac on 15/12/17.
//  Copyright © 2015年 huancun. All rights reserved.

#import "UICopyLabel.h"

@implementation UICopyLabel





-(BOOL)canBecomeFirstResponder {
    return YES;
}


// 可以响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

//针对于响应方法的实现

-(void)copy:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}



//UILabel默认是不接收事件的，我们需要自己添加touch事件

-(void)attachTapHandler {
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

    touch.numberOfTapsRequired = 2;
    
    UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];

    longPre.minimumPressDuration = 1;
    [self addGestureRecognizer:touch];
    [self addGestureRecognizer:longPre];
}

//绑定事件

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self attachTapHandler];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self attachTapHandler];
}


- (void)handleTap:(UIGestureRecognizer*)recognizer {
    [self becomeFirstResponder];
//    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copy:)];
//    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
}

@end
