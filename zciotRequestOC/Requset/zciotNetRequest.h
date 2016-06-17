//
//  zciotNetRequest.h
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/7.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ZReachability.h"
#import "GCDAsyncSocket.h"
@class Reachability;
@interface zciotNetRequest : NSObject<GCDAsyncSocketDelegate>
{
    NSString* serverPortStr;//端口号
    /* GCDAsyncSocket */
    dispatch_queue_t getDataQueue ;
    // 心跳序号
    NSTimer* heartBeatTimer;
    int heartbeatCount;
    // socket重新连接计数
    int socketConnCount;
    
    /* GCDAsyncSocket */
    
    // 地址解析计数
    int reverseAddrCount;
    NSMutableString  *_socketValue;
}
//申明一个方法
+ (zciotNetRequest *)shareSocket;
@property (nonatomic) BOOL hudIsHide;//hud是否隐藏了
@property (nonatomic, strong) NSString *responseData;
// 是否正常
@property(strong,nonatomic) Reachability*  hostReach;
@property(nonatomic) BOOL   isReachable;

// Socket客户端
@property (strong, nonatomic) GCDAsyncSocket *dataClient;

@property (nonatomic) BOOL isConnected;//是否连接
@property (nonatomic) BOOL isSocketLogin;//是否socket登录
@property (strong, nonatomic) NSDate *lastDate ;//心跳包最后发送时间
// 服务器地址 socket
@property (strong, nonatomic)NSString* serverIPStr;
#pragma socket
- (void) sendScoketMsgDict:(NSDictionary*) dict type:(NSString*)type;
#pragma 监测网络的可链接性
+ (BOOL) ZciotNetWorkReachabilityWithURLString:(NSString *) strUrl;

#pragma POST请求
+ (void) ZciotRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (ReturnValueBlock) block
                   WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                     WithFailureBlock: (FailureBlock) failureBlock;

#pragma GET请求
+ (void) ZciotRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (ReturnValueBlock) block
                  WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                    WithFailureBlock: (FailureBlock) failureBlock;

//上传图片到服务器
+ (void)sendPhotoToDevDiv:(NSData *)imageData userId:(NSString *)userId;

@end
