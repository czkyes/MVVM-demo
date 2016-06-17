//
//  NSData+ZBase64.h
//  A
//
//  Created by zcwl_mac_mini on 15/3/25.
//  Copyright (c) 2015年 zciot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ZBase64)
+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;
@end
