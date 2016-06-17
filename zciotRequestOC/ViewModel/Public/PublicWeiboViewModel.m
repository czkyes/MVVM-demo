//
//  PublicWeiboViewModel.m
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/7.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "PublicWeiboViewModel.h"

@implementation PublicWeiboViewModel
//网络请求获取电子围栏列表数据
-(void)fetchDianziWeilan:(NSDictionary *)dition address:(NSString *)address
{
    [self zciotBaseFetch:dition address:address];
   [self returnChuli:^(id Chuli) {
       [self fetchValueWith:Chuli];//VM基类返回的数据
   }];
    
}
//对VM返回的数据进行处理
-(void)fetchValueWith: (id)returnValue
{
    //对从后台获取的数据进行处理，然后传给ViewController层进行处理
    //NSLog(@"%@",returnValue);
    if ([returnValue isKindOfClass:[NSString class]]) {
        //NSLog(@"%@",returnValue);//返回msgCode不为0的时候
        [SVProgressHUD showErrorWithStatus:@"获取失败" duration:1.0];
    }else{

        NSArray *arr = returnValue[@"list"];
        NSMutableArray *publicModelArray = [[NSMutableArray alloc]initWithCapacity:arr.count];

        for (int i = 0; i<arr.count; i++) {
            NSDictionary *json =arr [i];
            NSError *err = nil;
            PublicModel *publicModel = [[PublicModel alloc]initWithDictionary:json error:&err];
           [publicModelArray addObject:publicModel];
       }
        self.returnBlock(publicModelArray);
        
    }
}

@end
