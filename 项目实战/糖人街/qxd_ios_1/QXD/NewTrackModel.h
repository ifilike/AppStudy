//
//  NewTrackModel.h
//  QXD
//
//  Created by zhujie on 平成28-02-02.
//  Copyright © 平成28年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewTrackModel : NSObject
//@property(nonatomic,copy) NSString *content;
//@property(nonatomic,copy) NSString *create_time;
//@property(nonatomic,copy) NSString *Id;
//@property(nonatomic,copy) NSString *order_id;

@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *time;

-(id)initWithDict:(NSDictionary *)dic;
@end
