//
//  NSDate+intervalToNow.h
//  CityBus2
//
//  Created by Alex on 13-12-23.
//  Copyright (c) 2013年 zciot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (intervalToNow)

#pragma mark - 计算时间差，返回秒（s）
+ (NSString*) timeIntervalToNow: (NSDate*) theDate ;

@end
