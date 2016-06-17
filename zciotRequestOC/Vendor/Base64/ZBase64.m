//
//  Base64.m
//  HSAE-IOS
//
//  Created by Batty on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZBase64.h"
#import "ZGTMBase64.h"

@implementation ZBase64
    

+ (NSString *) encodeBase64:(NSString *) input{  
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];  
    data = [ZGTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
    return base64String;  
}  



+ (NSString *) decodeBase64:(NSString *) input{  
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];  
    data = [ZGTMBase64 decodeData:data];  
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];  
    return string;  
}  


@end
