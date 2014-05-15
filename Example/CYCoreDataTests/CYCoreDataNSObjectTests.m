//
//  CYCoreDataNSObjectTests.m
//  CYCoreData
//
//  Created by hatebyte on 5/14/14.
//  Copyright (c) 2014 cynicalcocoa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CYCoreData.h"
#import "Listing+Util.h"
#import "CYFixtureHelper.h"
#import "NSDate+Util.h"

@interface CYCoreDataNSObjectTests : XCTestCase

@property(nonatomic, strong) NSManagedObjectContext *tempContext;
@property(nonatomic, strong) NSArray *listingsArray;

@end

@implementation CYCoreDataNSObjectTests


- (void)createNumListings:(int)numListings {
    Listing *l;
    for (int i = 0; i<numListings; i++) {
        l = [Listing updateOrCreateObjectInContext:_tempContext withDictionary:[_listingsArray objectAtIndex:0]];
        l.uid                                       = [NSString stringWithFormat:@"list-%d", i];
        l.numComments                               = [NSNumber numberWithInteger:i];
        l.createdUtc                                = [NSDate dateWithTimeIntervalSince1970:i];
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

    
    NSDictionary *listings                          = [CYFixtureHelper dictionaryFromFixtureByName:@"listing"];
    _listingsArray                                  = [listings objectForKey:@"listings"];
    
}

- (void)tearDown {
    _tempContext                                    = nil;
    _listingsArray                                  = nil;
    [CYCoreData reset];
    [super tearDown];
}

- (void)testListingEntityName {
    XCTAssertEqualObjects(@"Listing", [Listing entityName], @"The returned entity name for listing is Listing");
}

- (void)testNewObjectInContext {
    Listing *listing = [Listing newObjectInContext:_tempContext];
    
    XCTAssertEqualObjects(@"Listing", NSStringFromClass([listing class]), @"The returned entity for should be of class Listing");
    XCTAssertNotNil(listing, @"The returned Listing for should not be nil");
}

- (void)testUpdateOrCreateObjectInContextWithDictionary {
    Listing *listing = [Listing updateOrCreateObjectInContext:_tempContext withDictionary:[_listingsArray objectAtIndex:0]];
    NSDate *createdAt = [NSDate dateWithTimeIntervalSince1970:1400093165];

    XCTAssertFalse(listing.clickedBool, @"The clicked propety should be false");
    XCTAssertFalse(listing.isSelfBool, @"The isSelf propety should be false");
    XCTAssertEqual(423, listing.numCommentsInt, @"The numComments propety should be 423");
    XCTAssertEqual(11596, listing.upsInt, @"The ups propety should be 11596");
    
    XCTAssertEqualObjects(@"25k552", listing.uid, @"The uid propety should be 25k552");
    XCTAssertEqualObjects(@"/r/gifs/comments/25k552/so_i_filmed_strawberry_growing_40_days_in_15/", listing.permalink, @"The permalink propety should be /r/gifs/comments/25k552/so_i_filmed_strawberry_growing_40_days_in_15/");
    XCTAssertEqualObjects(@"t5_2qt55", listing.subredditId, @"The subredditId propety should be gifs");
    XCTAssertEqualObjects(@"So... I filmed strawberry growing (40 days in ~15 seconds)", listing.title, @"The title propety should be So... I filmed strawberry growing (40 days in ~15 seconds)");
    XCTAssertEqualObjects(createdAt, listing.createdUtc, @"The createdUtc propety should be date with unix 1400093165");
}

- (void)testDeleteAllObjectsInContext {
    [self createNumListings:20];
    [_tempContext saveSynchronously];
    
    NSUInteger count                                = [Listing fetchCountInContext:[CYCoreData readContext] withPredicate:nil];
    XCTAssertEqual((int)20, (int)count, @"There should be 20 Listings in the db");
    
    [Listing deleteAllObjectsInContext:_tempContext];
    [_tempContext saveSynchronously];
    
    count                                           = [Listing fetchCountInContext:[CYCoreData readContext] withPredicate:nil];
    XCTAssertEqual((int)0, (int)count, @"There should be 0 Listings in the db");
}

- (void)testDeleteAllObjectsWithEntityNameWithSortDescriptorsAndPredicate {
    [self createNumListings:20];
    
    NSDate *distF                                   = [NSDate distantFuture];
    Listing *l                                      = [Listing updateOrCreateObjectInContext:_tempContext withDictionary:[_listingsArray objectAtIndex:0]];
    l.uid                                           = @"SearchForMe";
    l.createdUtc                                    = distF;
    l.numComments                                   = [NSNumber numberWithInteger:21];
    [_tempContext saveSynchronously];
    
    NSUInteger count                                = [Listing fetchCountInContext:[CYCoreData readContext] withPredicate:nil];
    XCTAssertEqual((int)21, (int)count, @"There should be 21 Listings in the db");
    
    NSPredicate *predicate                          = [NSPredicate predicateWithFormat:@"self.numComments < %@ || self.uid == %@", [NSNumber numberWithInteger:10], @"SearchForMe"];
    NSSortDescriptor *sortDescriptor                = [NSSortDescriptor sortDescriptorWithKey:@"createdUtc" ascending:YES];
    
    [Listing deleteObjectsInContext:_tempContext sortedBy:@[sortDescriptor] withPredicate:predicate];
    [_tempContext saveSynchronously];
    
    count                                           = [Listing fetchCountInContext:[CYCoreData readContext] withPredicate:nil];
    XCTAssertEqual((int)10, (int)count, @"There should be 10 Listings in the db");
}

- (void)testUpdateWithDictionary {
    Listing *listing = [Listing newObjectInContext:_tempContext];
    [listing updateWithDictionary:[_listingsArray objectAtIndex:0]];
    NSDate *createdAt = [NSDate dateWithTimeIntervalSince1970:1400093165];
    
    XCTAssertFalse(listing.clickedBool, @"The clicked propety should be false");
    XCTAssertFalse(listing.isSelfBool, @"The isSelf propety should be false");
    XCTAssertEqual(423, listing.numCommentsInt, @"The numComments propety should be 423");
    XCTAssertEqual(11596, listing.upsInt, @"The ups propety should be 11596");
    
    XCTAssertEqualObjects(@"25k552", listing.uid, @"The uid propety should be 25k552");
    XCTAssertEqualObjects(@"/r/gifs/comments/25k552/so_i_filmed_strawberry_growing_40_days_in_15/", listing.permalink, @"The permalink propety should be /r/gifs/comments/25k552/so_i_filmed_strawberry_growing_40_days_in_15/");
    XCTAssertEqualObjects(@"t5_2qt55", listing.subredditId, @"The subredditId propety should be gifs");
    XCTAssertEqualObjects(@"So... I filmed strawberry growing (40 days in ~15 seconds)", listing.title, @"The title propety should be So... I filmed strawberry growing (40 days in ~15 seconds)");
    XCTAssertEqualObjects(createdAt, listing.createdUtc, @"The createdUtc propety should be date with unix 1400093165");
}

- (void)testSetBoolValuesInDictionary {
    Listing *listing = [Listing newObjectInContext:_tempContext];
    [listing setBoolValuesInDictionary:[_listingsArray objectAtIndex:0] forKeys:@"isSelf", @"clicked", nil];
   
    XCTAssertFalse(listing.clickedBool, @"The clicked propety should be false");
    XCTAssertFalse(listing.isSelfBool, @"The isSelf propety should be false");
}

- (void)testSetIntValuesInDictionary {
    Listing *listing = [Listing newObjectInContext:_tempContext];
    [listing setIntValuesInDictionary:[_listingsArray objectAtIndex:0] forKeys:@"numComments", @"ups", nil];
    
    XCTAssertEqual(423, [listing.numComments intValue], @"The numComments propety should be 423");
    XCTAssertEqual(11596, [listing.ups intValue], @"The ups propety should be 11596");
}

- (void)testSetIntegerValuesInDictionary {
    Listing *listing = [Listing newObjectInContext:_tempContext];
    [listing setIntegerValuesInDictionary:[_listingsArray objectAtIndex:0] forKeys:@"numComments", @"ups", nil];
    
    XCTAssertEqual(423, [listing.numComments integerValue], @"The numComments propety should be 423");
    XCTAssertEqual(11596, [listing.ups integerValue], @"The ups propety should be 11596");
}

- (void)testSetFloatValuesInDictionary {
    Listing *listing = [Listing newObjectInContext:_tempContext];
    [listing setFloatValuesInDictionary:[_listingsArray objectAtIndex:0] forKeys:@"numComments", @"ups", nil];
    
    XCTAssertEqual(423, [listing.numComments floatValue], @"The numComments propety should be 423");
    XCTAssertEqual(11596, [listing.ups floatValue], @"The ups propety should be 11596");
}

- (void)testSetDoubleValuesInDictionary {
    Listing *listing = [Listing newObjectInContext:_tempContext];
    [listing setDoubleValuesInDictionary:[_listingsArray objectAtIndex:0] forKeys:@"numComments", @"ups", nil];
    
    XCTAssertEqual(423, [listing.numComments doubleValue], @"The numComments propety should be 423");
    XCTAssertEqual(11596, [listing.ups doubleValue], @"The ups propety should be 11596");
}

- (void)testSetStringValuesInDictionary {
    Listing *listing = [Listing newObjectInContext:_tempContext];
    [listing setStringValuesInDictionary:[_listingsArray objectAtIndex:0] forKeys:@"title", @"permalink", @"subredditId", nil];
    
    XCTAssertEqualObjects(@"/r/gifs/comments/25k552/so_i_filmed_strawberry_growing_40_days_in_15/", listing.permalink, @"The permalink propety should be /r/gifs/comments/25k552/so_i_filmed_strawberry_growing_40_days_in_15/");
    XCTAssertEqualObjects(@"t5_2qt55", listing.subredditId, @"The subredditId propety should be gifs");
    XCTAssertEqualObjects(@"So... I filmed strawberry growing (40 days in ~15 seconds)", listing.title, @"The title propety should be So... I filmed strawberry growing (40 days in ~15 seconds)");
}

- (void)testSetUnixDateValuesInDictionary {
    Listing *listing = [Listing newObjectInContext:_tempContext];
    [listing setUnixDateValuesInDictionary:[_listingsArray objectAtIndex:0] forKeys:@"createdUtc", nil];

    NSDate *createdAt = [NSDate dateWithTimeIntervalSince1970:1400093165];
    XCTAssertEqualObjects(createdAt, listing.createdUtc, @"The createdUtc propety should be date with unix 1400093165");
}

- (void)testSetDateValuesInDictionary {
    NSDate *createdAt                       = [NSDate dateFromString:@"2013-11-19T17:45:22Z"];
    NSMutableDictionary *listindDict        = [[_listingsArray objectAtIndex:0] mutableCopy];
    [listindDict setValue:@"2013-11-19T17:45:22Z" forKey:@"created_utc"];
    
    Listing *listing = [Listing newObjectInContext:_tempContext];
    [listing setDateValuesInDictionary:listindDict forKeys:@"createdUtc", nil];
    
    XCTAssertEqualObjects(createdAt, listing.createdUtc, @"The createdUtc propety should be date with unix 1400093165");
}

- (void)testSetMicrosecondDateValuesInDictionary {
    NSDate *createdAt                       = [NSDate dateFromMicroSecondsString:@"1400093165000000"];
    NSMutableDictionary *listindDict        = [[_listingsArray objectAtIndex:0] mutableCopy];
    [listindDict setValue:@"1400093165000000" forKey:@"created_utc"];
    
    Listing *listing                        = [Listing newObjectInContext:_tempContext];
    [listing setMicrosecondDateValuesInDictionary:listindDict forKeys:@"createdUtc", nil];
    
    XCTAssertEqual(createdAt, listing.createdUtc, @"The createdUtc propety should be date with unix 1400093165000000");
    XCTAssertEqual((long double)1400093165000000, (long double)[listing.createdUtc inMicroSeconds], @"The createdUtc propety should be date with unix 1400093165000000");
}


- (void)testFetchObjectsInContextSortedByWithPredicate {
    [self createNumListings:20];
    
    NSDate *distF                                   = [NSDate distantFuture];
    Listing *l                                      = [Listing newObjectInContext:_tempContext];
    l.uid                                           = @"SearchForMe";
    l.createdUtc                                    = distF;
    l.numComments                                   = [NSNumber numberWithInteger:21];
    [_tempContext saveSynchronously];
    
    NSPredicate *predicate                          = [NSPredicate predicateWithFormat:@"self.numComments >= %@", [NSNumber numberWithInteger:10]];
    NSSortDescriptor *sortDescriptor                = [NSSortDescriptor sortDescriptorWithKey:@"createdUtc" ascending:YES];
    
    NSArray *listings                               = [Listing fetchObjectsInContext:_tempContext sortedBy:@[sortDescriptor] withPredicate:predicate];
    Listing *lastListing                            = [listings lastObject];
    
    XCTAssertEqual((int)11, (int)[listings count], @"There should be 11 records with numComments greater than to 11");
    XCTAssertEqualObjects(distF, lastListing.createdUtc, @"The most recent listing should have the same date");
}

- (void)testFetchCountInContext {
    [self createNumListings:20];
    [_tempContext saveSynchronously];
    
    NSPredicate *predicate                          = [NSPredicate predicateWithFormat:@"self.numComments >= %@", [NSNumber numberWithInteger:10]];
    NSUInteger count                                = [Listing fetchCountInContext:_tempContext withPredicate:predicate];
    XCTAssertEqual((int)10, (int)count, @"There should be 10 records with numComments greater than to 10");

}

- (void)testFirstObjectInContextSortedByWithPredicate {
    [self createNumListings:20];
    
    NSDate *distF                                   = [NSDate distantFuture];
    Listing *l                                      = [_tempContext insertNewObjectWithEntityName:[Listing entityName]];
    l.uid                                           = @"SearchForMe";
    l.createdUtc                                    = distF;
    [_tempContext saveSynchronously];
    
    NSPredicate *predicate                          = [NSPredicate predicateWithFormat:@"self.uid == %@", @"SearchForMe"];
    NSSortDescriptor *sortDescriptor                = [NSSortDescriptor sortDescriptorWithKey:@"createdUtc" ascending:NO];
    
    Listing *listing                                = [Listing fetchFirstObjectInContext:_tempContext sortedBy:@[sortDescriptor] withPredicate:predicate];
    
    XCTAssertEqualObjects(distF, listing.createdUtc, @"The returned listing should have the same date");
    XCTAssertEqualObjects(@"SearchForMe", listing.uid, @"The returned listing should have the uid SearchForMe");
}

- (void)testFetchAllInContext {
    [self createNumListings:20];
    [_tempContext saveSynchronously];
    
    NSArray *listings                                = [Listing fetchAllInContext:_tempContext];
    XCTAssertEqual((int)20, (int)[listings count], @"There should be 20 records with numComments greater than to 20");
}

- (void)testFetchObjectsInContextByPageNumberWithObjectsPerPageWithSortDescriptors {
    [self createNumListings:10];
    [_tempContext saveSynchronously];

    NSSortDescriptor *sortDescriptor                = [NSSortDescriptor sortDescriptorWithKey:@"createdUtc" ascending:NO];

    NSArray *page1                                  = [Listing fetchObjectsInContext:[CYCoreData readContext]
                                                                        byPageNumber:1
                                                                  withObjectsPerPage:4
                                                                 withSortDescriptors:@[sortDescriptor]];
    NSArray *page2                                  = [Listing fetchObjectsInContext:[CYCoreData readContext]
                                                                        byPageNumber:2
                                                                  withObjectsPerPage:4
                                                                 withSortDescriptors:@[sortDescriptor]];
    NSArray *page3                                  = [Listing fetchObjectsInContext:[CYCoreData readContext]
                                                                        byPageNumber:3
                                                                  withObjectsPerPage:4
                                                                 withSortDescriptors:@[sortDescriptor]];
    
    XCTAssertEqual((int)4, (int)[page1 count], @"There should be 4 records in page 1");
    XCTAssertEqual((int)4, (int)[page2 count], @"There should be 4 records in page 2");
    XCTAssertEqual((int)2, (int)[page3 count], @"There should be 2 records in page 3");
}

- (void)testFetchObjectsInContextByPageNumberWithObjectsPerPageAndPredicateWithSortDescriptors {
    [self createNumListings:20];
    
    NSDate *distF                                   = [NSDate distantFuture];
    Listing *l                                      = [Listing updateOrCreateObjectInContext:_tempContext withDictionary:[_listingsArray objectAtIndex:0]];
    l.uid                                           = @"SearchForMe";
    l.createdUtc                                    = distF;
    l.numComments                                   = [NSNumber numberWithInteger:21];
    [_tempContext saveSynchronously];
    
    NSPredicate *predicate                          = [NSPredicate predicateWithFormat:@"self.numComments >= %@", [NSNumber numberWithInteger:10]];
    NSSortDescriptor *sortDescriptor                = [NSSortDescriptor sortDescriptorWithKey:@"createdUtc" ascending:YES];
    
    NSArray *page1                                  = [Listing fetchObjectsInContext:[CYCoreData readContext]
                                                                        byPageNumber:1
                                                                  withObjectsPerPage:4
                                                                        andPredicate:predicate
                                                                 withSortDescriptors:@[sortDescriptor]];
    NSArray *page2                                  = [Listing fetchObjectsInContext:[CYCoreData readContext]
                                                                        byPageNumber:2
                                                                  withObjectsPerPage:4
                                                                        andPredicate:predicate
                                                                 withSortDescriptors:@[sortDescriptor]];
    NSArray *page3                                  = [Listing fetchObjectsInContext:[CYCoreData readContext]
                                                                        byPageNumber:3
                                                                  withObjectsPerPage:4
                                                                        andPredicate:predicate
                                                                 withSortDescriptors:@[sortDescriptor]];
    XCTAssertEqual((int)4, (int)[page1 count], @"There should be 4 records in page 1");
    XCTAssertEqual((int)4, (int)[page2 count], @"There should be 4 records in page 2");
    XCTAssertEqual((int)3, (int)[page3 count], @"There should be 3 record in page 3");
    
    Listing *lastListing                            = [page3 lastObject];
    XCTAssertEqualObjects(distF, lastListing.createdUtc, @"The most recent listing should have the same date");
}



@end
