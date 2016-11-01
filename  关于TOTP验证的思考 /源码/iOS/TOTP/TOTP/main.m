//
//  main.m
//  TOTP
//
//  Created by 杜晓星 on 16/9/2.
//  Copyright © 2016年 杜晓星. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSString+Hex.h"
#import "TOTPGenerator.h"

static NSString *seed = @"3132333435363738393031323334353637383930";
static NSString *seed32 = @"3132333435363738393031323334353637383930313233343536373839303132";
static NSString *seed64 = @"31323334353637383930313233343536373839303132333435363738393031323334353637383930313233343536373839303132333435363738393031323334";

static NSInteger period = 30;
static NSInteger digits = 8;


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSTimeZone *utc = [NSTimeZone timeZoneWithName:@"UTC"];
        [NSTimeZone setDefaultTimeZone:utc];
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";

        NSArray *algorithms = @[kOTPGeneratorSHA1Algorithm,
                                kOTPGeneratorSHA256Algorithm,
                                kOTPGeneratorSHA512Algorithm];
        NSArray *keys = @[seed,
                          seed32,
                          seed64];
        
        NSArray *testTiems = @[@(59),
                               @(1111111109),
                               @(1111111111),
                               @(1234567890),
                               @(2000000000),
                               @(20000000000)];
        NSLog(@"+---------------+-----------------------+------------------+--------+--------+");
        NSLog(@"|  Time(sec)    |   Time (UTC format)   | Value of T(Hex)  |  TOTP  | Mode   |");
        NSLog(@"+---------------+-----------------------+------------------+--------+--------+");
        
        for (NSInteger i = 0; i < testTiems.count; i ++) {
            long long timestemp = [testTiems[i] longLongValue];
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestemp];
            
            for (NSInteger j = 0; j < algorithms.count ; j++) {
                TOTPGenerator *generator = [[TOTPGenerator alloc]initWithSecret:
                                            [[keys[j]REHEX] dataUsingEncoding:NSUTF8StringEncoding]
                                                                      algorithm:algorithms[j]
                                                                         digits:digits
                                                                         period:period];
                if (j == 0) {
                    NSLog(@"%@",[NSString stringWithFormat:@"|  %.11lld  |  %@  | %.16llX |%@| %@   |",
                                 timestemp,[format stringFromDate:date],
                                 (timestemp/period),
                                 [generator generateOTPForDate:date],
                                 algorithms[j]]);
                }else{
                    NSLog(@"%@",[NSString stringWithFormat:@"|  %.11lld  |  %@  | %.16llX |%@| %@ |",
                                 timestemp,[format stringFromDate:date],
                                 (timestemp/period),
                                 [generator generateOTPForDate:date],
                                 algorithms[j]]);
                }
            }
            
            NSLog(@"+---------------+-----------------------+------------------+--------+--------+");

            
            
        }
        
        
    }
    return 0;
}




