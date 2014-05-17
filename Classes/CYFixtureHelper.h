//
//  FixtureHelper.h
//  Capture
//
//  Created by hatebyte on 10/9/13.
//  Copyright (c) 2013 Capture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYFixtureHelper : NSObject

/** Returns an `NSDictionary` of the contents in the `fileName.json` if the file is found in the `[NSBundle mainBundle]`
 *
 * @param fileName `NSString` The name of the `.json` file the read
 * @return An `NSDictionary` of the contents in the `fileName.json` if the file is found in the `[NSBundle mainBundle]`
 */
+ (NSDictionary *)dictionaryFromFixtureByName:(NSString *)fileName;


/** Returns an `NSDictionary` of the contents in the `fileName.json` if the file is found in an `NSBundle` named `bundleName`
 *
 * @param fileName `NSString` The name of the `.json` file the read
 * @param bundleName `NSString` The name of the `NSBundle` to search for the `fileName.json`
 * @return An `NSDictionary` of the contents in the `fileName.json` if the file is found in an `NSBundle` named `bundleName`
 */
+ (NSDictionary *)dictionaryFromFixtureByName:(NSString *)fileName inBundle:(NSString *)bundleName;

@end
