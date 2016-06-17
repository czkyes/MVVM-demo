//
//  AFdanli.h
//  zciotRequestOC
//
//  Created by AlexLau on 16/4/8.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFdanli : NSObject
{
    AFHTTPRequestOperationManager *_manager;
}
@property(nonatomic,retain) AFHTTPRequestOperationManager *manager;
+(AFdanli *)shareInstance;
@end
