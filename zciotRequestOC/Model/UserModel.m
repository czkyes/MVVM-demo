//
//  UserModel.m
//  Microhome
//
//  Created by zcwl_mac_mini on 15/3/17.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel



-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.Id forKey:@"Id"];
    [aCoder encodeObject:self.isBindDevice forKey:@"isBindDevice"];
    //[aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.alias forKey:@"alias"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.mobilePhone forKey:@"phone"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.baobeiName forKey:@"baobeiName"];
    
    [aCoder encodeObject:self.verifyCode forKey:@"verifyCode"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.visitCount forKey:@"visitCount"];
    [aCoder encodeObject:self.userImage forKey:@"userImage"];
    [aCoder encodeObject:self.babyImage forKey:@"babyImage"];
    [aCoder encodeObject:self.msgCode forKey:@"msgCode"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.imei forKey:@"imei"];
    //[aCoder encodeObject:self.Sbimei forKey:@"Sbimei"];
    [aCoder encodeObject:self.Sbsim forKey:@"Sbsim"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.Id = [aDecoder decodeObjectForKey:@"Id"];
        self.isBindDevice = [aDecoder decodeObjectForKey:@"isBindDevice"];
        //self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.userName= [aDecoder decodeObjectForKey:@"userName"];
        self.alias = [aDecoder decodeObjectForKey:@"alias"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.password= [aDecoder decodeObjectForKey:@"password"];
        self.mobilePhone= [aDecoder decodeObjectForKey:@"phone"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        
        self.verifyCode = [aDecoder decodeObjectForKey:@"verifyCode"];
        
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.visitCount= [aDecoder decodeObjectForKey:@"visitCount"];
        self.userImage= [aDecoder decodeObjectForKey:@"userImage"];
        self.babyImage= [aDecoder decodeObjectForKey:@"babyImage"];
        self.msgCode= [aDecoder decodeObjectForKey:@"msgCode"];
        self.token= [aDecoder decodeObjectForKey:@"token"];
        self.imei= [aDecoder decodeObjectForKey:@"imei"];
        //self.Sbimei= [aDecoder decodeObjectForKey:@"Sbimei"];
        self.Sbsim= [aDecoder decodeObjectForKey:@"Sbsim"];
        self.baobeiName= [aDecoder decodeObjectForKey:@"baobeiName"];
    }
    return self;
}

@end
