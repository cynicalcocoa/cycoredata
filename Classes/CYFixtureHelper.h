//
//  FixtureHelper.h
//  Capture
//
//  Created by hatebyte on 10/9/13.
//  Copyright (c) 2013 Capture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYFixtureHelper : NSObject

+ (NSDictionary *)dictionaryFromFixtureByName:(NSString *)fileName;
+ (NSDictionary *)dictionaryFromFixtureByName:(NSString *)fileName inBundle:(NSString *)bundleName;

@end
