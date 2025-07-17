//
//  GSNetWorking.m
//  QingProduct
//
//  Created by LiuGaoSheng on 2021/7/19.
//  Copyright © 2021 刘高升. All rights reserved.
//

#import "GSNetWorking.h"
//#import "Auth.h"

#pragma mark - 认证环境 -- 正式
NSString *const THT_Product_AppKey = @"55d2793c077347a8b71114a9529533e8";
NSString *const THT_Product_AppSecret = @"3ed93a1f44434ae68b848c475653bbd8edb3689a88c047e3b904aedc28284e05";
NSString *const ResponseErrorKey = @"com.alamofire.serialization.response.error.response";
NSInteger const Interval = 10;

@implementation GSNetWorking
//原生GET网络请求
+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure
{
    //完整URL
    NSString *urlString = [NSString string];
    if (params) {
        //参数拼接url
        NSString *paramStr = [self dealWithParam:params];
        urlString = [url stringByAppendingString:paramStr];
    }else{
        urlString = url;
    }
    //对URL中的中文进行转码
    NSString *pathStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pathStr]];
    
    request.timeoutInterval = Interval;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                //利用iOS自带原生JSON解析data数据 保存为Dictionary
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(dict);
                
            }else{
                NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
                
                if (httpResponse.statusCode != 0) {
                    
                    NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                    failure(ResponseStr);
                    
                } else {
                    NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                    failure(ErrorCode);
                }
            }

        });
    }];
    
    [task resume];
}

//原生POST请求
+ (void)PostWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    //把字典中的参数进行拼接
    NSString *body = [self dealWithParam:params];
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置请求体
    [request setHTTPBody:bodyData];
    //设置本次请求的数据请求格式
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    // 设置本次请求请求体的长度(因为服务器会根据你这个设定的长度去解析你的请求体中的参数内容)
    [request setValue:[NSString stringWithFormat:@"%ld", bodyData.length] forHTTPHeaderField:@"Content-Length"];
    //设置请求最长时间
    request.timeoutInterval = Interval;
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
     
        if (data) {
            //利用iOS自带原生JSON解析data数据 保存为Dictionary
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            success(dict);
            
        }else{
            NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
            
            if (httpResponse.statusCode != 0) {
                
                NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                failure(ResponseStr);
                
            } else {
                NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                failure(ErrorCode);
            }
        }
    }];
    [task resume];
}
+ (void)getAuthorizationWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure {
    //完整URL
    NSString *urlString = [NSString string];
    if (params) {
        //参数拼接url
        NSString *paramStr = [self dealWithParam:params];
        urlString = [url stringByAppendingString:paramStr];
    }else{
        urlString = url;
    }
    //对URL中的中文进行转码
    NSString *pathStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pathStr]];
//    [request setValue:[Auth generateSignatureWithKey:THT_Product_AppKey withSecret:THT_Product_AppSecret] forHTTPHeaderField:@"Authorization"];
    request.timeoutInterval = Interval;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                //利用iOS自带原生JSON解析data数据 保存为Dictionary
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(dict);
                
            }else{
                NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
                
                if (httpResponse.statusCode != 0) {
                    
                    NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                    failure(ResponseStr);
                    
                } else {
                    NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                    failure(ErrorCode);
                }
            }

        });
    }];
    
    [task resume];
}

+ (void)PostAuthorizationWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    //把字典中的参数进行拼接
//    NSString *body = [self dealWithParam:params];
    NSData *bodyData = [[NSData alloc]initWithData:[NSJSONSerialization dataWithJSONObject:params options:0 error:nil]];
    //设置请求体
    [request setHTTPBody:bodyData];
//    [request setValue:[Auth generateSignatureWithKey:THT_Product_AppKey withSecret:THT_Product_AppSecret] forHTTPHeaderField:@"Authorization"];
    //设置本次请求的数据请求格式
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 设置本次请求请求体的长度(因为服务器会根据你这个设定的长度去解析你的请求体中的参数内容)
    [request setValue:[NSString stringWithFormat:@"%ld", bodyData.length] forHTTPHeaderField:@"Content-Length"];
    //设置请求最长时间
    request.timeoutInterval = Interval;
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
     
        if (data) {
            //利用iOS自带原生JSON解析data数据 保存为Dictionary
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            success(dict);
            
        }else{
            NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
            
            if (httpResponse.statusCode != 0) {
                
                NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                failure(ResponseStr);
                
            } else {
                NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                failure(ErrorCode);
            }
        }
    }];
    [task resume];
}


#pragma mark - 优惠券专用
+ (void)getCouponWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure {
    //完整URL
    NSString *urlString = [NSString string];
    if (params) {
        //参数拼接url
        NSString *paramStr = [self dealWithParam:params];
        urlString = [url stringByAppendingString:paramStr];
    }else{
        urlString = url;
    }
    //对URL中的中文进行转码
    NSString *pathStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pathStr]];
    [request setValue:@"AR01" forHTTPHeaderField:@"accountId"];
    [request setValue:@"GetCouponList" forHTTPHeaderField:@"serviceName"];
    [request setValue:[self getCurrentTimes] forHTTPHeaderField:@"requestTime"];
    [request setValue:@"1.0" forHTTPHeaderField:@"version"];
    [request setValue:@"E67221F73E886C1364F21D5BB24907D6" forHTTPHeaderField:@"sign"];
    request.timeoutInterval = Interval;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                //利用iOS自带原生JSON解析data数据 保存为Dictionary
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(dict);
                
            }else{
                NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
                
                if (httpResponse.statusCode != 0) {
                    
                    NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                    failure(ResponseStr);
                    
                } else {
                    NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                    failure(ErrorCode);
                }
            }

        });
    }];
    
    [task resume];
}
+ (void)postCouponWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
      cachePolicy:NSURLRequestUseProtocolCachePolicy
      timeoutInterval:10.0];
    NSDictionary *headers = @{
         @"Content-Type": @"application/json"
    };

    [request setAllHTTPHeaderFields:headers];
    NSData *postData = [[NSData alloc] initWithData:[[NSString stringWithFormat:@"<request>\n  <header>\n      <accountId>AR01</accountId>\n      <serviceName>GetCouponList</serviceName>\n      <requestTime>%@</requestTime>\n      <version>1.0</version>\n      <sign>E67221F73E886C1364F21D5BB24907D6</sign>\n  </header>\n  <body>\n      \n  </body>\n</request>",[self getCurrentTimes]] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];

    [request setHTTPMethod:@"PATCH"];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        NSLog(@"%@", error);
        dispatch_semaphore_signal(sema);
      } else {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

          if (httpResponse.statusCode == 200) {
              NSError *parseError = nil;
              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
              NSLog(@"%@",responseDictionary);
               success(responseDictionary);

              
          } else {
              NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
              failure(ResponseStr);

          }
        dispatch_semaphore_signal(sema);
      }
    }];
    
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}
+ (void)patchCouponWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure {
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
      cachePolicy:NSURLRequestUseProtocolCachePolicy
      timeoutInterval:10.0];
    NSDictionary *headers = @{
         @"Content-Type": @"application/json"
    };

    [request setAllHTTPHeaderFields:headers];
    
    NSData *bodyData = [[NSData alloc]initWithData:[NSJSONSerialization dataWithJSONObject:params options:0 error:nil]];
    //NSData *postData = [[NSData alloc] initWithData:[@"{\n    \"answer\": \"我想你了\",\n    \"id\": 1\n}" dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:bodyData];

    [request setHTTPMethod:@"PATCH"];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      if (error) {
        NSLog(@"%@", error);
        dispatch_semaphore_signal(sema);
      } else {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

          if (httpResponse.statusCode == 200) {
              NSError *parseError = nil;
              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
              NSLog(@"%@",responseDictionary);
               success(responseDictionary);

              
          } else {
              NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
              failure(ResponseStr);

          }
        dispatch_semaphore_signal(sema);
      }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}
#pragma mark -- 拼接参数
+ (NSString *)dealWithParam:(NSDictionary *)param
{
    NSArray *allkeys = [param allKeys];
    NSMutableString *result = [NSMutableString string];
    
    for (NSString *key in allkeys) {
        NSString *string = [NSString stringWithFormat:@"%@=%@&", key, param[key]];
        [result appendString:string];
    }
    return result;
}

#pragma mark
+ (NSString *)showErrorInfoWithStatusCode:(NSInteger)statusCode{
    
    NSString *message = nil;
    switch (statusCode) {
        case 401: {
        
        }
            break;
            
        case 500: {
            message = @"服务器异常！";
        }
            break;
            
        case -1001: {
            message = @"网络请求超时，请稍后重试！";
        }
            break;
            
        case -1002: {
            message = @"不支持的URL！";
        }
            break;
            
        case -1003: {
            message = @"未能找到指定的服务器！";
        }
            break;
            
        case -1004: {
            message = @"服务器连接失败！";
        }
            break;
            
        case -1005: {
            message = @"连接丢失，请稍后重试！";
        }
            break;
            
        case -1009: {
            message = @"互联网连接似乎是离线！";
        }
            break;
            
        case -1012: {
            message = @"操作无法完成！";
        }
            break;
            
        default: {
            message = @"网络请求发生未知错误，请稍后再试！";
        }
            break;
    }
    return message;
    
}

+ (NSString*)getCurrentTimes{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];

    //现在时间,你可以输出来看下是什么格式

    NSDate *datenow = [NSDate date];

    //----------将nsdate按formatter格式转成nsstring

    NSString *currentTimeString = [formatter stringFromDate:datenow];

    NSLog(@"currentTimeString =  %@",currentTimeString);

    return currentTimeString;

}
@end
