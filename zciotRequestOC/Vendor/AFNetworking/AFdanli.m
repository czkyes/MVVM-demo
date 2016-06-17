//
//  AFdanli.m
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/8.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "AFdanli.h"

@implementation AFdanli
@synthesize manager = _manager;
static AFdanli *_instance = nil;
+(AFdanli *)shareInstance
{
    if (_instance == nil) {
        _instance = [[super alloc]init];
    }
    return _instance;
}
- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}
@end
