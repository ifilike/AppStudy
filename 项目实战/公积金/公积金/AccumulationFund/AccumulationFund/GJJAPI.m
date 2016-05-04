#import "GJJAPI.h"

typedef NS_OPTIONS(NSInteger, GJJAPIConnectType) {
    GJJAPIConnectTypeCache = 0,
    GJJAPIConnectTypeSafe
};


@interface GJJAPI () <NSURLSessionDelegate>


@end

@implementation GJJAPI

static NSString * const baseURLString = @"http://222.222.216.162:10003/app/personal/";

+ (instancetype)sharedGJJAPI {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)register_身份证:(NSString *)identityCard 用户姓名:(NSString *)username 密码:(NSString *)password 公积金账号:(NSString *)account 手机:(NSString *)cellphone completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"sfzh"] = identityCard;
    para[@"zgxm"] = username;
    para[@"password"] = password;
    para[@"qrpassword"] = password;
    para[@"zgzh"] = account;
    para[@"yzmsj"] = cellphone;
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"zcxx"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)login_用户姓名:(NSString *)username 密码:(NSString *)password 手机:(NSString *)cellphone completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"username"] = username;
    para[@"password"] = password;
    para[@"cellphone"] = cellphone;
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"login"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)passwordModification_用户姓名:(NSString *)username 旧密码:(NSString *)password 手机:(NSString *)cellphone 新密码:(NSString *)newPassword completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"username"] = username;
    para[@"cellphone"] = cellphone;
    para[@"oldpassword"] = password;
    para[@"password"] = newPassword;
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"mxxg"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)information_资讯类型:(NSString *)id 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"id"] = id;
    if(message.length > 0) {
        para[@"msg"] = message;
    }
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"newspolicy"] parameters:para.copy type:GJJAPIConnectTypeCache completionHandler:handler];
}

+ (void)userAccount_公积金账号:(NSString *)id completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"id"] = id;
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"grzhcx"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)depositDetail_公积金账户:(NSString *)account 开始时间:(NSString *)startTime 结束时间:(NSString *)overTime completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"zgzh"] = account;
    para[@"kssj"] = startTime;
    para[@"jssj"] = overTime;
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"grjcmxcx"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)loanBasicInformation_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"id"] = staffNumber;
    if(message.length > 0) {
        para[@"msg"] = message;
    }
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"dkjbxxcx"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)loanDetails_职工编号:(NSString *)staffNumber 合同编号:(NSString *)contractNumber 开始时间:(NSString *)startTime 结束时间:(NSString *)overTime completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"zgbh"] = staffNumber;
    para[@"htbh"] = contractNumber;
    para[@"kssj"] = startTime;
    para[@"jssj"] = overTime;
    para[@"userid"] = @"1";

    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"dkhkmxcx"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)loanRepaymentBasicInformation_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"id"] = staffNumber;
    if(message.length > 0) {
        para[@"msg"] = message;
    }
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"dkhkjbxxcx"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)loanProgressBasicInformation_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"id"] = staffNumber;
    if(message.length > 0) {
        para[@"msg"] = message;
    }
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"dkjdjbxx"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)loanApplicationStatus_职工编号:(NSString *)staffNumber 申请编号:(NSString *)appNumber completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"id"] = staffNumber;
    para[@"msg"] = appNumber;
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"dkspd"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)branchSearchWithCompletionHandler:(GJJAPIHandler)handler {
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"wddzcx"] parameters:nil type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)prepaymentBasicInformation_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"id"] = staffNumber;
    if (message.length > 0) {
        para[@"msg"] = message;
    }
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"tqhk"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}



+ (void)prepaymentInterestCalculation_还款方式:(NSString *)repaymentType 贷款利率:(NSString *)loanRates 贷款余额:(NSString *)loans 上年贷款利率:(NSString *)lastYearLoanRates 还款日:(NSString *)repaymentDate 到期总利息:(NSString *)maturityTotalInterest 发放日期:(NSString *)releaseDate 应还日期:(NSString *)promiseDate 还款日期:(NSString *)prepaymentDate 本息合计:(NSString *)principalInterestSum 还款本金:(NSString *)repaymentOfPrincipal 还款利息:(NSString *)repaymentOfInterest 违约金:(NSString *)liquidatedDamages completionHandler:(GJJAPIHandler)handler {
    
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"gjdbm"] = @"0101";
    para[@"hkfs"] = repaymentType;
    para[@"dklv"] = loanRates;
    para[@"dkye"] = loans;
    para[@"sndkll"] = lastYearLoanRates;
    para[@"hkr"] = repaymentDate;
    para[@"zlx"] = maturityTotalInterest;
    para[@"ffrq"] = releaseDate;
    para[@"yhrq"] = promiseDate;
    para[@"ydhkr"] = prepaymentDate;
    para[@"hkje"] = principalInterestSum;
    para[@"hkbj"] = repaymentOfPrincipal;
    para[@"hklx"] = repaymentOfInterest;
    para[@"wyj"] = liquidatedDamages;
    
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"tqhblxjs"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)prepaymentPrincipalCalculation_合同编号:(NSString *)contractNumber 提前还本金额:(NSString *)paymentMoney 提前还本方式:(NSString *)prepaymengtType 还本后月还金额:(NSString *)monthPaymentMoney 还本后总次数:(NSString *)total 还本后结清日期:(NSString *)settlementDate completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary * para = [NSMutableDictionary dictionary];
    para[@"htbh"] = contractNumber;
    para[@"tqhbje"] = paymentMoney;
    para[@"tqhbfs"] = prepaymengtType;
    para[@"hbhyhje"] = monthPaymentMoney;
    para[@"hbhzcs"] = total;
    para[@"hbhjqrq"] = settlementDate;
    
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"tqhbjs"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}



+ (void)mortgageCalculationBasicInformation_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"id"] = staffNumber;
    if (message.length > 0) {
        para[@"msg"] = message;
    }
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"fdjsjbxx"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}



+ (void)outletsWithCompletionHandler:(GJJAPIHandler)handler {
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"tqyywdcx"] parameters:nil type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)drawAppointment_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"id"] = staffNumber;
    if (message.length > 0) {
        para[@"msg"] = message;
    }
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"tqyycx"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)fundLoanRates_贷款年限:(NSString *)years 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"id"] = years;
    if (message.length > 0) {
        para[@"msg"] = message;
    }
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"gjjdklv"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)appointmentNumber_职工编号:(NSString *)staffNumber 提取原因:(NSString *)drawReason 预约网点:(NSString *)appointmentBranch 预约日期:(NSString *)appointmentDate completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"zgbh"] = staffNumber;
    para[@"tqyybm"] = drawReason;
    para[@"yywdbm"] = appointmentBranch;
    para[@"yyrq"] = appointmentDate;
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"tqyycxadd"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)drawDetail_职工编号:(NSString *)staffNumber 提取原因:(NSString *)drawReason completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"id"] = staffNumber;
    para[@"msg"] = drawReason;
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"tqclcx"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)purchaseTypeWithCompletionHandler:(GJJAPIHandler)handler {
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"gflx"] parameters:nil type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)appointmentBranchWithCompletionHandler:(GJJAPIHandler)handler {
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"dkgjdbm"] parameters:nil type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)loanAmountCalculation_职工编号:(NSString *)staffNumber 购房类型:(NSString *)purchaseType 购房面积:(NSString *)area 购房总价:(NSString *)totalCost completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"zgbh"] = staffNumber;
    para[@"gflx"] = purchaseType;
    para[@"gfmj"] = area;
    para[@"gfzj"] = totalCost;

    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"dkedjs"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)appointmentInformation_职工编号:(NSString *)staffNumber 消息:(NSString *)message completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"id"] = staffNumber;
    if (message.length > 0) {
        para[@"msg"] = message;
    }
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"yycx"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}

+ (void)loanApplicationAppointmnet_职工编号:(NSString *)staffNumber 购房类型:(NSString *)purchaseType 还款方式:(NSString *)repaymentType 贷款金额:(NSString *)maxLoanAmount 贷款年限:(NSString *)years 购房总价:(NSString *)totalCost 购房合同号:(NSString *)number 受理日期:(NSString *)acceptanceDate completionHandler:(GJJAPIHandler)handler {
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    para[@"gjdbm"] = @"0101";
    para[@"zgbh"] = staffNumber;
    para[@"gflx"] = purchaseType;
    para[@"hkfs"] = repaymentType;
    para[@"dkje"] = maxLoanAmount;
    para[@"dknx"] = years;
    para[@"gfzj"] = totalCost;
    para[@"gfhth"] = number;
    para[@"slrq"] = acceptanceDate;
    para[@"userid"] = @"1";
    [GJJAPI POSTWithURLString:[GJJAPI insertBaseURLStringWithAPIName:@"dksqsladd"] parameters:para.copy type:GJJAPIConnectTypeSafe completionHandler:handler];
}















+ (void)POSTWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters type:(GJJAPIConnectType)type completionHandler:(GJJAPIHandler)handler {
    
    NSLog(@"%@", URLString);
    NSURLSession * session = [GJJAPI sessionWithGJJAPIConnectType:type];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    request.HTTPMethod = @"POST";
    if (parameters != nil) {
        
        [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        
        NSError * error = [NSError errorWithDomain:@"JSON反序列化错误, 001, GJJAPI POST" code:001 userInfo:@{@"dictionary" : parameters}];
        NSData * data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&error];
        NSLog(@"request = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        request.HTTPBody = data;
    }
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSInteger status = ((NSHTTPURLResponse *)response).statusCode/100;
        if (status == 2) {
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(jsonDict, response, nil);
            });
        } else {
            NSError *myError = [NSError errorWithDomain:@"网络错误" code:10000 userInfo:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                handler(dataString, response, myError);
            });
        }
    }] resume];
}

+ (NSDictionary *)dictionaryByAddingPercentEncodingWithParameters:(NSDictionary *)para {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (NSString * key in para) {
        dict[key] = [para[key] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    return dict.copy;
}

+ (NSURLSession *)sessionWithGJJAPIConnectType:(GJJAPIConnectType)type {
    NSURLSessionConfiguration * configuration = type ? [NSURLSessionConfiguration ephemeralSessionConfiguration] : [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 14;
    return [NSURLSession sessionWithConfiguration:configuration delegate:[GJJAPI sharedGJJAPI] delegateQueue:[[NSOperationQueue alloc] init]];
}

+ (NSString *)insertBaseURLStringWithAPIName:(NSString *)name {
    return [baseURLString stringByAppendingString:name];
}

@end
