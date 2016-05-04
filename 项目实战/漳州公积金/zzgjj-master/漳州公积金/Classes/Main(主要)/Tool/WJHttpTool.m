//
//  WJHttpTool.m
//

#import "WJHttpTool.h"
#import "AFNetworking.h"
#import "NSString+Xml.h"

@implementation WJHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *soapMessage =
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
    "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
    "<soap12:Body>"
    "<getSupportCity xmlns=\"http://tempuri.org/\">"
    "<byProvinceName>ALL</byProvinceName>"
    "</getSupportCity>"
    "</soap12:Body>"
    "</soap12:Envelope>";
    NSString *soapLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    /*
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://tempuri.org"]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    [manager SOAP:@"/webservice.zzgjj.gov.cn/DataServiceWeb.asmx/TableToJson" constructingBodyWithBlock:^(NSMutableURLRequest *request) {
        [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@, %@", operation, response);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)[operation responseObject] encoding:NSUTF8StringEncoding];
        NSLog(@"%@, %@", operation, error);
    }];
     */
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://tempuri.org"]];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:@"webservice.zzgjj.gov.cn/DataServiceWeb.asmx/TableToJson" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithHeaders:[NSDictionary dictionaryWithObjectsAndKeys:@"application/x-www-form-urlencoded", @"Content-Type", soapLength, @"Content-Length", nil] body:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [manager POST:@"/WebServices/WeatherWebService.asmx/getSupportCity" parameters:@{@"byProvinceName":@"ALL"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"responseObject: %@", response);
        
        NSData *doubi = responseObject;
        WJLog(@"success:转换前：%@",doubi);
        NSString *shabi =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
        WJLog(@"success:转换后：%@",shabi);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    /*
    NSString *urlTemp = @"http://webservice.zzgjj.gov.cn/DataServiceWeb.asmx/TableToJson?";
    //设置参数
    NSString *k_initUrl3 =[urlTemp stringByAppendingString:@"lmid=5&size=20&str="];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:k_initUrl3] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html = operation.responseString;
        WJLog(@"success-operation:%@",operation.responseString);
        WJLog(@"success-responseObject:%@",responseObject);
        //将返回字符串头去掉：<?xml version=\"1.0\" encoding=\"utf-8\"?>
        NSString *str =@"<?xml version=\"1.0\" encoding=\"utf-8\"?>";
        NSString *strhtml =[html stringByReplacingOccurrencesOfString:str withString:@""];
        //将返回字符串头去掉
        strhtml = [strhtml stringByReplacingOccurrencesOfString:@"<string xmlns=\"http://tempuri.org/\">" withString:@""];
        //将返回的字符串尾去掉
        strhtml = [strhtml stringByReplacingOccurrencesOfString:@"</string>" withString:@""];
        //去掉结尾空格
        NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        strhtml= [[NSString alloc]initWithString:[strhtml stringByTrimmingCharactersInSet:whiteSpace]];
        WJLog(@"有参strhtml----%@",strhtml);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WJLog(@"failure:%@",error);
    }];
    [operation start];
     */
    /*
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 2.发送GET请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObj) {
         WJLog(@"success:转换前：%@",responseObj);
         NSData *doubi = responseObj;
         NSString *shabi =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
         WJLog(@"success:转换后：%@",shabi);
         if (success) {
             success(responseObj);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         WJLog(@"failure: %@",error);
         if (failure) {
             failure(error);
         }
     }];
     */
    
    /*
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WJLog(@"success:转换前：%@",responseObject);
        NSData *doubi = responseObject;
        NSString *shabi =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
        WJLog(@"success:转换后：%@",shabi);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WJLog(@"failure: %@",error);
        if (failure) {
            failure(error);
        }
    }];
     */
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *soapMessage = params[@"soapMessage"];
    WJLog(@"soapMessage:%@" , soapMessage);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapMessage;
    }];
    [manager POST:url parameters:soapMessage success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        
        /*
        // WJLog(@"success:operation:%@, response:%@", operation, response);
        // 返回XML串中的数据体开头<方法名Result>的位置
        NSRange rangeBegin = [response rangeOfString:[NSString stringWithFormat:@"<%@Result>",params[@"methodName"]]];
        // 返回XML串中的数据体结尾</方法名Result>的位置
        NSRange rangeEnd = [response rangeOfString:[NSString stringWithFormat:@"</%@Result>",params[@"methodName"]]];
        // 截取字符串的开始位置
        long beginIndex = rangeBegin.location + rangeBegin.length;
        // 截取字符串的结束位置
        long endIndex = rangeEnd.location - beginIndex;
        NSString *text = [response substringWithRange:NSMakeRange(beginIndex,endIndex)];
         */
        NSString *elementName = [NSString stringWithFormat:@"%@Result",params[@"methodName"]];
        NSString *text = [response stringByXmlNoteContentWithElementName:elementName];
        WJLog(@"success:text:%@", text);
        if (success) {
            success(text);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)[operation responseObject] encoding:NSUTF8StringEncoding];
        NSLog(@"failure:%@, %@", response, error);
    }];
    
    /*
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送POST请求
    [mgr POST:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObj) {
         WJLog(@"success:转换前：%@",responseObj);
         NSData *doubi = responseObj;
         NSString *shabi =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
         WJLog(@"success:转换后：%@",shabi);
         if (success) {
             success(responseObj);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         WJLog(@"failure: %@",error);
         if (failure) {
             failure(error);
         }
     }];
    */
}

@end
