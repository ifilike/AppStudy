//
//  ZJImageStorage.m
//  CoreText
//
//  Created by babbage on 16/4/22.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ZJImageStorage.h"
#import "ZJImageCache.h"

@interface ZJImageStorage ()
@property (nonatomic, weak) UIView *ownerView;
@property (nonatomic, assign) BOOL isNeedUpdateFrame;
@end

@implementation ZJImageStorage

- (instancetype)init
{
    if (self = [super init]) {
        _cacheImageOnMemory = NO;
    }
    return self;
}

#pragma mark - protocol

- (void)setOwnerView:(UIView *)ownerView
{
    _ownerView = ownerView;
    
    if ([_imageURL isKindOfClass:[NSURL class]]
        && ![[ZJImageCache cache] imageIsCacheForURL:_imageURL.absoluteString]) {
        
        [[ZJImageCache cache]saveAsyncImageFromURL:_imageURL.absoluteString thumbImageSize:self.size completion:^(BOOL isCache) {
            
            if (_isNeedUpdateFrame) {
                if (ownerView && isCache) {
                    [ownerView setNeedsDisplay];
                }
                _isNeedUpdateFrame = NO;
            }
        }];
    }
}

- (void)drawStorageWithRect:(CGRect)rect
{
    __block UIImage *image = nil;
    if (_image) {
        // 本地图片名
        image = _image;
    }else if (_imageName){
        // 图片网址
        image = [UIImage imageNamed:_imageName];
        if (_cacheImageOnMemory) {
            _image = image;
        }
    } else if (_imageURL){
        // 图片数据
        [[ZJImageCache cache] imageForURL:_imageURL.absoluteString needThumImage:NO found:^(UIImage *loaceImage) {
            image = loaceImage;
            if (_cacheImageOnMemory) {
                _image = image;
            }
        } notFound:^{
            image = _placeholdImageName ? [UIImage imageNamed:_placeholdImageName] : nil;
            _isNeedUpdateFrame = YES;
        }];
    }
    
    if (image) {
        CGRect fitRect = [self rectFitOriginSize:image.size byRect:rect];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, fitRect, image.CGImage);
    }
}

- (CGRect)rectFitOriginSize:(CGSize)size byRect:(CGRect)byRect{
    
    CGRect scaleRect = byRect;
    CGFloat targetWidth = byRect.size.width;
    CGFloat targetHeight = byRect.size.height;
    CGFloat widthFactor = targetWidth / size.width;
    CGFloat heightFactor = targetHeight / size.height;
    CGFloat scaleFactor = MIN(widthFactor, heightFactor);
    CGFloat scaledWidth  = size.width * scaleFactor;
    CGFloat scaledHeight = size.height * scaleFactor;
    scaleRect.size = CGSizeMake(scaledWidth, scaledHeight);
    // center the image
    if (widthFactor < heightFactor) {
        scaleRect.origin.y += (targetHeight - scaledHeight) * 0.5;
    } else if (widthFactor > heightFactor) {
        switch (_imageAlignment) {
            case ZJImageAlignmentCenter:
                scaleRect.origin.x += (targetWidth - scaledWidth) * 0.5;
                break;
            case ZJImageAlignmentRight:
                scaleRect.origin.x += (targetWidth - scaledWidth);
            default:
                break;
        }
    }
    return scaleRect;
}

// override
- (void)didNotDrawRun
{
    
}

@end
