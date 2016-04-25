//
//  ZJImageStorage.h
//  CoreText
//
//  Created by babbage on 16/4/22.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ZJDrawStorage.h"

typedef enum : NSUInteger {
    ZJImageAlignmentCenter,  // 图片居中
    ZJImageAlignmentLeft,    // 图片左对齐
    ZJImageAlignmentRight,   // 图片右对齐
} ZJImageAlignment;


@interface ZJImageStorage : ZJDrawStorage<ZJViewStorageProtocol>

@property (nonatomic, strong) UIImage   *image;

@property (nonatomic, strong) NSString  *imageName;

@property (nonatomic, strong) NSURL     *imageURL;

@property (nonatomic, strong) NSString  *placeholdImageName;

@property (nonatomic, assign) ZJImageAlignment imageAlignment; // default center

@property (nonatomic, assign) BOOL cacheImageOnMemory; // default NO ,if YES can improve performance，but increase memory

@end
