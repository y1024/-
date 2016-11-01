//
//  NSString+Hex.h
//  TOTP
//
//  Created by 杜晓星 on 16/9/2.
//  Copyright © 2016年 杜晓星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hex)


// 十进 转 十六进制
- (NSString *)HEX;
// 十六进制 转 十进制
- (NSString *)REHEX;

@end
