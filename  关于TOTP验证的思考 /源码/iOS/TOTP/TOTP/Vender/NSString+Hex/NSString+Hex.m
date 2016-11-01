//
//  NSString+Hex.m
//  TOTP
//
//  Created by 杜晓星 on 16/9/2.
//  Copyright © 2016年 杜晓星. All rights reserved.
//

#import "NSString+Hex.h"

@implementation NSString (Hex)

#pragma mark 十进 转 十六进制
- (NSString *)HEX {
	NSData *data = [self dataUsingEncoding:NSASCIIStringEncoding];
	static const char HexEncodeCharsLower[] = "0123456789abcdef";
	static const char HexEncodeChars[] = "0123456789ABCDEF";
	char *resultData;
	// malloc result data
	resultData = malloc([data length] * 2 + 1);
	// convert imgData(NSData) to char[]
	unsigned char *sourceData = ((unsigned char *)[data bytes]);
	NSUInteger length = [data length];

	BOOL isOutputLower = NO;

	if (isOutputLower) {
		for (NSUInteger index = 0; index < length; index++) {
			// set result data
			resultData[index * 2] =
			    HexEncodeCharsLower[(sourceData[index] >> 4)];
			resultData[index * 2 + 1] =
			    HexEncodeCharsLower[(sourceData[index] % 0x10)];
		}
	} else {
		for (NSUInteger index = 0; index < length; index++) {
			// set result data
			resultData[index * 2] =
			    HexEncodeChars[(sourceData[index] >> 4)];
			resultData[index * 2 + 1] =
			    HexEncodeChars[(sourceData[index] % 0x10)];
		}
	}
	resultData[[data length] * 2] = 0;

	// convert result(char[]) to NSString
	NSString *result = [NSString stringWithCString:resultData
					      encoding:NSASCIIStringEncoding];
	sourceData = nil;
	free(resultData);

	return result;
}
#pragma mark  十六进制 转 十进制
- (NSString *)REHEX {
	if (self.length == 0) {
		return nil;
	}

	static const unsigned char HexDecodeChars[] = {
	    0,  0,  0,  0, 0, 0,  0,  0,  0,  0,  0,  0, 0, 0, 0, 0, 0,
	    0,  0,  0,  0, 0, 0,  0,  0,  0,  0,  0,  0, 0, 0, 0, 0, 0,
	    0,  0,  0,  0, 0, 0,  0,  0,  0,  0,  0,  0, 0, 0, 0, 1, // 49
	    2,  3,  4,  5, 6, 7,  8,  9,  0,  0,		     // 59
	    0,  0,  0,  0, 0, 10, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 0,
	    0,  0,  0, // 79
	    0,  0,  0,  0, 0, 0,  0,  0,  0,  0,  0,  0, 0, 0, 0, 0, 0,
	    10, 11, 12, // 99
	    13, 14, 15};

	// convert data(NSString) to CString
	const char *source = [self cStringUsingEncoding:NSUTF8StringEncoding];
	// malloc buffer
	unsigned char *buffer;
	NSUInteger length = strlen(source) / 2;
	buffer = malloc(length);
	for (NSUInteger index = 0; index < length; index++) {
		buffer[index] = (HexDecodeChars[source[index * 2]] << 4) +
				(HexDecodeChars[source[index * 2 + 1]]);
	}
	// init result NSData
	NSData *result = [NSData dataWithBytes:buffer length:length];
	free(buffer);
	source = nil;

	return [[NSString alloc] initWithData:result
				     encoding:NSUTF8StringEncoding];
}

@end
