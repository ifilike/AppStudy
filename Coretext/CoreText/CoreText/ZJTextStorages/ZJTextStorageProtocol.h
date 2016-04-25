//
//  ZJTextStorageProtocol.h
//  CoreText
//
//  Created by babbage on 16/4/18.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZJDrawAlignmentTop,     // 底部齐平 向上伸展
    ZJDrawAlignmentCenter,  // 中心齐平
    ZJDrawAlignmentBottom,  // 顶部齐平 向下伸展
} ZJDrawAlignment;

extern NSString *const kZJTextRunAttributedName;

@protocol ZJTextStorageProtocol <NSObject>
@required

/**
 *  范围（如果是appendStorage,range只针对追加的文本）
 */
@property (nonatomic,assign) NSRange range;

/**
 *  文本中实际位置,因为某些文本被替换，会导致位置偏移
 */
@property (nonatomic,assign) NSRange realRange;

/**
 *  添加属性到全文attributedString addTextStorage调用
 *
 *  @param attributedString 属性字符串
 */
- (void)addTextStorageWithAttributedString:(NSMutableAttributedString *)attributedString;
@end




@protocol ZJAppendTextStorageProtocol <ZJTextStorageProtocol>

@required

/**
 *  追加attributedString属性 appendTextStorage调用
 *
 *  @return 返回需要追加的attributedString属性
 */
- (NSAttributedString *)appendTextStorageAttributedString;

@end

@protocol ZJLinkStorageProtocol <ZJAppendTextStorageProtocol>

@property (nonatomic, strong) UIColor   *textColor;     // 文本颜色

@end

@protocol ZJDrawStorageProtocol <ZJAppendTextStorageProtocol>

@property (nonatomic, assign)   UIEdgeInsets    margin; // 四周间距

/**
 *  添加View 或 绘画 到该区域
 *
 *  @param rect 绘画区域
 */
- (void)drawStorageWithRect:(CGRect)rect;

/**
 *  设置字体高度 当前字符串替换数
 */
- (void)setTextfontAscent:(CGFloat)ascent descent:(CGFloat)descent;

// 当前替换字符数
- (void)currentReplacedStringNum:(NSInteger)replacedStringNum;

@end

@protocol ZJViewStorageProtocol <NSObject>

/**
 *  设置所属的view
 */
- (void)setOwnerView:(UIView *)ownerView;

/**
 *  不会把你绘画出来
 */
- (void)didNotDrawRun;

@end
