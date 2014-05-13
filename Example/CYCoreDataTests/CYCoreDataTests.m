//
//  CYCoreDataTests.m
//  CYCoreData-Example
//
//  Created by hatebyte on 5/10/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CYCoreData.h"
#import "MockCYCoreData.h"

@interface CYCoreDataTests : XCTestCase

@end

@implementation CYCoreDataTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCYCoreDataLiasonReturnsCYCoreDataInsance {
    CYCoreData *cycd                            = [CYCoreData liason];
    XCTAssertTrue([cycd isKindOfClass:[CYCoreData class]], @"CYCoreData liason should return and instance of CYCoreData");
}

- (void)testCYCoreDataLiasonIsASingleton {
    CYCoreData *cycd1                           = [CYCoreData liason];

    CYCoreData *cycd2                           = [CYCoreData liason];
    XCTAssertEqualObjects(cycd2, cycd1, @"CYCoreData liason should only return a single instance");
}

- (void)testConfigureWithModelFileName {
    [CYCoreData configureSqliteFileName:@"example_database" withModelFileName:@"ExampleModel" ];
  
    MockCYCoreData *mcycd2                      = [MockCYCoreData liason];
    
    XCTAssertEqualObjects(@"ExampleModel", [mcycd2 modelFileName], @"The modle file name should be ExampleModel");
    [CYCoreData reset];
}

- (void)testConfigureWithSqliteFileNameForPersistantStoreURL {
    [CYCoreData configureSqliteFileName:@"example_database" withModelFileName:@"ExampleModel" ];
   MockCYCoreData *mcycd2                      = [MockCYCoreData liason];

    NSURL *cachesDirectoryURL                   = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL                             = [cachesDirectoryURL URLByAppendingPathComponent:@"example_database"];
    
    XCTAssertEqualObjects(storeURL.absoluteString, [mcycd2 storeURL].absoluteString, @"The url for the sqlite file should be in the cache directory.");
    [CYCoreData reset];
}

- (void)testIsTestReturnsInMemoryStoreWhenAppropriate {
    MockCYCoreData *mcycd2                      = [MockCYCoreData liason];

    XCTAssertEqual(NSSQLiteStoreType, [mcycd2 storeType], @"The store type should be in sqlite when set to isTesting has not been called");

    [CYCoreData setTesting:YES];
    XCTAssertEqual(NSInMemoryStoreType,  [mcycd2 storeType], @"The store type should be in memory when set to isTesting YES");
}

- (void)testConfigureSearchesProperMainBundle {
    [CYCoreData configureSqliteFileName:@"example_database" withModelFileName:@"ExampleModel" ];
    MockCYCoreData *mcycd2                      = [MockCYCoreData liason];
    NSBundle *modelFileBundle                   = [mcycd2 bundleWithModelFile];
    XCTAssertEqualObjects([NSBundle mainBundle], modelFileBundle, @"The bundle with the modle file should be the main bundle.");
}

- (void)testConfigureSearchesProperNotMainBundle {
    [CYCoreData configureSqliteFileName:@"example_database" withModelFileName:@"ExampleModel" inBundleName:@"newBundle"];
    MockCYCoreData *mcycd2                      = [MockCYCoreData liason];
    NSBundle *modelFileBundle                   = [mcycd2 bundleWithModelFile];
    
    XCTAssertNotEqualObjects([NSBundle mainBundle], modelFileBundle, @"The bundle with the modle file should not be the main bundle.");
}

@end
