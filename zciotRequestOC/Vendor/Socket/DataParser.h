//
//  DataParser.h
//  kd
//
//  Created by zcwl_mac_mini on 14-12-16.
//  Copyright (c) 2014年 zciot. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface DataParser : NSObject

+ (id) getInstance;

#pragma mark - //////////////////////////////////////////////////
#pragma mark - 发送数据处理
- (NSString*) getSocketSendData:(NSString*) params;
- (NSString*) getSendData:(int) dataType params:(NSString*) params ;

- (NSString*) getSocketSendData:(NSString*)dataType params:(NSString*) params ;

#pragma mark - //////////////////////////////////////////////////
#pragma mark - 响应数据数据处理
- (id) handleAccpetData:(NSString*) accpetData ;
@end
