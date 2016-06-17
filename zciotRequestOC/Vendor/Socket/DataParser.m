//
//  DataParser.m
//  kd
//
//  Created by zcwl_mac_mini on 14-12-16.
//  Copyright (c) 2014年 zciot. All rights reserved.
//

#import "DataParser.h"
#import "JSONKit.h"
#import "UserModel.h"
#import "ZBase64.h"
#import "ReflectUtil.h"
#import "AppDelegate.h"
#import "DeviceModel.h"
/*
#import "MessageModel.h"
#import "DbDao.h"

#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "CollectGoodsModel.h"
#import "IMAccountModel.h"
#import "ShareModel.h"
*/
#define KSendDataFormat @"#[dataBody]*\n"

// Accpet
#define DataType_Recive_buslist                 99

// 换行符
#define dataBodyEnterCharWindows    @"\r\n"
#define dataBodyEnterCharUnix       @"\n"
#define dataBodyEnterCharMacOS       @"\r"

// 消息分割符号
#define dataSplitChar       @"#"
// 结束符号
#define dataEndChar         @"*"
// 数据分割符号
#define dataBodySplitChar   @"&"

//#05&orderId|订单id*
@implementation DataParser

static DataParser *sharedInstance = nil;

- (id) init {
    if (!sharedInstance) {
        if ((self = [super init])) {
            //Initialize the instance here.
        }
        sharedInstance = self;
    } else if (self != sharedInstance) {
        self = sharedInstance;
    }
    return self;
}

+ (id) getInstance {
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (id) handleAccpetData:(NSString*) accpetData {
    if (!accpetData || [@"" isEqualToString:accpetData] || [dataBodyEnterCharWindows isEqualToString:accpetData] || [dataBodyEnterCharUnix isEqualToString:accpetData]) {
        return nil;
    }
    NSLog(@"accpetData = %@",accpetData);
    NSString* l_accpetData = accpetData;
    l_accpetData = [l_accpetData substringFromIndex:1];
    l_accpetData = [l_accpetData substringToIndex:l_accpetData.length-1];
    if ([l_accpetData hasSuffix:dataEndChar]) {
        l_accpetData = [l_accpetData substringToIndex:l_accpetData.length-1];
    }
    NSArray *arr = [l_accpetData componentsSeparatedByString:dataBodySplitChar];
    if (arr.count>=3) {
        NSString *type = arr[1];
        NSString *result = arr[2];
        result = [ZBase64 decodeBase64:result];
        if ([WJDataType_Login isEqualToString:type]) {
            //登录返回
            
            
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            UserModel *dto = [ReflectUtil reflectDataWithClassName:@"UserModel" otherObject:resultsDictionary];
            return [NSDictionary dictionaryWithObjectsAndKeys:WJDataType_Login,@"dataType",dto,@"data", nil];
        }else if ([WJDataType_Register isEqualToString:type]) {
            //注册返回
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            NSString *msgCode = [resultsDictionary objectForKey:@"msgCode"];
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",msgCode,@"data", nil];
        }else if ([WJDataType_ResetPwd isEqualToString:type]) {
            //重置密码返回
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            NSString *msgCode = [resultsDictionary objectForKey:@"msgCode"];
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",msgCode,@"data", nil];
        }else if ([WJDataType_SMS isEqualToString:type]) {
            //获取短信验证返回
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",resultsDictionary,@"data", nil];
        }else if ([WJDataType_YUYIN isEqualToString:type]) {
            //获取短信验证返回
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",resultsDictionary,@"data", nil];
        }
        else if ([WJDataType_ModifyAlias isEqualToString:type]) {
            //修改昵称 返回
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            NSString *msgCode = [resultsDictionary objectForKey:@"msgCode"];
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",msgCode,@"data", nil];
        }else if ([WJDataType_ModifyPwd isEqualToString:type]) {
            //修改密码 返回
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            NSString *msgCode = [resultsDictionary objectForKey:@"msgCode"];
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",msgCode,@"data", nil];
        }else if ([WJDataType_Feedback isEqualToString:type]) {
            //反馈 返回
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            NSString *msgCode = [resultsDictionary objectForKey:@"msgCode"];
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",msgCode,@"data", nil];
        }else if ([WJDataType_SetDev isEqualToString:type]) {
            //反馈 返回
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            NSString *msgCode = [resultsDictionary objectForKey:@"msgCode"];
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",msgCode,@"data", nil];
        }else if ([WJDataType_HeartBeat isEqualToString:type]) {
            //心跳
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            
            NSString *msgCode = [resultsDictionary objectForKey:@"msgCode"];
            return [NSDictionary dictionaryWithObjectsAndKeys:WJDataType_HeartBeat,@"dataType",msgCode,@"data", nil];
        }else if ([WJDataType_StudentList isEqualToString:type]) {
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            NSString *msgCode = [resultsDictionary objectForKey:@"msgCode"];
            NSMutableArray *arr_dev = [NSMutableArray new];
            if ([SocketSuccessed isEqualToString:msgCode]) {
                NSArray *arr = [resultsDictionary objectForKey:@"areaList"];
                if (arr && arr.count>=1) {
                    
                    for (int i=0; i<arr.count; i++) {
                        NSDictionary *dict = arr[i];
                        DeviceModel *dto = [ReflectUtil reflectDataWithClassName:@"DeviceModel" otherObject:dict];
                        NSString *str = [dict objectForKey:@"studentId"];
                        
                        NSNumber *num =  [NSNumber numberWithLongLong:[str longLongValue]];
                        dto.studentId = [num stringValue];
                        //dto.devId = [dict objectForKey:@"id"];
                        [arr_dev addObject:dto];
                    }
                }
            }
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",msgCode,@"data",arr_dev,@"arr", nil];
        }else if ([WJDataType_VedioList isEqualToString:type]) {
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            NSString *msgCode = [resultsDictionary objectForKey:@"msgCode"];
            NSMutableArray *arr_dev = [NSMutableArray new];
            if ([SocketSuccessed isEqualToString:msgCode]) {
                NSArray *arr = [resultsDictionary objectForKey:@"areaList"];
                if (arr && arr.count>=1) {
                    
                    for (int i=0; i<arr.count; i++) {
                        NSDictionary *dict = arr[i];
                        DeviceModel *dto = [ReflectUtil reflectDataWithClassName:@"DeviceModel" otherObject:dict];
                        dto.devId = [dict objectForKey:@"id"];
                        
                        NSString *str = [dict objectForKey:@"type"];
                        
                        NSNumber *num =  [NSNumber numberWithLongLong:[str intValue]];
                        dto.type = [num stringValue];
                        
                        [arr_dev addObject:dto];
                    }
                }
            }
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",msgCode,@"data",arr_dev,@"arr", nil];
        }else if ([WJDataType_Feedback isEqualToString:type]) {
            //意见反馈返回
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            NSString *msgCode = [resultsDictionary objectForKey:@"msgCode"];
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",msgCode,@"data", nil];
        }else if ([WJDataType_HTMLVERSION isEqual:type]){
            
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",resultsDictionary,@"data", nil];
        }else if ([WJDataType_APPVERSION isEqual:type]){
            
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resultsDictionary = [jsonData objectFromJSONData];
            return [NSDictionary dictionaryWithObjectsAndKeys:type,@"dataType",resultsDictionary,@"data", nil];
        }
        
    }
    return nil;
}

-(AppDelegate*) appDelegate {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (NSString*) getSocketSendData:(NSString*) params{
    return nil;
}
//#99&02&{"userId":"6","mobilePhone":"13714393515","userName":"liphone","sex":"0","msgCode":"0"}*
#pragma mark - 组装要发送的数据发送数据
- (NSString*) getSocketSendData:(NSString*)dataType params:(NSString*) params {
    NSString* senddata = KSendDataFormat;
    NSString *dataBody = dataType;
    if (params && ![@"" isEqualToString:params]) {
        
        dataBody = [NSString stringWithFormat:@"%@%@%@",dataType,dataBodySplitChar,params];
    }NSLog(@"发送数据-dataBody = %@",dataBody);
    dataBody = [ZBase64 encodeBase64:dataBody];
    
    senddata = [senddata stringByReplacingOccurrencesOfString:@"[dataBody]" withString:[NSString stringWithFormat:@"%@",dataBody]];
    
    return senddata;
}

@end
