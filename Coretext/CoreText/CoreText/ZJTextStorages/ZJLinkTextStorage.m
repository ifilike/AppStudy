//
//  ZJLinkTextStorage.m
//  CoreText
//
//  Created by babbage on 16/4/22.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ZJLinkTextStorage.h"

@implementation ZJLinkTextStorage

- (instancetype)init
{
    if (self = [super init]) {
        self.underLineStyle = kCTUnderlineStyleSingle;
        self.modifier = kCTUnderlinePatternSolid;
    }
    return self;
}

#pragma mark - protocol

- (void)addTextStorageWithAttributedString:(NSMutableAttributedString *)attributedString
{
    [super addTextStorageWithAttributedString:attributedString];
    [attributedString addAttribute:kZJTextRunAttributedName value:self range:self.range];
    self.text = [attributedString.string substringWithRange:self.range];
    
}


@end
