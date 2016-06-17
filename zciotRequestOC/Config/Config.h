//
//  Config.h
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/7.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#ifndef Config_h
#define Config_h
#define socketIP @"120.27.46.228"
//#define socketIP @"120.236.13.116"
#define socketPort @"17990"
#define TIMEDOUT_TIME 8             // 连接超时设置         8s
#define HeartbeatTimeInterval 180   // 心跳时间间隔         180s
#define HeartbeatInterval 60
#define GetDataTag 2
#define HeartbeatTag 1
#define WJDataType_HeartBeat              @"80"
#define WJDataType_StudentList            @"10"   //获取学生列表
#define KEY_DeviceTokenString           @"tokenString"  //token的值
/******* socket 数据 ********/
#define SocketSuccessed               @"0"    // 响应成功
#define SocketFailed                  @"1"    // 响应失败
#define SocketTimeout                 @"2"    // 超时
#define SocketSessionTimeout          @"10"   // 会话超时



#define WJDataType_Logout               @"000"    // 退出

#define WJDataType_Register               @"01"    // 注册
#define WJDataType_Login                  @"02"    // 登录
#define WJDataType_SMS                    @"03"   // 03 获取验证码
//type1注册 type0 找回验证码

#define WJDataType_ResetPwd               @"04"    // 重置密码
#define WJDataType_ModifyPwd              @"05"    // 修改密码
#define WJDataType_ModifyAlias            @"06"   // 修改昵称
#define WJDataType_ModifyHead             @"07"   // 修改头像

#define WJDataType_StudentList            @"10"   //获取学生列表
#define WJDataType_VedioList              @"11"   // 视频广场列表
#define WJDataType_SetDev              @"12"   // 设置默认设备

#define WJDataType_HXMsgSend                 @"64"   //发送信息hx

#define WJDataType_MsgPush                  @"81"   //消息推送
#define WJDataType_APPVERSION               @"82"   //APP 版本
#define WJDataType_HTMLVERSION              @"84"   //HTML 版本
#define WJDataType_YUYIN                    @"83"   //语音验证
#define WJDataType_Feedback                 @"85"   //意见反馈提交
//定义返回请求数据的block类型
typedef void (^ReturnValueBlock) (id returnValue);
typedef void (^ErrorCodeBlock) (id errorCode);
typedef void (^FailureBlock)();
typedef void (^NetWorkBlock)(BOOL netConnetState);
typedef void (^ReturnChuli)(id Chuli);
//typedef void (^ReturnShujv)(NSArray *Shujv);
//typedef void (^ReturnmsgCode)(NSString *msgCode);
#define DDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

//accessToken
#define ACCESSTOKEN @"2.00NofgBD0L1k4pc584f79cc48SKGdD"

//请求公共微博的网络接口
#define REQUESTPUBLICURL @"https://api.weibo.com/2/statuses/public_timeline.json"
#define API_BASE_URL(_URL_) [NSString stringWithFormat:@"http://120.27.46.228:8888/%@",_URL_]

#define SOURCE @"source"
#define TOKEN @"access_token"
#define COUNT @"count"

#define STATUSES @"statuses"
#define CREATETIME @"created_at"
#define WEIBOID @"id"
#define WEIBOTEXT @"text"
#define USER @"user"
#define UID @"id"
#define HEADIMAGEURL @"profile_image_url"
#define USERNAME @"screen_name"

#define	KScreenWidth	[[UIScreen mainScreen ] bounds].size.width
//小的
#define	KScreenHeight	[[UIScreen mainScreen ] applicationFrame].size.height
//大的
#define	KScreenBoundsHeight	[[UIScreen mainScreen ] bounds].size.height
#endif /* Config_h */
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
