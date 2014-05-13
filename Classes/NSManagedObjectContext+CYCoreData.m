//
//  NSManagedObjectContext+CYCoreData.m
//  SharedFiles
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "NSManagedObjectContext+CYCoreData.h"
#import "CYCoreData.h"

@implementation NSManagedObjectContext (CYCoreData)

/**************************************************************************************
 WRITE
 **************************************************************************************/
- (void)saveSynchronously {
    [self saveAndWait:YES];
}

- (void)saveAsynchronously {
    [self saveAndWait:NO];
}

- (void)saveAndWait:(BOOL)wait {
    NSError *error                                              = nil;
    [self save:&error];
    if (error) {
        NSLog(@"Error saving tempContext: %@", error);
    }
    [CYCoreData saveContextAndWait:wait];
}

- (id)insertNewObjectWithEntityName:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

- (void)deleteAllObjectsWithEntityName:(NSString *)entityName {
    [self deleteAllObjectsInResults:[self fetchObjectsWithEntityName:entityName sortedBy:nil withPredicate:nil]];
}

- (void)deleteObjectsWithEntityName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors andPredicate:(NSPredicate *)predicate {
    [self deleteAllObjectsInResults:[self fetchObjectsWithEntityName:entityName sortedBy:sortDescriptors withPredicate:predicate]];
}

- (void)deleteAllObjectsInResults:(NSArray *)results {
    for (NSManagedObject *result in results) {
        [self deleteObject:result];
    }
}

/**************************************************************************************
 READ
 **************************************************************************************/
- (NSFetchRequest *)fetchRequestForEntity:(NSEntityDescription *)entity {
    NSFetchRequest *request                                     = [[NSFetchRequest alloc] init];
    request.entity                                              = entity;
    return request;
}

- (NSFetchRequest *)fetchRequestForEntityName:(NSString *)entityName {
    NSEntityDescription *entityDescription                      = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    return [self fetchRequestForEntity:entityDescription];
}

- (NSFetchRequest *)fetchRequestForEntityName:(NSString *)entityName sortDescriptors:(NSArray *)sortDescriptors andPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest                                = [self fetchRequestForEntityName:entityName];
    
    if (sortDescriptors) {
        fetchRequest.sortDescriptors                            = sortDescriptors;
    }
    
    if (predicate) {
        fetchRequest.predicate                                  = predicate;
    }
    return fetchRequest;
}

- (NSArray *)fetchObjectArrayWithRequest:(NSFetchRequest *)request {
    NSError *error                                              = nil;
    NSArray *results                                            = [self executeFetchRequest:request error:&error];
    NSAssert(error == nil, [error description]);
    return results;
}

- (NSUInteger)fetchCountWithRequest:(NSFetchRequest *)request {
    NSError *error                                              = nil;
    NSInteger count                                             = [self countForFetchRequest:request error:&error];
    NSAssert(error == nil, [error description]);
    return count;
}

- (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName sortedBy:(NSArray *)sortDescriptors withPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request                                     = [self fetchRequestForEntityName:entityName sortDescriptors:sortDescriptors andPredicate:predicate];
    return [self fetchObjectArrayWithRequest:request];
}

- (id)fetchFirstObjectWithEntityName:(NSString *)entityName sortedBy:(NSArray *)sortDescriptors withPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request                                     = [self fetchRequestForEntityName:entityName sortDescriptors:sortDescriptors andPredicate:predicate];
    request.fetchLimit                                          = 1;
    NSArray *results                                            = [self fetchObjectArrayWithRequest:request];
    
    if ([results count] == 0) {
        return nil;
    }
    return [results lastObject];
}

- (NSUInteger)fetchCountWithEntityName:(NSString *)entityName andPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request                                     = [self fetchRequestForEntityName:entityName sortDescriptors:nil andPredicate:predicate];
    return [self fetchCountWithRequest:request];
}

- (NSArray *)fetchObjectsWithEntityName:(NSString *)entityName byPageNumber:(NSInteger)pageNumber withObjectsPerPage:(NSInteger)perPage andPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *request                                     = [self fetchRequestForEntityName:entityName sortDescriptors:sortDescriptors andPredicate:predicate];
    request.fetchLimit                                          = perPage;
    request.fetchOffset                                         = perPage * (pageNumber - 1);
    return [self fetchObjectArrayWithRequest:request];
}

@end
