//
//  CYCoreDataTests.m
//  CYCoreData-Example
//
//  Created by hatebyte on 5/10/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ExampleCYData.h"
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
    [ExampleCYData reset];
    [MockCYCoreData reset];
    [super tearDown];
}

- (void)testCYCoreDataLiasonReturnsCYCoreDataInsance {
    ExampleCYData *cycd                            = [ExampleCYData liason];
    XCTAssertTrue([cycd isKindOfClass:[ExampleCYData class]], @"CYCoreData liason should return and instance of CYCoreData");
}

- (void)testCYCoreDataLiasonIsASingleton {
    ExampleCYData *cycd1                           = [ExampleCYData liason];

    ExampleCYData *cycd2                           = [ExampleCYData liason];
    XCTAssertEqualObjects(cycd2, cycd1, @"CYCoreData liason should only return a single instance");
}

- (void)testConfigureWithModelFileName {
  
    MockCYCoreData *mcycd2                          = [MockCYCoreData liason];
    
    XCTAssertEqualObjects(@"ExampleModel", [mcycd2 modelFileName], @"The modle file name should be ExampleModel");
    [MockCYCoreData reset];
}

- (void)testConfigureWithSqliteFileNameForPersistantStoreURL {

    MockCYCoreData *mcycd2                          = [MockCYCoreData liason];

    NSURL *cachesDirectoryURL                       = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL                                 = [cachesDirectoryURL URLByAppendingPathComponent:@"test_database"];
    
    XCTAssertEqualObjects(storeURL.absoluteString, [mcycd2 storeURL].absoluteString, @"The url for the sqlite file should be in the cache directory.");
    [MockCYCoreData reset];
}

- (void)testIsTestReturnsInMemoryStoreWhenAppropriate {
    [MockCYCoreData liason].isTest                  = YES;
    MockCYCoreData *mcycd2                          = [MockCYCoreData liason];

    XCTAssertEqual(NSInMemoryStoreType,  [mcycd2 storeType], @"The store type should be in memory when set to isTesting YES");
}

- (void)testConfigureSearchesProperMainBundle {

    MockCYCoreData *mcycd2                          = [MockCYCoreData liason];
    NSBundle *modelFileBundle                       = [mcycd2 bundleWithModelFile];
    XCTAssertEqualObjects([NSBundle mainBundle], modelFileBundle, @"The bundle with the modle file should be the main bundle.");
}

- (void)testConfigureSearchesProperNotMainBundle {

    MockCYCoreData *mcycd2                          = [[MockCYCoreData alloc] initWithSqliteFileName:@"example_database" withModelFileName:@"ExampleModel" inBundleName:@"fakeBundle"];
    NSBundle *modelFileBundle                       = [mcycd2 bundleWithModelFile];
    XCTAssertNotEqualObjects([NSBundle mainBundle], modelFileBundle, @"The bundle with the modle file should not be the main bundle.");
}

@end
