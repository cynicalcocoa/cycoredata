//
//  FixtureHelper.m
//  Capture
//
//  Created by hatebyte on 10/9/13.
//  Copyright (c) 2013 Capture. All rights reserved.
//

#import "CYFixtureHelper.h"

@implementation CYFixtureHelper

+ (NSDictionary *)dictionaryFromFixtureByName:(NSString *)fileName {
    return [CYFixtureHelper dictionaryFromFixtureByName:fileName inBundle:nil];
}

+ (NSDictionary *)dictionaryFromFixtureByName:(NSString *)fileName inBundle:(NSString *)bundleName {
    NSBundle *bundle = nil;
    if (!bundleName) {
        bundle                                              = [NSBundle mainBundle];
    } else {
        NSString *staticLibraryBundlePath                   = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
        bundle                                              = [NSBundle bundleWithPath:staticLibraryBundlePath];
    }
    
    NSString *filePath                                      = [bundle pathForResource:fileName ofType:@"json"];

    NSData *testData                                        = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *jsonInfo                                  = nil;
   
    if (testData) {
        NSError *error;
        id json                                             = [NSJSONSerialization JSONObjectWithData:testData options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            jsonInfo                                        = (NSDictionary *)json;
        } else {
            NSLog(@"error loading fixture: %@", [error userInfo]);
        }
    }
    
    return jsonInfo;
}

@end