//
//  UserID.h
//  QXD
//
//  Created by zhujie on 平成27-11-27.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserID : NSObject{
    FMDatabase *_dataBase;
    NSMutableArray *_arrayM;
}
+(instancetype)shareInState;
-(instancetype)init;
//存储数据
-(void)insertIntoUserListWith:(NSString *)binding_num Birthday:(NSString *)birthday Create_time:(NSString *)create_time Head_protrait:(NSString *)head_portrait Id:(NSString *)ID Is_binding:(NSString *)is_binding Is_vip:(NSString *)is_vip  NickName:(NSString *)nickName Sex:(NSString *)sex Vip_id:(NSString *)vip_id Vip_owner:(NSString *)vip_owner Vip_time_limit:(NSString *)vip_time_limit Vip_discount:(NSString *)vip_discount LoadType:(NSString *)loadType Third_id:(NSString *)third_id QQ_id:(NSString *)qq_id WB_id:(NSString *)wb_id WX_id:(NSString *)wx_id password:(NSString *)password;

//读取数据

-(NSMutableArray *)redFromUserListAllData;

//删除数据 重新登录

-(void)deleteUserList;



@end
