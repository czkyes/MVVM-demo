//
//  ViewModelClass.h
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/7.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicModel.h"
@interface ViewModelClass : NSObject
@property (strong, nonatomic) ReturnValueBlock returnBlock;
@property (strong, nonatomic) ErrorCodeBlock errorBlock;
@property (strong, nonatomic) FailureBlock failureBlock;
@property (nonatomic,strong)ReturnChuli ChuliBlock;
- (void)returnChuli:(ReturnChuli)block;

// 传入交互的Block块
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock;

//网络请求获取数据
-(void)zciotBaseFetch:(NSDictionary *)diction address:(NSString *)address;

//跳转到微博详情页
//-(void) weiboDetailWithPublicModel: (PublicModel *) publicModel WithViewController: (UIViewController *)superController;
@end
