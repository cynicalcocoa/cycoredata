//
//  CYCoreData.h
//  Capture
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+CYCoreData.h"
#import "NSManagedObjectContext+CYCoreData.h"


@interface CYCoreData : NSObject


///-------------------------
/// @name Config
///-------------------------

/** Configures the file name for the .sqlite saved in the `NSCachesDirectory`. Tells CYCoreData the name of the `*.xcdatamodeld` to use and what bundle to search for it in
 *
 * @param dataBaseFileName `NSString` of the database file name that will get saved in the cache directory
 * @param withModelFileName `NSString` of the .xcdatamodeld in the bundle
 * @param bundleName `NSString` of the bundle name that contains the modelfile
 * @warning Must call before `[CYCoreData liason]`.
 * @warning Do not use if .xcdatamodeld is in the mainbundle.
 */
+ (void)configureSqliteFileName:(NSString *)dataBaseFileName withModelFileName:(NSString *)modelFileName inBundleName:(NSString *)bundleName;


/** Configures file name for the .sqlite saved in the `NSCachesDirectory`. Tells CYCoreData the name of the `*.xcdatamodeld` to use and assumes it is located in the main bundle
 *
 * @param dataBaseFileName `NSString` of the database file name that will get saved in the cache directory
 * @param withModelFileName `NSString` of the .xcdatamodeld in the bundle
 * @warning Must call before `[CYCoreData liason]`.
 */
+ (void)configureSqliteFileName:(NSString *)dataBaseFileName withModelFileName:(NSString *)modelFileName;


// NOTE: updateOrCreateObjectInContext by default searches the dictionary passedin for
// the key @"id" and fetches the`NSManagedObject`(User) by propertyKey @"uid". To change this use
// [configureModelUniqueIdentifier:ofDataType:withJSONSearchString:] mentioned above.


/** Sets the keys and type of the unique indexer for `NSManagedObjects`. This key is used to fetch unique `NSEntity` in the database.
 *
 * @param uniquePropertyKey `NSString` for the unique property key if the NSManagedObject; example @"uid"
 * @param uniqueObjectValueType `UniqueObjectValueType` type of value the uniquePropertyKey is
 * @param jsonSearchPropertyKey `NSString` the key the unique property will have on a JSON of for that object
 * @warning If called, must call before `[CYCoreData liason]`.
 */
+ (void)configureModelUniqueIdentifier:(NSString *)uniquePropertyKey
                            ofDataType:(UniqueObjectValueType)uniqueObjectValueType
                  withJSONSearchString:(NSString *)jsonSearchPropertyKey;


/** Utility method for `configureModelUniqueIdentifier:ofDataType:withJSONSearchString:`
 *
 * @param `UniqueIdentiferStruct` Predefined struct of the values passesd to `configureModelUniqueIdentifier:ofDataType:withJSONSearchString:`
 * @warning If called, must call before `[CYCoreData liason]`.
 */
+ (void)configureUniqueIdentifier:(UniqueIdentiferStruct)uniqueIdentiferStruct;


/** If set to `YES`, CYCoreData uses an NSInMemoryStoreType and does not write data to sqlite file via NSSQLiteStoreType.
 *
 * @example Unit testing.
 */
+ (void)setTesting:(BOOL)isTesting;


///-------------------------
/// @name Methods
///-------------------------

/** Return singleton instance of CYCoreData
 *
 * @return Return singleton instance of CYCoreData
 * @warning Must call  `configureSqliteFileName:withModelFileName` first.
 */
+ (instancetype)liason;


/** Empties database of all entities, destroys `NSManagedObject` model and `NSPersistantStoreCoordinator`.
 *
 * @warning Does not reset config class variables.
 */
+ (void)reset;


/** Returns `NSManagedObjectContext` of [CYCoreData liason].readContext private property. The concurrencyType is `NSMainQueueConcurrencyType` which means all fetched entities will be on the main runloop and suitable for view display.
 *
 * @return `NSManagedObjectContext` of [CYCoreData liason].readContext
 * @warning It is not wise to change or save to this context directly. ONLY READ
 */
+ (NSManagedObjectContext *)readContext;


/** Returns a brand `NSManagedObjectContext` of spawned off of the [CYCoreData readContext]. To update the database, fetch the `NSEntityDescriptions` from this context, create or modify as you see fit. When finished, immediately call either `[temporaryWriteContext saveSynchronously]` or `[temporaryWriteContext saveAsynchronously]`. This ensures that the changes will be pushed up to the readContext, then written to disk.
 *
 * @return `NSManagedObjectContext` of [CYCoreData liason].readContext
 * @warning It is not wise to change or save to this context directly. ONLY READ
 */
+ (NSManagedObjectContext *)temporaryWriteContext;


/** Calls a sychronous(blocking) action to the top `NSManagedObjectContext` to write the changes to disk.
 *
 * @example Call when app terminates or goes in to background.
 */
+ (void)saveSynchronously;


/** Calls a Asychronous(nonblocking) action to the top `NSManagedObjectContext` to write the changes to disk.
 *
 * @example Call when ever sychronous behavior is not desired.
 */
+ (void)saveAsynchronously;


/** For readContext `performBlockAndWait` pass `YES`. For readContext `performBlock` pass `NO`.
 *
 * @param andWait `BOOL` for identify call to context `performBlock` or `performBlockAndWait`
 */
+ (void)saveContextAndWait:(BOOL)andWait;

@end