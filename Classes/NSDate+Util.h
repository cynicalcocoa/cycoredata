//
//  NSDate+Util.h
//  CaptureMedia-Library
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Util)

+ (NSString*)timeAgoWithDate:(NSDate*)date;
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateForUnixString:(NSString *)timestamp;
+ (NSDate *)dateFromMicroSecondsString:(NSString *)timestamp;
- (long double)inMicroSeconds;
- (NSString *)inMicroSecondsString;

@end
