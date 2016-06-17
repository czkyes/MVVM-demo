//
//  Base64.h
//  HSAE-IOS
//
//  Created by Batty on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBase64 : NSObject{
    
}

+ (NSString *) encodeBase64:(NSString *) input;  
+ (NSString *) decodeBase64:(NSString *) input; 

@end
