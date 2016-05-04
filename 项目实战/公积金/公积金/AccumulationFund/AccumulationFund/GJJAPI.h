//
//  GJJAPI.h
//  TestAPI
//
//  Created by mac on 15/11/23.
//  Copyright © 2015年 sl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GJJAPIHandler)(id result, NSURLResponse * response, NSError * error);

@interface GJJAPI : NSObject

+ (instancetype)sharedGJJAPI;


#pragma mark --------------------------用户模块--------------------------


// 1.1 注册
+ (void)register_身份证:(NSString *)identityCard 用户姓名:(NSString *)username 密码:(NSString *)password 公积金账号:(NSString *)account 手机:(NSString *)cellphone completionHandler:(GJJAPIHandler)handler;
// 1.2 登录
+ (void)login_用户姓名:(NSString *)username 密码:(NSString *)password 手机:(NSString *)cellphone completionHandler:(GJJAPIHandler)handler;
// 1.3 修改密码
+ (void)passwordModification_用户姓名:(NSString *)username 旧密码:(NSString *)password 手机:(NSString *)cellphone 新密码:(NSString *)newPassword completionHandler:(GJJAPIHandler)handler;
// 2.1 获取资讯
+ (void)information_资讯类型:(NSString *)id 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler;
// 3.1 用户账户查询
+ (void)userAccount_公积金账号:(NSString *)id completionHandler:(GJJAPIHandler)handler;
// 3.2 贷款基本信息查询 - 贷款查询
+ (void)loanBasicInformation_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler;
// 3.3 贷款明细信息查询 - 还款查询
+ (void)loanDetails_职工编号:(NSString *)staffNumber 合同编号:(NSString *)contractNumber 开始时间:(NSString *)startTime 结束时间:(NSString *)overTime completionHandler:(GJJAPIHandler)handler;
// 3.4 贷款还款基本信息查询 - 还款查询
+ (void)loanRepaymentBasicInformation_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler;
// 3.5 贷款申请进度 - 贷款进度
+ (void)loanApplicationStatus_职工编号:(NSString *)staffNumber 申请编号:(NSString *)appNumber completionHandler:(GJJAPIHandler)handler;
// 3.6 贷款进度基本信息查询 - 贷款进度
+ (void)loanProgressBasicInformation_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler;
// 3.7 缴存明细查询 - 缴存明细
+ (void)depositDetail_公积金账户:(NSString *)account 开始时间:(NSString *)startTime 结束时间:(NSString *)overTime completionHandler:(GJJAPIHandler)handler;


#pragma mark - 便民工具

// 4.1 地图网点查询
+ (void)branchSearchWithCompletionHandler:(GJJAPIHandler)handler;
// 4.2 提前还款基本信息
+ (void)prepaymentBasicInformation_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler;
// 4.3 提前还款利息计算
+ (void)prepaymentInterestCalculation_还款方式:(NSString *)repaymentType 贷款利率:(NSString *)loanRates 贷款余额:(NSString *)loans 上年贷款利率:(NSString *)lastYearLoanRates 还款日:(NSString *)repaymentDate 到期总利息:(NSString *)maturityTotalInterest 发放日期:(NSString *)releaseDate 应还日期:(NSString *)promiseDate 还款日期:(NSString *)prepaymentDate 本息合计:(NSString *)principalInterestSum 还款本金:(NSString *)repaymentOfPrincipal 还款利息:(NSString *)repaymentOfInterest 违约金:(NSString *)liquidatedDamages completionHandler:(GJJAPIHandler)handler;
// 4.4 提前还本计算
+ (void)prepaymentPrincipalCalculation_合同编号:(NSString *)contractNumber 提前还本金额:(NSString *)paymentMoney 提前还本方式:(NSString *)prepaymengtType 还本后月还金额:(NSString *)monthPaymentMoney 还本后总次数:(NSString *)total 还本后结清日期:(NSString *)settlementDate completionHandler:(GJJAPIHandler)handler;
// 4.5 房贷基本信息 房贷计算基本信息
+ (void)mortgageCalculationBasicInformation_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler;
// 4.6 获取公积金贷款利息
+ (void)fundLoanRates_贷款年限:(NSString *)years 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler;
// 4.7 贷款额度计算
+ (void)loanAmountCalculation_职工编号:(NSString *)staffNumber 购房类型:(NSString *)purchaseType 购房面积:(NSString *)area 购房总价:(NSString *)totalCost completionHandler:(GJJAPIHandler)handler;
// 4.8 获取提取原因
+ (void)drawAppointment_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler;
// 4.9 提取预约网点获取
+ (void)outletsWithCompletionHandler:(GJJAPIHandler)handler;
// 4.10 提取预约信息保存生成预约编号
+ (void)appointmentNumber_职工编号:(NSString *)staffNumber 提取原因:(NSString *)drawReason 预约网点:(NSString *)appointmentBranch 预约日期:(NSString *)appointmentDate completionHandler:(GJJAPIHandler)handler;
// 4.11 提取预约详情
+ (void)drawDetail_职工编号:(NSString *)staffNumber 提取原因:(NSString *)drawReason completionHandler:(GJJAPIHandler)handler;

// 贷款预约网点下拉框
+ (void)appointmentBranchWithCompletionHandler:(GJJAPIHandler)handler;







// 购房类型下拉框
+ (void)purchaseTypeWithCompletionHandler:(GJJAPIHandler)handler;


// 贷款申请受理预约
+ (void)loanApplicationAppointmnet_职工编号:(NSString *)staffNumber 购房类型:(NSString *)purchaseType 还款方式:(NSString *)repaymentType 贷款金额:(NSString *)maxLoanAmount 贷款年限:(NSString *)years 购房总价:(NSString *)totalCost 购房合同号:(NSString *)number 受理日期:(NSString *)acceptanceDate completionHandler:(GJJAPIHandler)handler;



// 提取材料获取 "tqclcx"
//+ (void)extractedMaterial_账号:(NSString *) 提取原因:(NSString *) completionHandler:(GJJAPIHandler)handler;


// 预约信息查询
+ (void)appointmentInformation_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler;
@end
