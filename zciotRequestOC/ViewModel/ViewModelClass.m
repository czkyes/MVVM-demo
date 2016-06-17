//
//  ViewModelClass.m
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/7.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "ViewModelClass.h"

@implementation ViewModelClass

#pragma 接收传过来的block
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock
{
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
    _failureBlock = failureBlock;
}
- (void)returnChuli:(ReturnChuli)block;
{
    self.ChuliBlock = block;
}
//网络请求获取数据
-(void)zciotBaseFetch:(NSDictionary *)diction address:(NSString *)address
{
   // NSDictionary *parameter = @{@"userId": @"10038"
                               // };
    [zciotNetRequest ZciotRequestGETWithRequestURL:API_BASE_URL(address) WithParameter:diction WithReturnValeuBlock:^(id returnValue) {
        
        DDLog(@"%@", returnValue);
        self.ChuliBlock([self fetchValueSuccessWithDic:returnValue]);
        
    } WithErrorCodeBlock:^(id errorCode) {
        DDLog(@"%@", errorCode);
        [self errorCodeWithDic:errorCode];
        
    } WithFailureBlock:^{
        [self netFailure];
        DDLog(@"网络异常");
        
    }];
}
//获取成功，对数AF返回据进行处理
-(id)fetchValueSuccessWithDic: (NSDictionary *) returnValue
{
    //对从后台获取的数据进行处理，然后传给VM层进行处理
    NSString *msgCode = returnValue[@"msgCode"];
    if([msgCode isEqualToString:@"0"])
    {
        //NSArray *statuses = returnValue[@"list"];
        return returnValue;
    }
    return msgCode;
}




//对ErrorCode进行处理
-(void) errorCodeWithDic: (NSDictionary *) errorDic
{
    self.errorBlock(errorDic);
}

//对网路异常进行处理
-(void) netFailure
{
    self.failureBlock();
}

@end


