//
//  MockHBCoreData.h
//  HBCoreData-Example
//
//  Created by hatebyte on 5/10/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "CYCoreData.h"

#pragma clang diagnostic ignored "-Wincomplete-implementation"

static BOOL IsTestingBundleName                                       = NO;

@interface MockCYCoreData : CYCoreData

@property(nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark - string helpers
- (NSString *)modelFileName;
- (NSURL *)storeURL;
- (NSURL *)cachesDirectoryURL;
- (NSString*)storeType;
- (NSBundle *)bundleWithModelFile;

- (void)createStoreAndManagedObjectModel;

@end
