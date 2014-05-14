//
//  HBCoreDataNSManagedObjectContextTests.m
//  HBCoreData-Example
//
//  Created by hatebyte on 5/10/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CYCoreData.h"
#import "Listing+Util.h"

@interface CYCoreDataNSManagedObjectContextTests : XCTestCase

@property(nonatomic, strong) NSManagedObjectContext *tempContext;

@end

@implementation CYCoreDataNSManagedObjectContextTests

- (void)createNumListings:(int)numListings {
    Listing *l;
    for (int i = 0; i<numListings; i++) {
        l                                           = [_tempContext insertNewObjectWithEntityName:[Listing entityName]];
        l.uid                                       = [NSString stringWithFormat:@"list-%d", i];
        l.createdUtc                                = [NSDate date];
        l.numComments                               = [NSNumber numberWithInteger:i];
    }
}

- (void)setUp {
    [super setUp];
    // Configure the database file name (the sqlite file coredata will create), and model file name (the model the sqlite database with use, **.xcdatamodeld).
    [CYCoreData configureSqliteFileName:@"example_database" withModelFileName:@"ExampleModel"];
    
    // Optional;
    // If the unique identifier for the model objects in not a int, and/or does not stick to the uid convention, configure immediately after.
    [CYCoreData configureModelUniqueIdentifier:@"uid" ofDataType:UniqueObjectValueTypeString withJSONSearchString:@"id"];
    _tempContext                                    = [CYCoreData temporaryWriteContext];
}

- (void)tearDown {
    _tempContext                                    = nil;
    [CYCoreData reset];
    [super tearDown];
}


- (void)testInsertNewObjectWithEntityName{
    Listing *l                                      = [_tempContext insertNewObjectWithEntityName:@"Listing"];
    XCTAssertEqualObjects(@"Listing", NSStringFromClass([l class]), @"The object class should be Listing");
}


///-------------------------
/// @name Read
///-------------------------

- (void)testFetchRequestForEntity {
    NSEntityDescription *entityDescription          = [NSEntityDescription entityForName:[Listing entityName] inManagedObjectContext:_tempContext];
    NSFetchRequest *fr                              = [[CYCoreData readContext] fetchRequestForEntity:entityDescription];
    
    XCTAssertEqualObjects(fr.entity, entityDescription, @"The fetch request entity description should be the entered entity description");
}

- (void)testFetchRequestForEntityName {
    NSString *entityName                            = [Listing entityName];
    NSFetchRequest *fr                              = [[CYCoreData readContext] fetchRequestForEntityName:entityName];
    
    XCTAssertEqualObjects(fr.entity.name, entityName, @"The fetch request entity name description should be the entityName");
}

- (void)testFetchRequestForEntityNameWithSortDescriptorsAndPredicate {
    NSString *entityName                            = [Listing entityName];
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"self.uid == 1"];
    NSSortDescriptor *sortDescriptor                = [NSSortDescriptor sortDescriptorWithKey:@"createdUtc" ascending:NO];
    
    NSFetchRequest *fr                              = [[CYCoreData readContext] fetchRequestForEntityName:entityName sortDescriptors:@[sortDescriptor] andPredicate:predicate ];
    
    XCTAssertEqualObjects(fr.entity.name, entityName, @"The fetch request entity name description should be the entityName");
    XCTAssertEqualObjects(fr.predicate, predicate, @"The fetch request predicate description should be the predicate passed");
    
    NSSortDescriptor *sd                            = [fr.sortDescriptors objectAtIndex:0];
    XCTAssertEqualObjects(sortDescriptor, sd, @"The fetch request sortDescriptor description should be the sortDescriptor passed");
}

- (void)testFetchCountWithRequest {
    [_tempContext insertNewObjectWithEntityName:[Listing entityName]];
    [_tempContext saveSynchronously];
    
    NSFetchRequest *fr                              = [[CYCoreData readContext] fetchRequestForEntityName:[Listing entityName]];
    NSUInteger count                                = [[CYCoreData readContext] fetchCountWithRequest:fr];
    
    XCTAssertEqual(1, count, @"There should be 1 record in the database");
}

- (void)testfetchObjectsWithEntityNameWithSortDescriptorsAndPredicate {
    [self createNumListings:20];
    
    NSDate *distF                                   = [NSDate distantFuture];
    Listing *l                                      = [_tempContext insertNewObjectWithEntityName:[Listing entityName]];
    l.uid = @"SearchForMe";
    l.createdUtc                                    = distF;
    l.numComments                                   = [NSNumber numberWithInteger:21];
    [_tempContext saveSynchronously];
    
    NSPredicate *predicate                          = [NSPredicate predicateWithFormat:@"self.numComments >= %@", [NSNumber numberWithInteger:10]];
    NSSortDescriptor *sortDescriptor                = [NSSortDescriptor sortDescriptorWithKey:@"createdUtc" ascending:YES];
    
    NSArray *listings                               = [[CYCoreData readContext] fetchObjectsWithEntityName:[Listing entityName] sortedBy:@[sortDescriptor] withPredicate:predicate];
    Listing *lastListing                            = [listings lastObject];
    
    XCTAssertEqual((int)11, (int)[listings count], @"There should be 11 records with numComments greater than to 11");
    XCTAssertEqualObjects(distF, lastListing.createdUtc, @"The most recent listing should have the same date");
}

- (void)testfetchFirstObjectWithEntityNameWithSortDescriptorsAndPredicate {
    [self createNumListings:20];
    
    NSDate *distF                                   = [NSDate distantFuture];
    Listing *l                                      = [_tempContext insertNewObjectWithEntityName:[Listing entityName]];
    l.uid                                           = @"SearchForMe";
    l.createdUtc                                    = distF;
    [_tempContext saveSynchronously];
    
    NSPredicate *predicate                          = [NSPredicate predicateWithFormat:@"self.uid == %@", @"SearchForMe"];
    NSSortDescriptor *sortDescriptor                = [NSSortDescriptor sortDescriptorWithKey:@"createdUtc" ascending:NO];
    
    Listing *listing                                = [[CYCoreData readContext] fetchFirstObjectWithEntityName:[Listing entityName] sortedBy:@[sortDescriptor] withPredicate:predicate];
    
    XCTAssertEqualObjects(distF, listing.createdUtc, @"The returned listing should have the same date");
    XCTAssertEqualObjects(@"SearchForMe", listing.uid, @"The returned listing should have the uid SearchForMe");
}

- (void)testFetchCountWithEntityNameWithPredicate {
    [self createNumListings:20];
    [_tempContext saveSynchronously];
    
    NSPredicate *predicate                          = [NSPredicate predicateWithFormat:@"self.numComments >= %@", [NSNumber numberWithInteger:10]];
    NSUInteger count                                = [[CYCoreData readContext] fetchCountWithEntityName:[Listing entityName] andPredicate:predicate];
    XCTAssertEqual((int)10, (int)count, @"There should be 10 records with numComments greater than to 10");
}

- (void)testfetchObjectsWithEntityNameWithSortDescriptorsAndPredicateAndPageNumber {
    [self createNumListings:20];
    
    NSDate *distF                                   = [NSDate distantFuture];
    Listing *l                                      = [_tempContext insertNewObjectWithEntityName:[Listing entityName]];
    l.uid                                           = @"SearchForMe";
    l.createdUtc                                    = distF;
    l.numComments                                   = [NSNumber numberWithInteger:21];
    [_tempContext saveSynchronously];
    
    NSPredicate *predicate                          = [NSPredicate predicateWithFormat:@"self.numComments >= %@", [NSNumber numberWithInteger:10]];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdUtc" ascending:YES];
    
    NSArray *page1                                  = [[CYCoreData readContext] fetchObjectsWithEntityName:[Listing entityName]
                                                                                              byPageNumber:1
                                                                                        withObjectsPerPage:4
                                                                                              andPredicate:predicate
                                                                                       withSortDescriptors:@[sortDescriptor]];
    NSArray *page2                                  = [[CYCoreData readContext] fetchObjectsWithEntityName:[Listing entityName]
                                                                                              byPageNumber:2
                                                                                        withObjectsPerPage:4
                                                                                              andPredicate:predicate
                                                                                       withSortDescriptors:@[sortDescriptor]];
    NSArray *page3                                  = [[CYCoreData readContext] fetchObjectsWithEntityName:[Listing entityName]
                                                                                              byPageNumber:3
                                                                                        withObjectsPerPage:4
                                                                                              andPredicate:predicate
                                                                                       withSortDescriptors:@[sortDescriptor]];
    XCTAssertEqual((int)4, (int)[page1 count], @"There should be 4 records in page 1");
    XCTAssertEqual((int)4, (int)[page2 count], @"There should be 4 records in page 2");
    XCTAssertEqual((int)3, (int)[page3 count], @"There should be 3 record in page 2");

    Listing *lastListing                            = [page3 lastObject];
    XCTAssertEqualObjects(distF, lastListing.createdUtc, @"The most recent listing should have the same date");
}



///-------------------------
/// @name Write
///-------------------------

- (void)testDeleteAllObjectsWithEntityName {
    [self createNumListings:20];
    [_tempContext saveSynchronously];
    
    NSUInteger count                                = [[CYCoreData readContext] fetchCountWithEntityName:[Listing entityName] andPredicate:nil];
    XCTAssertEqual((int)20, (int)count, @"There should be 20 Listings in the db");

    [_tempContext deleteAllObjectsWithEntityName:[Listing entityName]];
    [_tempContext saveSynchronously];

    count                                           = [[CYCoreData readContext] fetchCountWithEntityName:[Listing entityName] andPredicate:nil];
    XCTAssertEqual((int)0, (int)count, @"There should be 0 Listings in the db");
}

- (void)testDeleteAllObjectsWithEntityNameWithSortDescriptorsAndPredicate {
    [self createNumListings:20];
    
    NSDate *distF                                   = [NSDate distantFuture];
    Listing *l                                      = [_tempContext insertNewObjectWithEntityName:[Listing entityName]];
    l.uid                                           = @"SearchForMe";
    l.createdUtc                                    = distF;
    l.numComments                                   = [NSNumber numberWithInteger:21];
    [_tempContext saveSynchronously];
    
    NSUInteger count                                = [[CYCoreData readContext] fetchCountWithEntityName:[Listing entityName] andPredicate:nil];
    XCTAssertEqual((int)21, (int)count, @"There should be 21 Listings in the db");

    NSPredicate *predicate                          = [NSPredicate predicateWithFormat:@"self.numComments >= %@", [NSNumber numberWithInteger:10]];
    NSSortDescriptor *sortDescriptor                = [NSSortDescriptor sortDescriptorWithKey:@"createdUtc" ascending:YES];
    
    [_tempContext deleteObjectsWithEntityName:[Listing entityName] sortDescriptors:@[sortDescriptor] andPredicate:predicate];
    [_tempContext saveSynchronously];

    count                                           = [[CYCoreData readContext] fetchCountWithEntityName:[Listing entityName] andPredicate:nil];
    XCTAssertEqual((int)10, (int)count, @"There should be 10 Listings in the db");
}


@end
