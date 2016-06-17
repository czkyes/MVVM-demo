//
//  UserModel.h
//  Microhome
//
//  Created by zcwl_mac_mini on 15/3/17.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>
@property (copy, nonatomic) NSString *  Id;
@property (copy,nonatomic) NSString *kdid;
//@property (copy, nonatomic) NSString *  userId;
@property (copy, nonatomic) NSString *  isBindDevice;
@property (copy, nonatomic) NSString *  email;
@property (copy, nonatomic) NSString *  userName;		//用户名
@property (copy, nonatomic) NSString *  alias;//昵称
@property (copy, nonatomic) NSString *  birthday;//生日
@property (copy, nonatomic) NSString *  password;
@property (copy, nonatomic) NSString *  mobilePhone;	//手机号
@property (copy, nonatomic) NSString *  sex;		//性别
@property (copy, nonatomic) NSString *  age;		//年龄
@property (copy, nonatomic) NSString *  verifyCode;//注册验证码
@property (copy, nonatomic) NSString * visitCount;//访问次数
@property (copy, nonatomic) NSString *  userImage;//用户图像
@property (copy, nonatomic) NSString *  babyImage;//宝贝图像
@property (copy, nonatomic) NSString *  imei;//android登录手机设备号
@property (copy, nonatomic) NSString *  Sbimei;
@property (copy, nonatomic) NSString *  Sbsim;
@property (copy, nonatomic) NSString *  token;//ios登录手机设备号
@property (copy, nonatomic) NSString * msgCode;//状态
@property (copy, nonatomic) NSString * zdWenben;
@property (copy, nonatomic) NSString *chongf;
@property (copy, nonatomic)NSString *dianji;
@property (copy, nonatomic) NSString *baobeiName;
@property (copy, nonatomic) NSString *baobeiPhone;
@property (copy, nonatomic) NSString *now;
@property (copy, nonatomic) NSString *last;
@property (copy, nonatomic) NSString *deviceStatus;
@property (strong, nonatomic) NSArray *nameStatus;
@property (strong, nonatomic) NSMutableArray *nameAlias;
@property (nonatomic,copy)NSString *flag;
@property (nonatomic) NSInteger dianziF;
@property (nonatomic) NSUInteger count;
@property (nonatomic)NSInteger index;
//@property (nonatomic,strong)WJLocationViewController *wjlo;
@end
