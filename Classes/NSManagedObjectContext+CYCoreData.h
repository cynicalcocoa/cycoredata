//
//  NSManagedObjectContext+CYCoreData.h
//  SharedFiles
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (CYCoreData)



///-------------------------
/// @name Write
///-------------------------

/** Returns a new `NSEntityDescription` of `entityName` in itself.
 *
 * @param entityName `NSString` of the entity name
 * @return An `NSEntityDescription` who's `managedObjectContext` is context that `insertNewObjectWithEntityName` was called upon
 * @warning Only call from an `NSManagedObjectContext` returned from `[CYCoreData temporaryWriteContext]`.
 */
- (id)insertNewObjectWithEntityName:(NSString *)entityName;


/** Deletes all NSEntityDescription of `entityName` from itself.
 *
 * @param entityName `NSString` of the entity name
 * @warning Only call from a `NSManagedObjectContext` returned from `[CYCoreData temporaryWriteContext]`.
 */
- (void)deleteAllObjectsWithEntityName:(NSString *)entityName;


/** Deletes specific `NSEntityDescriptions` of `entityName` returned from a `NSFetchRequest` with `NSSortDescriptors` and `NSPredicate` from itself.
 *
 * @param entityName `NSString` of the entity name
 * @param sortDescriptors `NSArray` of `NSSortDescriptors` to order against
 * @param predicate NSPredicate to search against
 * @warning Only call from a `NSManagedObjectContext` returned from `[CYCoreData temporaryWriteContext]`.
 */
- (void)deleteObjectsWithEntityName:(NSString *)entityName
                    sortDescriptors:(NSArray *)sortDescriptors
                       andPredicate:(NSPredicate *)predicate;






///-------------------------
/// @name Read
///-------------------------

/** Returns an `NSFetchRequest` for an `NSEntityDescription`
 *
 * @param entity `NSEntityDescription` to fetch
 * @return An `NSFetchRequest` for an `NSEntityDescription`
 */
- (NSFetchRequest *)fetchRequestForEntity:(NSEntityDescription *)entity;


/** Returns an `NSFetchRequest` for an `NSEntityDescription` of type `entityName`
 *
 * @param entityName `NSString` of the entity name
 * @return An `NSFetchRequest` for an `NSEntityDescription` of type `entityName`
 */
- (NSFetchRequest *)fetchRequestForEntityName:(NSString *)entityName;


/** Returns an `NSFetchRequest` with `entityName`, `NSSortDescriptors` and `NSPredicate`.
 *
 * @param entityName `NSString` of the entity name
 * @param sortDescriptors `NSArray` of `NSSortDescriptors` to order against
 * @param predicate `NSPredicate` to search against
 * @return An `NSFetchRequest` for an `NSEntityDescription` of type `entityName` with `NSSortDescriptors` and `NSPredicate`
 */
- (NSFetchRequest *)fetchRequestForEntityName:(NSString *)entityName
                              sortDescriptors:(NSArray *)sortDescriptors
                                 andPredicate:(NSPredicate *)predicate;


/** Returns an `NSUInteger` identitifying the number of `NSEntityDescriptions` returned by `NSFetchRequest`
 *
 * @param fetchRequest `NSFetchRequest` request to execute
 * @return `NSUInteger` identitifying the number of NSEntityDescriptions returned by `NSFetchRequest`
 */
- (NSUInteger)fetchCountWithRequest:(NSFetchRequest *)fetchRequest;


/** Returns specific `NSEntityDescriptions` returned from a NSFetchRequest with `entityName`, `NSSortDescriptors` and `NSPredicate` from itself.
 *
 * @param entityName `NSString` of the entity name
 * @param sortDescriptors `NSArray` of `NSSortDescriptors` to order against
 * @param predicate `NSPredicate` to search against
 * @return `NSArray` of `NSEntityDescriptions` returned from a `NSFetchRequest` with `NSSortDescriptors` and `predicate` from itself.
 */
- (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName
                               sortedBy:(NSArray *)sortDescriptors
                          withPredicate:(NSPredicate *)predicate;


/** Returns first `NSEntityDescription` returned from a `NSFetchRequest` with `entityName`, `NSSortDescriptors` and `NSPredicate` from itself.
 *
 * @param entityName `NSString` of the entity name
 * @param sortDescriptors `NSArray` of `NSSortDescriptors` to order against
 * @param predicate `NSPredicate` to search against
 * @return First `NSEntityDescription` in `NSArray` returned from a `NSFetchRequest` with `NSSortDescriptors` and `NSPredicate` from itself.
 */
- (id)fetchFirstObjectWithEntityName:(NSString *)entityName
                            sortedBy:(NSArray *)sortDescriptors
                       withPredicate:(NSPredicate *)predicate;


/** Returns an `NSUInteger` identitifying the number of `NSEntityDescriptions` returned by `NSFetchRequest` with `entityName` and `NSPredicate` from itself.
 *
 * @param entityName `NSString` of the entity name
 * @param predicate `NSPredicate` to search against
 * @return `NSUInteger` identitifying the number of `NSEntityDescriptions` returned by `NSFetchRequest` from itself.
 */
- (NSUInteger)fetchCountWithEntityName:(NSString *)entityName
                          andPredicate:(NSPredicate *)predicate;


/** Paginates `NSEntityDescriptions` returned from a `NSFetchRequest` with `entityName`, `NSSortDescriptors` and `NSPredicate` by `perPage`. Returns `perPage` of `NSEntityDescriptions` at `pageNumber` from itself.
 *
 * @param entityName `NSString` of the entity name
 * @param pageNumber `NSInteger` of requested page
 * @param perPage `NSInteger` to divide total number `NSEntityDescriptions` by
 * @param predicate `NSPredicate` to search against
 * @param sortDescriptors `NSArray` of `NSSortDescriptors` to order against
 * @return `NSArray` of `NSEntityDescriptions` returned from a `NSFetchRequest` with `NSSortDescriptors` and `NSPredicate` from its own `NSManagedObjectContext`. Count limited by `pageNumber` and offset by `perPage` * (`pageNumber` - 1)
 */
- (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName
                           byPageNumber:(NSInteger)pageNumber
                     withObjectsPerPage:(NSInteger)perPage
                           andPredicate:(NSPredicate *)predicate
                    withSortDescriptors:(NSArray *)sortDescriptors;


@end
