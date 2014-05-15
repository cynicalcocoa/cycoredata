//
//  NSDate+Util.m
//  CaptureMedia-Library
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (Util)

+ (NSString*)timeAgoWithDate:(NSDate*)date {
    NSDictionary *timeScale                         = @{@"second"   :@1,
                                                        @"minute"   :@60,
                                                        @"hour"     :@3600,
                                                        @"day"      :@86400,
                                                        @"week"     :@605800,
                                                        @"month"    :@2629743,
                                                        @"year"     :@31556926};
    NSString *scale;
    int timeAgo                                     = 0-(int)[date timeIntervalSinceNow];
    if (timeAgo < 60) {
        scale                                       = @"second";
    } else if (timeAgo < 3600) {
        scale                                       = @"minute";
    } else if (timeAgo < 86400) {
        scale                                       = @"hour";
    } else if (timeAgo < 605800) {
        scale                                       = @"day";
    } else if (timeAgo < 2629743) {
        scale                                       = @"week";
    } else if (timeAgo < 31556926) {
        scale                                       = @"month";
    } else {
        scale                                       = @"year";
    }
    timeAgo                                         = timeAgo/[[timeScale objectForKey:scale] integerValue];
    NSString *s                                     = @"";
    if (timeAgo > 1) {
        s                                           = @"s";
    }
    return [NSString stringWithFormat:@"%d %@%@ ago", timeAgo, scale, s];
}

+ (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *dateFormatter                  = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone                          = [NSTimeZone timeZoneForSecondsFromGMT:0];
    dateFormatter.dateFormat                        = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return [dateFormatter dateFromString:string];
}

+ (NSDate *)dateForUnixString:(NSString *)timestamp {
    return [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
}

+ (NSDate *)dateFromMicroSecondsString:(NSString *)timestamp {
    long double microsecondsDouble                  = floorl([timestamp doubleValue]);
    long double secondsDouble                       = microsecondsDouble / (double)100000;
    return [NSDate dateWithTimeIntervalSince1970:secondsDouble];
}

- (long double)inMicroSeconds {
    long double secondsDouble                       = (long double)[self timeIntervalSince1970];
    return secondsDouble * 100000;
}

- (NSString *)inMicroSecondsString {
    return [NSString stringWithFormat:@"%.Lf", [self inMicroSeconds]];
}

@end
