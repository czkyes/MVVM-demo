//
//  NetWorkingUtil.h
//  AFNetworkingTest
//
//  Created by book on 14-9-1.
//  Copyright (c) 2014年 vi_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class InfoMsg;
@interface NetWorkingUtil : NSObject

+ (NetWorkingUtil *)getNetWorkingUtil;


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
-(void) requestDic4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(NSDictionary *dic,int  status,NSString *msg)) result;

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
-(void) requestDic4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg)) result convertClassName:(NSString *)className;

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
-(void) requestArr4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(NSArray *arr,int  status,NSString *msg)) result;

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
-(void) requestArr4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(NSArray *arr,int  status,NSString *msg)) result convertClassName:(NSString *)className ;

/**
 mark by vi_chen
 
 输入参数：
 name：方法名
 parameters:请求参数
 type 1:单列，返回字典结构 2:多列，返回数组结构，数组里面的每一个元素都是字典
 isCustom:是否是自定义接口
 
 type 1:单列，返回字典结构 2:多列，返回数组结构，数组里面的每一个元素都是字典
 输出：void (^)(NSDictionary *dic 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) request4MethodName:(NSString *)name parameters:(NSDictionary *)parameters result:(void (^)(id objs,int  status,NSString *msg)) result type:(int) type convertClassName:(NSString *)calssName isCustomInterface:(BOOL) isCustom;




/**
 自定义接口
 mark by lxx
 描述：通用接品单列查询，返回图片的二进制数据
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 
 输出：void (^)(NSData *imageData 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) customRequestImage4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSData *imageData)) result;
/**   
 自定义接口
 mark by lxx
 描述：通用接品单列查询，返回字符串类型
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 
 输出：void (^)(NSDictionary *dic 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) customRequestStr4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSString *str,int  status,NSString *msg)) result;
/**  
 自定义接口
 mark by lxx
 描述：通用接品单列查询，返回字典结构
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 
 输出：void (^)(NSDictionary *dic 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) customRequestDic4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSDictionary *dic,int  status,NSString *msg)) result;

/**  
 自定义接口
 mark by lxx
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
-(void) customRequestDic4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(id obj,int  status,NSString *msg)) result convertClassName:(NSString *)className;

/**  
 自定义接口
 mark by lxx
 描述：通用接品多列查询，返回数组结构－－>字典结构
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 
 输出：void (^)(NSArray *arr 真正的结果值
 ,int status  -1:网络异常 0:失败 1;成功，并有结查值，2;成功，但无结果值
 ,NSString *msg 信息)
 */
-(void) customRequestArr4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSArray *arr,int  status,NSString *msg)) result;

/**  
 自定义接口
 mark by lxx
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
-(void) customRequestArr4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(NSArray *arr,int  status,NSString *msg)) result convertClassName:(NSString *)className;

/**  
 自定义接口
 mark by lxx
 
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
-(void) customRequest4MethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(id objs,int  status,NSString *msg)) result type:(int) type convertClassName:(NSString *)calssName isCustomInterface:(BOOL) isCustom;

/**
 mark by vi_chen
 描述：加载网络图片资源
 输入参数：
 imageView：需要加载的图片view
 imageUrl : 图片地址
 */
+ (void)setImage:(UIImageView*)imageView url:(NSString*)imageUrl;

+ (void)reach;


/**
 mark by dong
 描述：只获取结果返回字典类型
 输入参数：
 name：方法名
 controllerName : 所属控制器
 parameters:请求参数
 */

- (void) customRequestObjMethodName:(NSString *)name controller:(NSString *)controllerName parameters:(NSDictionary *)parameters result:(void (^)(id obj, int status, NSString *msg)) result;
@end
