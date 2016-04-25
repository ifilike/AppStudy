//
//  ZJImageCache.h
//  CoreText
//
//  Created by babbage on 16/4/22.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZJImageCache : NSObject

@property (nonatomic, strong) NSString *localDirectory;

// 单例cache
+ (instancetype)cache;

// 清除cache
- (void)clearCache;

// 是否在本地找到图片,是否需要缩略图
- (void)imageForURL:(NSString *)imageURL needThumImage:(BOOL)needThumImage found:(void(^)(UIImage* image))found notFound:(void(^)())notFound;

// 是否在本地找到图片
- (void) imageForURL:(NSString *)imageURL found:(void(^)(UIImage* image))found notFound:(void(^)())notFound;

// 图片是否缓存
- (BOOL)imageIsCacheForURL:(NSString *)imageURL;

// 同步下载保存image
- (BOOL)saveImageFromURL:(NSString *)imageName thumbImageSize:(CGSize)thumbImageSize;

// 保存图片
- (BOOL)saveImageFromURL:(NSString *)imageName data:(NSData *)imageData;

// 保存image和缩略图
- (BOOL)saveImageFromURL:(NSString *)imageName thumbImageSize:(CGSize)thumbImageSize data:(NSData *)imageData;

// 异步下载保存image
- (void)saveAsyncImageFromURL:(NSString *)imageURL thumbImageSize:(CGSize)thumbImageSize completion:(void(^)(BOOL isCache))completionBlock;

// 异步下载保存image数组
- (void)saveAsyncImagesFromURLArray:(NSArray *)imageURLArray thumbImageSize:(CGSize)thumbImageSize completion:(void(^)(BOOL isCache))completionBlock;

@end
