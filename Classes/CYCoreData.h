//
//  CYCoreData.h
//  Capture
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CYFixtureHelper.h"
#import "NSManagedObject+CYCoreData.h"
#import "NSManagedObjectContext+CYCoreData.h"


@interface CYCoreData : NSObject

///-------------------------
/// @name Class methods
///-------------------------
/** Return singleton instance of CYCoreData
 *
 * @return Return singleton instance of CYCoreData
 * @warning Must call  `configureSqliteFileName:withModelFileName` first.
 */
+ (instancetype)liason;


/** Class method `reset` which forwards to the [[CYCoreDataInstance liason] reset] **/
+ (void)reset;


/** Class method `readContext` which forwards to the  [[CYCoreDataInstance liason] readContext] method
 *
 * @return `NSManagedObjectContext` of [CYCoreDataInstance liason].readContext
 */
+ (NSManagedObjectContext *)readContext;


/** Class method `temporaryWriteContext` which forwards to the [[CYCoreDataInstance liason] temporaryWriteContext] method
 *
 * @return `NSManagedObjectContext` of [[CYCoreDataInstance liason] temporaryWriteContext]
 */
+ (NSManagedObjectContext *)temporaryWriteContext;


/** Class method `saveSynchronously` which forwards to the [[CYCoreDataInstance liason] saveSynchronously] **/
+ (void)saveSynchronously;


/** Class method `saveAsynchronously` which forwards to the [[CYCoreDataInstance liason] saveAsynchronously] **/
+ (void)saveAsynchronously;


/** Class method `saveContextAndWait:` which forwards to the [[CYCoreDataInstance liason] saveContextAndWait:] method
 *
 * @param shouldWait `BOOL` to forward to the [[CYCoreDataInstance liason] saveContextAndWait:] method
 */
+ (void)saveContextAndWait:(BOOL)shouldWait;



///-------------------------
/// @name Properties
///-------------------------
/** The name `NSString` of the database file name that will get saved in the cache directory */
@property(nonatomic, strong) NSString *dataBaseFile;


/** The name `NSString` of the .xcdatamodeld in the bundle */
@property(nonatomic, strong) NSString *modelFile;


/** The name `NSString` of the bundle that contains the model file
 *
 * @warning If nil, CYCoreData is using the main bundle
 */
@property(nonatomic, strong) NSString *bundleName;


/** If set to `YES`, CYCoreData uses an NSInMemoryStoreType and does not write data to sqlite file via NSSQLiteStoreType.
 *
 * @example Unit testing.
 */
@property(nonatomic, assign) BOOL isTest;


/** Returns `NSManagedObjectContext` of [CYCoreData liason].readContext private property. The concurrencyType is `NSMainQueueConcurrencyType` which means all fetched entities will be on the main runloop and suitable for view display.
 *
 * @return `NSManagedObjectContext` of [CYCoreData liason].readContext
 * @warning It is not wise to change or save to this context directly. ONLY READ
 */
@property(nonatomic, strong) NSManagedObjectContext *readContext;




///-------------------------
/// @name Config
///-------------------------
/** Configures the file name for the .sqlite saved in the `NSCachesDirectory`. Tells CYCoreData the name of the `*.xcdatamodeld` to use and what bundle to search for it in
 *
 * @param dataBaseFileName `NSString` of the database file name that will get saved in the cache directory
 * @param withModelFileName `NSString` of the .xcdatamodeld in the bundle
 * @param bundleName `NSString` of the bundle name that contains the modelfile
 * @warning Do not use if .xcdatamodeld is in the mainbundle.
 */
- (id)initWithSqliteFileName:(NSString *)dataBaseFileName withModelFileName:(NSString *)modelFileName inBundleName:(NSString *)bundleName;


/** Configures the file name for the .sqlite saved in the `NSCachesDirectory`. Tells CYCoreData the name of the `*.xcdatamodeld` to use and assumes it is located in the main bundle
 *
 * @param dataBaseFileName `NSString` of the database file name that will get saved in the cache directory
 * @param withModelFileName `NSString` of the .xcdatamodeld in the bundle
 */
- (id)initWithSqliteFileName:(NSString *)dataBaseFileName withModelFileName:(NSString *)modelFileName;



/** Creates datebase from the model file
 * @warning Must be called to user CYCoredata funcationality
 */
- (void)createStoreAndManagedObjectModel;


/** Sets the keys for and type of unique indexer for `NSManagedObjects`. This key is used to fetch unique `NSEntity` in the database.
 *
 * @param uniquePropertyKey `NSString` for the unique property key if the NSManagedObject; example @"uid"
 * @param uniqueObjectValueType `UniqueObjectValueType` type of value the uniquePropertyKey is
 * @param jsonSearchPropertyKey `NSString` the key the unique property will have on a JSON of for that object
 * @warning If called, must call before `init`.
 */
+ (void)configureModelUniqueIdentifier:(NSString *)uniquePropertyKey
                            ofDataType:(UniqueObjectValueType)uniqueObjectValueType
                  withJSONSearchString:(NSString *)jsonSearchPropertyKey;


/** Utility method for `configureModelUniqueIdentifier:ofDataType:withJSONSearchString:`
 *
 * @param `UniqueIdentiferStruct` Predefined struct of the values passesd to `configureModelUniqueIdentifier:ofDataType:withJSONSearchString:`
 * @warning If called, must call before `init`.
 */
+ (void)configureUniqueIdentifier:(UniqueIdentiferStruct)uniqueIdentiferStruct;



///-------------------------
/// @name Methods
///-------------------------
//


/** Empties database of all entities, destroys `NSManagedObject` model and `NSPersistantStoreCoordinator`.
 *
 * @warning Does not reset config class variables.
 */
- (void)reset;



/** Returns a brand `NSManagedObjectContext` of spawned off of the [CYCoreData readContext]. To update the database, fetch the `NSEntityDescriptions` from this context, create or modify as you see fit. When finished, immediately call either `[temporaryWriteContext saveSynchronously]` or `[temporaryWriteContext saveAsynchronously]`. This ensures that the changes will be pushed up to the [CYCoreData readContext], then written to disk.
 *
 * @return `NSManagedObjectContext` of [CYCoreData liason].readContext
 * @warning It is not wise to change or save to this context directly. ONLY READ
 */
- (NSManagedObjectContext *)temporaryWriteContext;


/** Calls a sychronous(performBlockAndWait) action to the top `NSManagedObjectContext` to write the changes to disk.
 *
 * @example Call when app terminates or goes in to background.
 */
- (void)saveSynchronously;


/** Calls a Asychronous(performBlock) action to the top `NSManagedObjectContext` to write the changes to disk.
 *
 * @example Call when ever sychronous behavior is not desired.
 */
- (void)saveAsynchronously;


/** For topLevelContext `performBlockAndWait` pass `YES`. For topLevelContext `performBlock` pass `NO`.
 *
 * @param andWait `BOOL` for identify call to topLevelContext `performBlock` or `performBlockAndWait`
 */
- (void)saveContextAndWait:(BOOL)andWait;

@end