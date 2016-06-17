//
//  ReflectUtil.h
//  AFNetworkingTest
//
//  Created by book on 14-9-2.
//  Copyright (c) 2014年 vi_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReflectUtil : NSObject
/**
 mark by vi_chen
 
 描述：把字典的值转成对象
 输入参数：
 calssName：指定对象类名 比如：@"Student"
 otherObject:字典
 
 输出：返回转换完成的对象
 */
+ (id)reflectDataWithClassName:(NSString *) calssName otherObject:(NSObject*)dataSource;

/**
 mark by vi_chen
 
 描述：把数组－－>字典结构转换成数组－－>对象结构
 输入参数：
 calssName：指定对象类名 比如：@"Student"
 otherObject:数组－－>字典
 isList：YES:代表是数组－－>字典结构，NO:表示是字典结构
 
 输出：返回转换完成的对象
 */
+ (id)reflectDataWithClassName:(NSString *) calssName otherObject:(NSObject*)dataSource isList:(BOOL)isList;
@end
