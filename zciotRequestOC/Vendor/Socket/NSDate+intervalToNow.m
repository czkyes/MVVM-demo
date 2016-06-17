//
//  NSDate+intervalToNow.m
//  CityBus2
//
//  Created by Alex on 13-12-23.
//  Copyright (c) 2013年 zciot. All rights reserved.
//

#import "NSDate+intervalToNow.h"

@implementation NSDate (intervalToNow)

#pragma mark - 计算时间差，返回秒（s）
+ (NSString*)timeIntervalToNow: (NSDate*) theDate
{
    NSString* timeString=@"";
    NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* d = theDate;
    NSTimeInterval late = [d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    
    NSTimeInterval interval=now-late;
    //    if(interval/3600<1) {
    //        NSLog(@"=====%@",timeString);
    
    timeString = [NSString stringWithFormat:@"%f",interval];
    //NSLog(@"=====%@",timeString);
    return timeString;
}

@end
