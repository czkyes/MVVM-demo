//
//  LXDGameRecord.m
//  zciotRequestOC
//
//  Created by AlexLau on 16/5/17.
//  Copyright © 2016年 陈智琨. All rights reserved.
//

#import "LXDGameRecord.h"
static NSString * const kUserNameKey = @"userName";
static NSString * const kCreateDateKey = @"CreateDate";
static NSString * const kScoreKey = @"Score";
@implementation LXDGameRecord
#pragma mark - NSCoding

/** 协议方法-对数据进行反序列化并读取*/

- (id)initWithCoder: (NSCoder *)aDecoder
{
    if(self = [super init])
    {
    self.userName = [aDecoder decodeObjectForKey: kUserNameKey];
    
    self.createDate = [aDecoder decodeObjectForKey: kCreateDateKey];
    
    self.score = [aDecoder decodeObjectForKey:kScoreKey];
    }
    return self;
}

/** 协议方法-对数据进行序列化*/

- (void)encodeWithCoder:(NSCoder *)aCoder

{
    
    [aCoder encodeObject: self.userName forKey: kUserNameKey];
    
    [aCoder encodeObject: self.createDate forKey: kCreateDateKey];
    
    [aCoder encodeObject: self.score forKey: kScoreKey];
    
}


@end
