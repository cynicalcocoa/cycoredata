//
//  CYCoreData.m
//  Capture
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "CYCoreData.h"

static NSString *DBPATH                                             = @"com.cynicalcocoa.cycoredata";

@interface CYCoreData ()

@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong) NSManagedObjectContext *writeToDiskContext;

@end

@implementation CYCoreData

#pragma mark - class convience methods
static id _liason                                                   = nil;
static dispatch_once_t _once_token                                  = 0;

+ (instancetype)liason {
    if (_liason == nil) {
        dispatch_once(&_once_token, ^{
            // Optional;
            // If the unique identifier for the model objects in not a int, and/or does not stick to the uid convention, configure immediately after.
            [self.class configureModelUniqueIdentifier:@"uid" ofDataType:UniqueObjectValueTypeString withJSONSearchString:@"id"];
            _liason                                                 = [[self.class alloc] initWithSqliteFileName:@"example_database" withModelFileName:@"ExampleModel"];
            [_liason createStoreAndManagedObjectModel];
        });
    }
    return _liason;
}

+ (void)reset {
    NSAssert([self.class liason], @"Can't reset CYCoreData until configured. Use [configureDataBaseFileName:andModelFileName:inBundle:]");
    
    [[self.class liason] reset];
    _once_token                                                     = 0;
    _liason                                                         = nil;
}

+ (NSManagedObjectContext *)readContext {
    return [[self.class liason] readContext];
}

+ (NSManagedObjectContext *)temporaryWriteContext {
    return [[self.class liason] temporaryWriteContext];
}

+ (void)saveSynchronously {
    return [[self.class liason] saveSynchronously];
}

+ (void)saveAsynchronously {
    return [[self.class liason] saveAsynchronously];
}

+ (void)saveContextAndWait:(BOOL)shouldWait {
    return [[self.class liason] saveContextAndWait:shouldWait];
}



#pragma mark - config

+ (void)configureModelUniqueIdentifier:(NSString *)uniquePropertyKey
                            ofDataType:(UniqueObjectValueType)uniqueObjectValueType
                  withJSONSearchString:(NSString *)jsonSearchPropertyKey {
    [NSManagedObject configureModelUniqueIdentifier:uniquePropertyKey
                                         ofDataType:uniqueObjectValueType
                               withJSONSearchString:jsonSearchPropertyKey];
}

+ (void)configureUniqueIdentifier:(UniqueIdentiferStruct)uniqueIdentiferStruct {
    [NSManagedObject configureUniqueIdentifier:uniqueIdentiferStruct];
}



#pragma mark - class
- (void)reset {

    [self.readContext performBlockAndWait:^{
        [self.readContext reset];
        self.readContext                                         = nil;
    }];
    
    [self.writeToDiskContext performBlockAndWait:^{
        [self.writeToDiskContext reset];
        self.writeToDiskContext                                  = nil;
    }];
    
    NSError *error                                                  = nil;
    for (NSPersistentStore *store in self.persistentStoreCoordinator.persistentStores) {
        [self.persistentStoreCoordinator  removePersistentStore:store error:&error];
        if (error) {
            NSLog(@"Unresolved error removing store from persistentStoreCoordinator url file : %@, %@", store, error);
        }
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self storeURL].path]) {
        if (![[NSFileManager defaultManager] removeItemAtPath:[self storeURL].path error:&error]) {
            NSLog(@"Unresolved error removing store url file : %@, %@", error, [error userInfo]);
            abort();
        }
    }
    self.managedObjectModel                                      = nil;
    self.persistentStoreCoordinator                              = nil;
}

- (void)saveSynchronously {
    return [self saveContextAndWait:YES];
}

- (void)saveAsynchronously {
    return [self saveContextAndWait:NO];
}

#pragma mark - private
- (id)initWithSqliteFileName:(NSString *)dataBaseFileName withModelFileName:(NSString *)modelFileName inBundleName:(NSString *)bundleName {
    if (self= [super init]) {
        NSAssert(dataBaseFileName, @"Can't start up CYCoreData without DataBaseFile name. Use [configureDataBaseFileName:andModelFileName:inBundle:]");
        NSAssert(modelFileName, @"Can't start up CYCoreData without ModelFile name. Use [configureDataBaseFileName:andModelFileName:inBundle:]");
        
        self.dataBaseFile                                       = dataBaseFileName;
        self.modelFile                                          = modelFileName;
        self.bundleName                                         = bundleName;

    }
    return self;
}

- (id)initWithSqliteFileName:(NSString *)dataBaseFileName withModelFileName:(NSString *)modelFileName  {
    if (self= [self initWithSqliteFileName:dataBaseFileName withModelFileName:modelFileName inBundleName:nil]) {
    }
    return self;
}

- (void)createStoreAndManagedObjectModel {
    NSURL *storeURL                                             = [self storeURL];
    self.persistentStoreCoordinator                             = [self persistentStoreCoordinatorWithModel:self.managedObjectModel andStoreURL:storeURL];
}

- (void)saveContextAndWait:(BOOL)andWait {
    if (!_readContext) return;
   
    if ([_readContext hasChanges]) {
        [_readContext performBlockAndWait:^{
            NSError *error                                          = nil;
            [_readContext save:&error];
            if (error) {
                NSLog(@"Error saving _readContext: %@", error);
            }
        }];
    }
    
    void (^savePrivate) (void) = ^{
        NSError *error                                              = nil;
        [_writeToDiskContext save:&error];
        if (error) {
            NSLog(@"Error saving _writingContext: %@", error);
        }
    };
    
    if ([_writeToDiskContext hasChanges]) {
        if (andWait) {
            [_writeToDiskContext performBlockAndWait:savePrivate];
        } else {
            [_writeToDiskContext performBlock:savePrivate];
        }
    }
}

- (NSManagedObjectContext *)readContext {
    if (!_readContext) {
        if (_persistentStoreCoordinator) {
            _writeToDiskContext                                     = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [_writeToDiskContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
            
            _readContext                                            = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_readContext setParentContext:_writeToDiskContext];
        }
    }
    return _readContext;
}

- (NSManagedObjectContext *)temporaryWriteContext {
    NSManagedObjectContext *temporaryWriteContext                   = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryWriteContext.parentContext                             = self.readContext;
    return temporaryWriteContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSBundle *dataFileBundle                                    = [self bundleWithModelFile];
        NSURL *modelURL                                             = [dataFileBundle URLForResource:[self modelFileName] withExtension:@"momd"];
        _managedObjectModel                                         = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithModel:(NSManagedObjectModel*)modelObject andStoreURL:(NSURL*)storeURL {
    NSError *error                                                  = nil;
    NSDictionary *options                                           = @{
                                                                        NSMigratePersistentStoresAutomaticallyOption  : @YES,
                                                                        NSInferMappingModelAutomaticallyOption        : @YES
                                                                        };
    
    
    NSPersistentStoreCoordinator *psc                               = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:modelObject];
    [psc addPersistentStoreWithType:[self storeType]
                      configuration:nil
                                URL:storeURL
                            options:options
                              error:&error];
    
    if (!psc || psc.persistentStores.count == 0) {
        UIAlertView *alert                                          = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to load database.", @"CYCoreData - Alert title")
                                                                                                 message:NSLocalizedString(@"Delete the current database and/or app and try again", @"CYCoreData - Alert message")
                                                                                                delegate:self
                                                                                       cancelButtonTitle:NSLocalizedString(@"Dismiss", "CYCoreData - Alert Dismiss Button Title")
                                                                                       otherButtonTitles:nil];
        [alert show];
    }
    return psc;
}

#pragma mark - string helpers
- (NSString *)modelFileName {
    return [NSString stringWithFormat:@"%@", self.modelFile];
}

- (NSURL *)storeURL {
    NSURL *cachesDirectoryURL                                       = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    @synchronized(self) {
        cachesDirectoryURL                                          = [cachesDirectoryURL URLByAppendingPathComponent:DBPATH];
        NSError * error                                             = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:cachesDirectoryURL.path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        if (error != nil) {
            NSAssert(false, @"Error creating directory for database in location : %@", cachesDirectoryURL.absoluteString);
        }
    }

    return [cachesDirectoryURL URLByAppendingPathComponent:self.dataBaseFile];
}

- (NSString*)storeType {
    return (self.isTest) ? NSInMemoryStoreType : NSSQLiteStoreType;
}

- (NSBundle *)bundleWithModelFile {
    NSBundle *dataFileBundle;
    if (self.bundleName.length > 0) {
        NSString *staticLibraryBundlePath                           = [[NSBundle mainBundle] pathForResource:self.bundleName ofType:@"bundle"];
        dataFileBundle                                              = [NSBundle bundleWithPath:staticLibraryBundlePath];
    } else {
        dataFileBundle                                              = [NSBundle mainBundle];
    }
    return dataFileBundle;
}

@end























