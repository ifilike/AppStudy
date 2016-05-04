//
//  WJBaseTool.h
//  黑马微博
//  最基本的业务工具类

#import <Foundation/Foundation.h>

@interface WJBaseTool : NSObject
+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure;

+ (void)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure;
@end
