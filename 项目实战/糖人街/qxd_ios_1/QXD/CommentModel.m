
//
//  CommentModel.m
//  QXD
//
//  Created by WZP on 15/11/19.
//  Copyright © 2015年 ZhangRui. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqual:@"id"]) {
        self.ID = value;
    }
}

@end
