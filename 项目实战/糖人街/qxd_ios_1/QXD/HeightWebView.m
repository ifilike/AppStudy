//
//  HeightWebView.m
//  QXD
//
//  Created by wzp on 16/1/27.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import "HeightWebView.h"

@implementation HeightWebView









- (NSString*)getHeightWithHTMLString:(NSString*)string{


    [self loadHTMLString:string baseURL:nil];
    return nil;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
