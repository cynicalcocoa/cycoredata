//
//  ExampleCYData.h
//  CYCoreData
//
//  Created by hatebyte on 8/25/14.
//  Copyright (c) 2014 cynicalcocoa. All rights reserved.
//

#import "CYCoreData.h"

@interface ExampleCYData : CYCoreData

@end


@interface NSManagedObjectContext (CYCoreDataInstance)

/** Calls a sychronous(performBlockAndWait) action to the top parent `NSManagedObjectContext` to write the changes to disk. Changes written to a `temporaryWriteContext` are immediately avaible through the `readContext`.
 *
 * @warning Only call from an `NSManagedObjectContext` returned from `[CYCoreData temporaryWriteContext]`.
 */
- (void)saveSynchronously;


/** Calls a asychronous(performBlock) action to the top parent `NSManagedObjectContext` to write the changes to disk. Changes written to a `temporaryWriteContext` are immediately avaible through the `readContext`.
 *
 * @warning Only call from an `NSManagedObjectContext` returned from `[CYCoreData temporaryWriteContext]`.
 */
- (void)saveAsynchronously;

@end


