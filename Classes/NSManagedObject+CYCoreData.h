//
//  NSManagedObject+CYCoreData.h
//  SharedFiles
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef enum {
    UniqueObjectValueTypeBool,
    UniqueObjectValueTypeInt,
    UniqueObjectValueTypeInteger,
    UniqueObjectValueTypeDouble,
    UniqueObjectValueTypeFloat,
    UniqueObjectValueTypeDate,
    UniqueObjectValueTypeUnixDate,
    UniqueObjectValueTypeMicrosecondDate,
    UniqueObjectValueTypeString
} UniqueObjectValueType;

typedef struct UniqueIdentiferStruct {
    __unsafe_unretained NSString* uniquePropertyKey;
    __unsafe_unretained NSString* jsonSearchPropertyKey;
    UniqueObjectValueType uniqueObjectValueType;
} UniqueIdentiferStruct;

@interface NSManagedObject (CYCoreData)






///-------------------------
/// @name Config
///-------------------------

/** Sets the keys for and type of unique indexer for `NSManagedObjects`. This key is used to fetch unique `NSEntity` in the database.
*
* @param uniquePropertyKey `NSString`for the unique property key if the NSManagedObject; example @"uid"
* @param uniqueObjectValueType UniqueObjectValueType type of value the uniquePropertyKey is
* @param jsonSearchPropertyKey `NSString`the key the unique property will have on a JSON of for that object
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






///-------------------------
/// @name Write
///-------------------------

/** Returns a `NSString` value of to identitify the class of the `NSManagedObject`
 *
 * @return `NSString`to identify class name
 */
+ (NSString *)entityName;


/** Creates and returns an `NSManagedObject` from the subclass that calls via the `NSManagedObjectContext` passed.
 *
 * @param context `NSManagedObjectContext`the context the `NSManagedObject` subclass will be inserted from
 * @return instancetype `NSManagedObject` subclass from the subclass that calls it.
 */
+ (instancetype)newObjectInContext:(NSManagedObjectContext *)context;


/** Creates and returns an `NSManagedObject` from the subclass that calls via the `NSManagedObjectContext` passed. The `NSDictionary` passed will be parsed and key value mapped to the new created `NSManagedObject` subclass.
 *
 * @param context `NSManagedObjectContext` the context the `NSManagedObject` subclass will be inserted from
 * @param dictionary NSDictionary that will be parsed and key value mapped to the new created `NSManagedObject` subclass
 * @return instancetype `NSManagedObject` subclass from the subclass that calls it.
 */
+ (instancetype)updateOrCreateObjectInContext:(NSManagedObjectContext *)context withDictionary:(NSDictionary *)dictionary;


/** Deletes all `NSEntityDescription` of `NSManagedObject` subclass that calls it from the `NSManagedObjectContext` passed.
 *
 * @param context `NSManagedObjectContext`to delete the `NSManagedObject` subclass from
 */
+ (void)deleteAllObjectsInContext:(NSManagedObjectContext *)context;


/** Deletes specifically fetched `NSEntityDescription` of `NSManagedObject` with `NSSortDescriptors` and `NSPredicate` of subclass that calls it from the `NSManagedObjectContext` passed.
 *
 * @param context `NSManagedObjectContext`to delete the `NSManagedObject` subclass from
 * @param sortDescriptors `NSArray` of NSSortDescriptors to order against
 * @param predicate `NSPredicate` to search against
 */
+ (void)deleteObjectsInContext:(NSManagedObjectContext *)context sortedBy:(NSArray *)sortDescriptors withPredicate:(NSPredicate *)predicate;


/** The `NSDictionary` passed will be parsed and key value mapped to `NSManagedObject` the subclass.
 *
 * @param dictionary `NSDictionary` that will be parsed and key value mapped to the new created `NSManagedObject` subclass
 */
- (void)updateWithDictionary:(NSDictionary *)dictionary;


/** The `NSDictionary` will be searched by `NSString` keys in `NSArray`. If found, `BOOL` values will be applied to `NSManagedObject` subclass that called it.
 *
 * @param dictionary NSDictionary that will be parsed and key value mapped to the new created `NSManagedObject` subclass
 * @param keys `NSArray` of `NSString` keys for `BOOLs` in the the `NSDictionary`
 * @warning Insert keys as iOS paradigm `camelCase`. Method automatically changes iOS paradigm `camelCase` to JSON paradigm to `under_score` key
 */
- (void)setBoolValuesInDictionary:(NSDictionary *)dictionary            forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;


/** The `NSDictionary` will be searched by `NSString` keys in `NSArray`. If found, `int` values will be applied to `NSManagedObject` subclass that called it.
 *
 * @param dictionary `NSDictionary` that will be parsed and key value mapped to the new created `NSManagedObject` subclass
 * @param keys `NSArray` of `NSString` keys for `ints` in the the `NSDictionary`
 * @warning Insert keys as iOS paradigm `camelCase`. Method automatically changes iOS paradigm `camelCase` to JSON paradigm to `under_score` key
 */
- (void)setIntValuesInDictionary:(NSDictionary *)dictionary             forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;


/** The `NSDictionary` will be searched by `NSString` keys in `NSArray`. If found, `NSInteger` values will be applied to `NSManagedObject` subclass that called it.
 *
 * @param dictionary `NSDictionary` that will be parsed and key value mapped to the new created `NSManagedObject` subclass
 * @param keys `NSArray` of `NSString` keys for `NSIntegers` in the the `NSDictionary`
 * @warning Insert keys as iOS paradigm `camelCase`. Method automatically changes iOS paradigm `camelCase` to JSON paradigm to `under_score` key
 */
- (void)setIntegerValuesInDictionary:(NSDictionary *)dictionary         forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;


/** The `NSDictionary` will be searched by `NSString` keys in `NSArray`. If found, `float` values will be applied to `NSManagedObject` subclass that called it.
 *
 * @param dictionary `NSDictionary` that will be parsed and key value mapped to the new created `NSManagedObject` subclass
 * @param keys `NSArray` of `NSString` keys for `floats` in the the `NSDictionary`
 * @warning Insert keys as iOS paradigm `camelCase`. Method automatically changes iOS paradigm `camelCase` to JSON paradigm to `under_score` key
 */
- (void)setFloatValuesInDictionary:(NSDictionary *)dictionary           forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;


/** The `NSDictionary` will be searched by `NSString` keys in `NSArray`. If found, `double` values will be applied to `NSManagedObject` subclass that called it.
 *
 * @param dictionary `NSDictionary` that will be parsed and key value mapped to the new created `NSManagedObject` subclass
 * @param keys `NSArray` of `NSString` keys for `doubles` in the the `NSDictionary`
 * @warning Insert keys as iOS paradigm `camelCase`. Method automatically changes iOS paradigm `camelCase` to JSON paradigm to `under_score` key
 */
- (void)setDoubleValuesInDictionary:(NSDictionary *)dictionary          forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;


/** The `NSDictionary` will be searched by `NSString` keys in `NSArray`. If found, `timestamp string` values will be applied to `NSManagedObject` subclass that called it.
 *
 * @param dictionary `NSDictionary` that will be parsed and key value mapped to the new created `NSManagedObject` subclass
 * @param keys `NSArray` of `NSString` keys for `Timestamps` in the the `NSDictionary`
 * @warning Insert keys as iOS paradigm `camelCase`. Method automatically changes iOS paradigm `camelCase` to JSON paradigm to `under_score` key
 */
- (void)setDateValuesInDictionary:(NSDictionary *)dictionary            forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;


/** The `NSDictionary` will be searched by `NSString` keys in `NSArray`. If found, `int string` values will be applied to `NSManagedObject` subclass that called it.
 *
 * @param dictionary `NSDictionary` that will be parsed and key value mapped to the new created `NSManagedObject` subclass
 * @param keys `NSArray` of `NSString` keys for `Unix Timestamps` in the the `NSDictionary`
 * @warning Insert keys as iOS paradigm `camelCase`. Method automatically changes iOS paradigm `camelCase` to JSON paradigm to `under_score` key
 */
- (void)setUnixDateValuesInDictionary:(NSDictionary *)dictionary        forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;


/** The `NSDictionary` will be searched by `NSString` keys in `NSArray`. If found, `doubleValue string` values will be applied to `NSManagedObject` subclass that called it.
 *
 * @param dictionary `NSDictionary` that will be parsed and key value mapped to the new created `NSManagedObject` subclass
 * @param keys `NSArray` of `NSString` keys for `Timestamps` in microseconds in the the `NSDictionary`
 * @warning Insert keys as iOS paradigm `camelCase`. Method automatically changes iOS paradigm `camelCase` to JSON paradigm to `under_score` key
 */
- (void)setMicrosecondDateValuesInDictionary:(NSDictionary *)dictionary forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;



/** The `NSDictionary` will be searched by `NSString` keys in `NSArray`. If found, `NSString` values will be applied to `NSManagedObject` subclass that called it.
 *
 * @param dictionary `NSDictionary` that will be parsed and key value mapped to the new created `NSManagedObject` subclass
 * @param keys `NSArray` of `NSString` keys for `NSStrings` in the the `NSDictionary`
 * @warning Insert keys as iOS paradigm `camelCase`. Method automatically changes iOS paradigm `camelCase` to JSON paradigm to `under_score` key
 */
- (void)setStringValuesInDictionary:(NSDictionary *)dictionary          forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;






///-------------------------
/// @name Read
///-------------------------

/** Returns specifically fetched `NSEntityDescriptions` of `NSManagedObject` with `sortDescriptors` and `NSPredicate` of subclass that calls it from the `NSManagedObjectContext` passed.
 *
 * @param context `NSManagedObjectContext` to fetch the `NSManagedObject` subclass from
 * @param sortDescriptors `NSArray` of `NSSortDescriptors` to order against
 * @param predicate `NSPredicate` to search against
 * @return NSArray of `NSManagedObject` subclasses that satisfy the `NSSortDescriptors` and `NSPredicate`
 */
+ (NSArray *)fetchObjectsInContext:(NSManagedObjectContext *)context
                          sortedBy:(NSArray *)sortDescriptors
                     withPredicate:(NSPredicate *)predicate;


/** Returns an NSUInteger identitifying the number of `NSManagedObject` subclasses in the `NSManagedObjectContext` passed with `NSPredicate`.
 *
 * @param context `NSManagedObjectContext` to fetch from
 * @param predicate `NSPredicate` to search against
 * @return `NSUInteger` identitifying the number of `NSManagedObject` subclasses in the `NSManagedObjectContext` passed with `NSPredicate`
 */
+ (NSUInteger)fetchCountInContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;


/** Returns first `NSManagedObject` subclasses with `NSSortDescriptors` and `NSPredicate` of subclass that calls it from the `NSManagedObjectContext` passed.
 *
 * @param context `NSManagedObjectContext` to fetch from
 * @param sortDescriptors NSArray of NSSortDescriptors to order against
 * @param predicate `NSPredicate` to search against
 * @return instancetype `NSManagedObject` subclass returned from an NSFetchRequest with `NSSortDescriptors` and `NSPredicate` from the `NSManagedObjectContext` passed
 */
+ (instancetype)fetchFirstObjectInContext:(NSManagedObjectContext *)context
                                 sortedBy:(NSArray *)sortDescriptors
                            withPredicate:(NSPredicate *)predicate;


/** Returns all `NSManagedObjects` of subclass that call it from the `NSManagedObjectContext` passed.
 *
 * @param context `NSManagedObjectContext` the context to fetch from
 * @return NSArray of `NSManagedObject` subclasses from the `NSManagedObjectContext` passed.
 */
+ (NSArray *)fetchAllInContext:(NSManagedObjectContext *)context;


/** Fetches `NSEntityDescription` of `NSManagedObject` subclasses with `NSSortDescriptors` of subclass that calls it from the `NSManagedObjectContext` passed. The resulting array is paginated by the `perPage` and the give page `pageNumber` is returned
 *
 * @param context `NSManagedObjectContext` to fetch from
 * @param pageNumber `NSInteger` the page number to return
 * @param perPage `NSInteger` the amount of `NSManagedObject` subclasses per page
 * @param sortDescriptors `NSArray of` NSSortDescriptors to order against
 * @return NSArray of `NSManagedObject` subclasses from the `NSManagedObjectContext` passed, queried by `sortDescriptors` of `pageNumber` when paginated by `perPage`
 */
+ (NSArray *)fetchObjectsInContext:(NSManagedObjectContext *)context
                      byPageNumber:(NSInteger)pageNumber
                withObjectsPerPage:(NSInteger)perPage
               withSortDescriptors:(NSArray *)sortDescriptors;


/** Fetches `NSEntityDescription` of `NSManagedObject` subclasses with `NSSortDescriptors` and `NSPredicate` of subclass that calls it from the `NSManagedObjectContext` passed. The resulting array is paginated by the `perPage` and the give page `pageNumber` is returned
 *
 * @param context `NSManagedObjectContext` to fetch from
 * @param pageNumber `NSInteger` the page number to return
 * @param perPage `NSInteger` the amount of `NSManagedObject` subclasses per page
 * @param sortDescriptors `NSArray` of `NSSortDescriptors` to order against
 * @param predicate `NSPredicate` to search against
 * @return NSArray of `NSManagedObject` subclasses from the `NSManagedObjectContext` passed, queried by `NSSortDescriptors` and `NSPredicate` of `pageNumber` when paginated by `perPage`
 */
+ (NSArray *)fetchObjectsInContext:(NSManagedObjectContext *)context
                      byPageNumber:(NSInteger)pageNumber
                withObjectsPerPage:(NSInteger)perPage
                      andPredicate:(NSPredicate *)predicate
               withSortDescriptors:(NSArray *)sortDescriptors;

@end

































