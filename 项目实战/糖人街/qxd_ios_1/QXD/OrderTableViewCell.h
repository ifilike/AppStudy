//
//  OrderTableViewCell.h
//  QXD
//
//  Created by zhujie on 平成27-11-22.
//  Copyright © 平成27年 ZhangRui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@class Order;

@interface OrderTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *payStatueLabel;

@property(nonatomic,strong) UIView *payView;
@property(nonatomic,strong) UILabel *totalCountLabel;
@property(nonatomic,strong) UILabel *moneyCountLabel;
@property(nonatomic,strong) UIButton *payDetailButton;//订单跟踪
@property(nonatomic,strong) UIButton *payButton;//支付

@property(nonatomic,strong) UITableView *detailTableView;
@property(nonatomic,strong) UIViewController *VC;
@property(nonatomic,strong) NSMutableArray *dataArry;
@property(nonatomic,strong) NSMutableArray *DataArray;//给每个cell赋值 此时的DataArray是dataArray的数据模型版本

@property(nonatomic,strong) NSString *payMoney;//从vc里获取 你点击的cell的数据源里的总钱数 方便支付
//@property(nonatomic,strong) NSString *orderID;//从vc里获取  你点击的cell的数据源里的订单id 为支付的时候展示
@property(nonatomic,strong) void(^getPayMoney)();//block

@property(nonatomic,strong) NSString *orderId;//用户id ???? 订单id
@property(nonatomic,strong) void(^deleteWtihSelf)();//删除
@property(nonatomic,strong) void(^BlockReloadWithOutTime)();//刷新
@property(nonatomic,strong) void(^BlockChangeGYGB)(NSString *orderModel_id);//更改订单状态交易关闭
@property(nonatomic,strong) NSString *pay_type;//支付类型
@property(nonatomic,strong) NSString *express_id;//物流id


-(void)configCellWithOrderModel:(OrderModel *)orderModel;
-(void)pay;
@property(nonatomic,strong) Order *order;

@end
