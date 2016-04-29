//
//  Singleton.h
//  QXD
//
//  Created by wzp on 16/2/18.
//  Copyright © 2016年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject


@property(nonatomic,assign)BOOL registerIs;
@property(nonatomic,strong)NSString * registerNum;
@property(nonatomic,strong)NSString * registerPassWord;



+ (Singleton*)defaultSingleton;




@end
