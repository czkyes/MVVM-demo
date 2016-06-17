//
//  NetWorkingUtil.m
//  AFNetworkingTest
//
//  Created by book on 14-9-1.
//  Copyright (c) 2014年 vi_chen. All rights reserved.
//

#import "NetWorkingUtil.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "ReflectUtil.h"
//单例实现
@implementation NetWorkingUtil
static NetWorkingUtil *instance = nil;
static NSString* mainURL=@"http://192.168.1.223:8080/microhomePortal/";
static NSString* URL=@"controller.do?execute&ids=";
static int netWorkState;
//http://211.149.210.181:8080/VCIS/partnerSoloController.do?getMerchantList+参数



+ (NetWorkingUtil *)getNetWorkingUtil {
    if (!instance) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self getNetWorkingUtil];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)init {
    if (instance) {
        return instance;
    }
    self = [super init];
    return self;
}



/**
 要使用常规的AFN网络访问
 
 1. AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
 所有的网络请求,均有manager发起
 
 2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
 
 1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
 2> 如果返回格式不是JSON的,
 
 3. 请求格式
 
 AFHTTPRequestSerializer            二进制格式
 AFJSONRequestSerializer            JSON
 AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
 
 4. 返回格式
 
 AFHTTPResponseSerializer           二进制格式
 AFJSONResponseSerializer           JSON
 AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
 AFXMLDocumentResponseSerializer (Mac OS X)
 AFPropertyListResponseSerializer   PList
 AFImageResponseSerializer          Image
 AFCompoundResponseSerializer       组合
 */
#pragma mark - 演练
#pragma mark - 检测网络连接
+ (void)reach
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        netWorkState = status;
    }];
}

#pragma mark - Session 下载
- (void)sessionDownload
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSString *urlString = @"http://localhost/itcast/videos/01.C语言-语法预览.mp4";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        //        NSLog(@"%@ %@", targetPath, response.suggestedFilename);
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
        NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        
        NSLog(@"== %@ |||| %@", fileURL1, fileURL);
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@ %@", filePath, error);
    }];
    
    [task resume];
}



#pragma mark - 随机文件名上传
- (void)postUpload1
{
    // 本地上传给服务器时,没有确定的URL,不好用MD5的方式处理
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://localhost/demo/upload.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        // 要上传保存在服务器中的名称
        // 使用时间来作为文件名 2014-04-30 14:20:57.png
        // 让不同的用户信息,保存在不同目录中
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置日期格式
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" fileName:fileName mimeType:@"image/png" error:NULL];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"OK");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
    }];
}

#pragma mark - POST上传
- (void)postUpload
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // AFHTTPResponseSerializer就是正常的HTTP请求响应结果:NSData
    // 当请求的返回数据不是JSON,XML,PList,UIImage之外,使用AFHTTPResponseSerializer
    // 例如返回一个html,text...
    //
    // 实际上就是AFN没有对响应数据做任何处理的情况
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // formData是遵守了AFMultipartFormData的对象
    [manager POST:@"http://localhost/demo/upload.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 将本地的文件上传至服务器
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" error:NULL];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"完成 %@", result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"错误 %@", error.localizedDescription);
    }];
}


/**
 mark by vi_chen
 
 输入参数：
 name：方法名
 parameters:请求参数
 type 1:单列，返回字典结构 2:多列，返回数组结构，数组里面的每一个元素都是字典
 
 输出：void (^)(NSDictionary *dic 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) request4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(id objs,int  status,NSString *msg)) result type:(int) type convertClassName:(NSString *)calssName isCustomInterface:(BOOL) isCustom {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    NSString *postURL =  [[NSMutableString stringWithString:mainURL] stringByAppendingFormat:@"%@%@&sessionkey=%@",isCustom==YES?@"":URL,name,@"token"];
    //    NSLog(@"postURL:%@",postURL);
    [manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *resultMsg;
        int statusInt;
        
        NSDictionary *obj = [resultStr objectFromJSONString];
        //NSLog(@"obj:%@", obj);
        
        if (obj==nil) {
            NSLog(@"结果为空!");
            statusInt = NO;
            resultMsg = @"请求失败，请检查网络环境!";
            result(nil,statusInt,resultMsg);
            return;
        }
        
        resultMsg = [obj valueForKey:@"msg"];
        int temp = (int)[obj valueForKey:@"success"];
        //        int temp = [[obj valueForKey:@"success"] intValue];
        id resultArray = [obj valueForKey:@"obj"];
        //  NSLog(@"resultArray:%@,ttt:%@", resultArray,[resultArray valueForKey:@"title"]);
        if(resultArray==nil || resultArray==[NSNull null]) {
            statusInt = temp!=0?2:NO;
            result(nil,statusInt,resultMsg);
            return ;
        }
        
        
        id resultObj;
        if(type==1) {
            resultObj=calssName==nil?[resultArray firstObject]:[ReflectUtil reflectDataWithClassName:calssName otherObject:[resultArray firstObject] isList:NO];
        }else{
            resultObj=calssName==nil?resultArray:[ReflectUtil reflectDataWithClassName:calssName otherObject:resultArray isList:YES];
            
        }
        
        if (temp!=0) {
            if ([resultArray count] >0)
                statusInt = 1;
            else
                statusInt = 2;
            
        } else {
            statusInt = NO;
        }
        
        
        //返回列表
        result(resultObj,statusInt,resultMsg);
        
        // NSLog(@"%@", [NSThread currentThread]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"%@", error);
        result(nil,-1,@"网络异常！请检查您的服务器！");
        
    }];
    
}


/**
 mark by vi_chen
 描述：通用接品单列查询，返回字典结构
 输入参数：
 name：方法名
 parameters:请求参数
 
 输出：void (^)(NSDictionary *dic 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) requestDic4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(NSDictionary *dic,int  status,NSString *msg)) result{
    [self request4MethodName:name parameters:parameters result:result type:1 convertClassName:nil isCustomInterface:NO];
}

/**
 mark by vi_chen
 描述：通用接品单列查询，返回指定对象结构
 输入参数：
 name：方法名
 parameters:请求参数
 className：指定对象类名
 
 输出：void (^)(id obj 指定对象的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) requestDic4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg)) result convertClassName:(NSString *)className{
    [self request4MethodName:name parameters:parameters result:result type:1 convertClassName:className isCustomInterface:NO];
}

/**
 mark by vi_chen
 描述：通用接品多列查询，返回数组结构－－>字典结构
 输入参数：
 name：方法名
 parameters:请求参数
 
 输出：void (^)(NSArray *arr 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) requestArr4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(NSArray *arr,int  status,NSString *msg)) result{
    [self request4MethodName:name parameters:parameters result:result type:2 convertClassName:nil isCustomInterface:NO];
}
/**
 mark by vi_chen
 描述：通用接品多列查询，返回数组－－>指定对象结构
 输入参数：
 name：方法名
 parameters:请求参数
 className：指定对象类名
 
 输出：void (^)(NSArray *arr 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) requestArr4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(NSArray *arr,int  status,NSString *msg)) result convertClassName:(NSString *)className{
    [self request4MethodName:name parameters:parameters result:result type:2 convertClassName:className isCustomInterface:NO];
}


-(void) getImage {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    UIImageView *imageView;
    [imageView sd_setImageWithURL:[NSURL URLWithString:URL]];
}


#pragma mark 自定义接口

/**
 mark by vi_chen
 描述：通用接品单列查询，返回字符串类型
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 
 输出：void (^)(NSString *str 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) customRequestStr4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSString *str,int  status,NSString *msg)) result
{
    [self customRequest4MethodName:name controller:controllerName parameters:parameters result:result type:0 convertClassName:nil isCustomInterface:YES];
}

/**
 mark by vi_chen
 描述：通用接品单列查询，返回字典结构
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 
 输出：void (^)(NSDictionary *dic 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) customRequestDic4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSDictionary *dic,int  status,NSString *msg)) result
{
    [self customRequest4MethodName:name controller:controllerName parameters:parameters result:result type:1 convertClassName:nil isCustomInterface:YES];
}

/**
 mark by vi_chen
 描述：通用接品单列查询，返回指定对象结构
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 className：指定对象类名
 
 输出：void (^)(id obj 指定对象的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) customRequestDic4MethodName:(NSString *)name controller:controllerName parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg)) result convertClassName:(NSString *)className
{
    [self customRequest4MethodName:name controller:controllerName parameters:parameters result:result type:3 convertClassName:className isCustomInterface:YES];
}

/**
 mark by vi_chen
 描述：通用接品多列查询，返回数组结构－－>字典结构
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 
 输出：void (^)(NSArray *arr 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) customRequestArr4MethodName:(NSString *)name controller:controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSArray *arr,int  status,NSString *msg)) result
{
    [self customRequest4MethodName:name controller:controllerName parameters:parameters result:result type:2 convertClassName:nil isCustomInterface:YES];
}

/**
 mark by vi_chen
 描述：通用接品多列查询，返回数组－－>指定对象结构
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 className：指定对象类名
 
 输出：void (^)(NSArray *arr 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) customRequestArr4MethodName:(NSString *)name controller:controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSArray *arr,int  status,NSString *msg)) result convertClassName:(NSString *)className
{
    [self customRequest4MethodName:name controller:controllerName parameters:parameters result:result type:2 convertClassName:className isCustomInterface:YES];
}

/**
 mark by vi_chen
 
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 type 1:单列，返回字典结构 2:多列，返回数组结构，数组里面的每一个元素都是字典
 isCustom:是否是自定义接口
 
 type 1:单列，返回字典结构 2:多列，返回数组结构，数组里面的每一个元素都是字典
 输出：void (^)(NSDictionary *dic 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) customRequest4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(id objs,int  status,NSString *msg)) result type:(int) type convertClassName:(NSString *)calssName isCustomInterface:(BOOL) isCustom
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    NSString *postURL =  [[NSMutableString stringWithString:mainURL] stringByAppendingFormat:@"%@.do?%@&sessionkey=%@",isCustom==YES?controllerName:URL,name,@"token"];
    // NSLog(@"postURL:%@",postURL);
    [manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *resultMsg;
        int statusInt;
        // NSLog(@"result:%@",resultMsg);
        NSDictionary *obj = [resultStr objectFromJSONString];
        int temp = [[obj valueForKey:@"success"] intValue];
        resultMsg = [obj valueForKey:@"msgCode"];
        // NSLog(@"result:%i,resultMsg:%@",temp,resultMsg);
        if (obj==nil) {
            NSLog(@"结果为空!");
            statusInt = NO;
            resultMsg = @"请求失败，请检查网络环境!";
            result(nil,statusInt,resultMsg);
            return;
        }
        
        
        id resultArray = [obj valueForKey:@"obj"];
        
        if(resultArray==nil || resultArray==[NSNull null]) {
            statusInt = temp!=0?2:NO;
            result(nil,statusInt,resultMsg);
            return ;
        }
        
        
        id resultObj;
        if (type == 0) {
            resultObj = resultArray;
            
            if (temp!=0) {
                if (resultArray != nil)
                    statusInt = 1;
                else
                    statusInt = 2;
            } else {
                statusInt = NO;
            }
            
        }else {
            if(type==1) {
                //                resultObj=calssName==nil?[resultArray firstObject]:[ReflectUtil reflectDataWithClassName:calssName otherObject:[resultArray firstObject] isList:NO];
                resultObj=calssName==nil?[resultArray firstObject]:[ReflectUtil reflectDataWithClassName:calssName otherObject:[resultArray firstObject]];
            }else if (type==2){
                resultObj=calssName==nil?resultArray:[ReflectUtil reflectDataWithClassName:calssName otherObject:resultArray isList:YES];
            }else if (type==3){
                resultObj = [ReflectUtil reflectDataWithClassName:calssName otherObject:resultArray];
            }
            
            //            if (temp!=0) {
            //                if ([resultArray count] >0)
            //                    statusInt = 1;
            //                else
            //                    statusInt = 2;
            //            } else {
            //                statusInt = NO;
            //            }
        }
        
        
        
        
        
        //返回列表
        result(resultObj,statusInt,resultMsg);
        
        // NSLog(@"%@", [NSThread currentThread]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"%@", error);
        result(nil,-1,@"网络异常！请检查您的服务器！");
        
    }];
    
}
/**
 自定义接口
 mark by vi_chen
 描述：通用接品单列查询，返回图片的二进制数据
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 
 输出：void (^)(NSData *imageData 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) customRequestImage4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSData *imageDate)) result
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    NSString *postURL =  [[NSMutableString stringWithString:mainURL] stringByAppendingFormat:@"%@.do?%@&sessionkey=%@",controllerName,name,@"token"];
    [manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *data = responseObject;
        result(data);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"%@", error);
        result(nil);
        
    }];
}
/**
 mark by vi_chen
 描述：加载网络图片资源
 输入参数：
 imageView：需要加载的图片view
 imageUrl : 图片地址
 */
+(void)setImage:(UIImageView*)imageView url:(NSString*)imageUrl {
//    UserOption *userOption = [UserOption userOption];
//    //  NSLog(@"imageView:%@,url:%@",imageView,imageUrl);
//    if (imageView!=nil && imageUrl!=nil && ![imageUrl isEqual:@""]) {
//        if (netWorkState!=AFNetworkReachabilityStatusReachableViaWiFi && userOption.isUnpatterned) {
//            imageUrl = nil;
//        }
//        //  NSLog(@"url:%@",imageUrl);
//        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"not_img.png"] options:SDWebImageLowPriority|SDWebImageRetryFailed];
//        
//        //        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        //       [manager downloadWithURL:[NSURL URLWithString:imageUrl] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//        //
//        //       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//        //           if (image) {
//        //               [imageView setImage:image];
//        //           }
//        //       }];
//        
//    }
    
}

/**
 mark by dong
 描述：只获取结果返回id结构
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 */
- (void) customRequestObjMethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(id obj, int status, NSString *msg)) result
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *postURL =  [[NSMutableString stringWithString:mainURL] stringByAppendingFormat:@"%@.do?%@&sessionkey=%@",controllerName,name,@"token"];
    
    [manager POST:postURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [resultStr objectFromJSONString];
        // NSLog(@"dic:%@",dic);
        
        NSDictionary *resultArray = [dic valueForKey:@"obj"];
        //        NSLog(@"%@",resultArray);
        //        NSLog(@"%@",[resultArray valueForKey:@"resultCode"])
        int status = [[dic valueForKey:@"success"] intValue];
        NSString *resultMsg = [dic valueForKey:@"msg"];
        result(resultArray,status,resultMsg);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *dict = @{@"error":error};
        
        result(dict,-1,@"网络异常！请检查您的服务器！");
    }];
    
}


@end
