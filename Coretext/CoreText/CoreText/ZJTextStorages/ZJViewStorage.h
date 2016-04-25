//
//  ZJViewStorage.h
//  CoreText
//
//  Created by babbage on 16/4/22.
//  Copyright © 2016年 babbage. All rights reserved.
//

#import "ZJDrawStorage.h"

@interface ZJViewStorage : ZJDrawStorage<ZJViewStorageProtocol>

@property(nonatomic,strong) UIView *view;//添加view

@end
