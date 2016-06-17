//
//  LXDGameRecord.h
//  zciotRequestOC
//
//  Created by AlexLau on 16/5/17.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXDGameRecord : NSObject<NSCoding>
@property (nonatomic, copy) NSString * userName;

@property (nonatomic, strong) NSDate * createDate;

@property (nonatomic, strong) NSNumber * score;


@end
