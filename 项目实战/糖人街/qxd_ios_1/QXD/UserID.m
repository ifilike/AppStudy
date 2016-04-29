//
//  UserID.m
//  QXD
//
//  Created by zhujie on 平成27-11-27.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import "UserID.h"
#import "UserIDModle.h"

@implementation UserID


+(instancetype)shareInState{
    static UserID * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [[UserID alloc] init];
    });
    return manager;
}
-(instancetype)init{
    if (self  = [super init]) {
        NSString *contentPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/userID.db"];
        _dataBase = [[FMDatabase alloc] initWithPath:contentPath];
        if ([_dataBase open]) {
            NSLog(@"userID数据库创建成功");
        }
//        NSString *creatUserSql = @"create table if not exists UserTable(id integer primary key autoincrement,userId varchar(256),userIcon varchar(256),userName varchar(256),userIconImg blog,userBirthday varchar(256),userSex varchar(256))";
        NSString *creatUserSql = @"create table if not exists UserTable(id integer primary key autoincrement,binding_num varchar(256),birthday varchar(256),create_time varchar(256),head_portrait varchar(256),userID varchar(256),is_binding varchar(256),is_vip varchar(256),nickName varchar(256),sex varchar(256),vip_id varchar(256),vip_owner varchar(256),vip_time_limit varchar(256),vip_discount varchar(256),load_type varchar(256),third_id varchar(256),qq_id varchar(256),wb_id varchar(256),wx_id varchar(256),password varchar(256))";
        if ([_dataBase executeUpdate:creatUserSql]) {
            NSLog(@"UserTable表创建成功");
        }
        _arrayM = [[NSMutableArray alloc] init];
    }
    return self;
}
//存储数据
//-(void)insertIntoUserListWith:(NSString *)userID UserIcon:(NSString *)userIcon UserName:(NSString *)userName UserIconImg:(NSData *)userIconImg UserBirthday:(NSString *)userBirthday UserSex:(NSString *)userSex{
//    NSString *insertSql = @"insert into UserTable(userId,userIcon,userName,userIconImg,userBirthday,userSex) values(?,?,?,?,?,?)";
//    if ([_dataBase executeUpdate:insertSql,userID,userIcon,userName,userIconImg,userBirthday,userSex]) {
//        NSLog(@"userId插入成功");
//    }
//}
-(void)insertIntoUserListWith:(NSString *)binding_num Birthday:(NSString *)birthday Create_time:(NSString *)create_time Head_protrait:(NSString *)head_portrait Id:(NSString *)ID Is_binding:(NSString *)is_binding Is_vip:(NSString *)is_vip NickName:(NSString *)nickName Sex:(NSString *)sex Vip_id:(NSString *)vip_id Vip_owner:(NSString *)vip_owner Vip_time_limit:(NSString *)vip_time_limit Vip_discount:(NSString *)vip_discount LoadType:(NSString *)loadType Third_id:(NSString *)third_id QQ_id:(NSString *)qq_id WB_id:(NSString *)wb_id WX_id:(NSString *)wx_id password:(NSString *)password{
    NSString *insertSql = @"insert into UserTable(binding_num,birthday,create_time,head_portrait,userID,is_binding,is_vip,nickName,sex,vip_id,vip_owner,vip_time_limit,vip_discount,load_type,third_id,qq_id,wb_id,wx_id,password) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    if ([_dataBase executeUpdate:insertSql,binding_num,birthday,create_time,head_portrait,ID,is_binding,is_vip,nickName,sex,vip_id,vip_owner,vip_time_limit,vip_discount,loadType,third_id,qq_id,wb_id,wx_id,password]) {
                NSLog(@"userId插入成功");
        [self redFromUserListAllData];
    }
}

//读取数据

-(NSMutableArray *)redFromUserListAllData{
    [_arrayM removeAllObjects];
    NSString *selectSql = @"select *from UserTable";
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    while ([set next]) {
        UserIDModle *model = [[UserIDModle alloc] init];
        
        model.binding_num = [set stringForColumn:@"binding_num"];//绑定手机号
        model.birthday = [set stringForColumn:@"birthday"];//生日
        model.create_time = [set stringForColumn:@"create_time"];//创建时间
        model.head_portrait = [set stringForColumn:@"head_portrait"];//头像
        model.ID = [set stringForColumn:@"userID"];//用户id
        model.is_binding = [set stringForColumn:@"is_binding"];//是否绑定手机
        model.is_vip = [set stringForColumn:@"is_vip"];;//是否是vip
        model.nickName = [set stringForColumn:@"nickName"];//用户昵称
        model.sex = [set stringForColumn:@"sex"];//性别
        model.vip_id = [set stringForColumn:@"vip_id"];//vip ID
        model.vip_owner = [set stringForColumn:@"vip_owner"];//是否是vip主卡
        model.vip_time_limit = [set stringForColumn:@"vip_time_limit"];//vip到期时间
        model.vip_discount = [set stringForColumn:@"vip_discount"];//折数
        
        model.load_type = [set stringForColumn:@"load_type"];//登录类型
        model.third_id = [set stringForColumn:@"third_id"];//第三方登录id
        model.qq_id = [set stringForColumn:@"qq_id"];//qqid
        model.wb_id = [set stringForColumn:@"wb_id"];//wbid
        model.wx_id = [set stringForColumn:@"wx_id"];//wxid
        model.password = [set stringForColumn:@"password"];//mima
        
//        NSLog(@"modle.binding_num:%@",model.binding_num);
//        NSLog(@"model.birthday:%@",model.birthday);
//        NSLog(@"modle.create_time:%@",model.create_time);
//        NSLog(@"modle.head_protrait:%@",model.head_portrait);
//        NSLog(@"modle.id:%@",model.ID);
//        NSLog(@"modle.is_binding:%@",model.is_binding);
//        NSLog(@"modle.is_vip%@",model.is_vip);
//        
//        NSLog(@"modle.nickName:%@",model.nickName);
//        NSLog(@"modle.sex:%@",model.sex);
//        NSLog(@"modle.vip_id:%@",model.vip_id);
//        NSLog(@"model.vip_owner:%@",model.vip_owner);
//        NSLog(@"modle.time_limit:%@",model.vip_time_limit);
//        NSLog(@"model.vip_discount%@",model.vip_discount);
//        
//        NSLog(@"model.load_type:%@",model.load_type);
//        NSLog(@"modle.third_id:%@",model.third_id);
//        NSLog(@"model.qq_id:%@",model.qq_id);
//        NSLog(@"model.wb_id:%@",model.wb_id);
//        NSLog(@"model.wx_id:%@",model.wx_id);
        
        [_arrayM addObject:model];

    }
//    NSLog(@"----userid------%d",[_arrayM objectAtIndex:0]);
    return _arrayM;
}

//删除数据 重新登录
-(void)deleteUserList{
    NSString *selectSql = @"select *from UserTable";
    FMResultSet *set = [_dataBase executeQuery:selectSql];
    while ([set next]) {
        UserIDModle *model = [[UserIDModle alloc] init];
        model.ID = [set stringForColumn:@"userID"];
        [self deleteUserListWithName:model.ID];
    }
}
//根据名字删除
-(void)deleteUserListWithName:(NSString *)name{
    NSString *deleteSql = @"delete from UserTable where userID = ?";
    if ([_dataBase executeUpdate:deleteSql,name]) {
        NSLog(@"删除名字是....的数据");
    }
}

@end
