//
//  DeviceModel.h
//  Microhome
//
//  Created by zcwl_mac_mini on 15/3/24.
//  Copyright (c) 2015年 user. All rights reserved.
//  设备和视频共用

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject

@property (copy, nonatomic) NSString * devId;
@property (copy, nonatomic) NSString * name;//学生姓名
@property (copy, nonatomic) NSString * imei;//设备号
@property (copy, nonatomic) NSString * studentId;// 学生id
@property (copy, nonatomic) NSString * defaultDisplay;// 1是默认值0不是
@property (copy, nonatomic) NSString * parentId;// 家长id


//视频
@property (copy, nonatomic) NSString * url; // 直播为pid，点播为url'
@property (copy, nonatomic) NSString * type;//1 直播，2点播
@property (copy, nonatomic) NSString * ip;//ip
@property (copy, nonatomic) NSString * port;//端口

@end
