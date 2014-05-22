//
//  CYCoreData.m
//  Capture
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "CYCoreData.h"

static NSString *DataBaseFile                                       = nil;
static NSString *ModelFile                                          = nil;
static NSString *BundleName                                         = nil;
static BOOL isTEST                                                  = NO;

@interface CYCoreData ()

@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong) NSManagedObjectContext *readContext;
@property(nonatomic, strong) NSManagedObjectContext *writeToDiskContext;

@end

@implementation CYCoreData

static CYCoreData *_liason                                          = nil;
static dispatch_once_t _once_token                                  = 0;

+ (instancetype)liason {
    NSAssert(DataBaseFile, @"Can't start up CYCoreData without DataBaseFile name. Use [configureDataBaseFileName:andModelFileName:inBundle:]");
    NSAssert(ModelFile, @"Can't start up CYCoreData without ModelFile name. Use [configureDataBaseFileName:andModelFileName:inBundle:]");

    if (_liason == nil) {
        dispatch_once(&_once_token, ^{
            _liason                                                 = [[CYCoreData alloc] init];
        });
    }
    return _liason;
}

#pragma mark - config
+ (void)configureSqliteFileName:(NSString *)dataBaseFileName withModelFileName:(NSString *)modelFileName inBundleName:(NSString *)bundleName {
    DataBaseFile                                                    = dataBaseFileName;
    ModelFile                                                       = modelFileName;
    BundleName                                                      = bundleName;
}

+ (void)configureSqliteFileName:(NSString *)dataBaseFileName withModelFileName:(NSString *)modelFileName {
    DataBaseFile                                                    = dataBaseFileName;
    ModelFile                                                       = modelFileName;
    BundleName                                                      = nil;
}

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

+ (void)setTesting:(BOOL)isTesting {
    isTEST                                                          = isTesting;
}

#pragma mark - class
+ (void)reset {
    NSAssert([CYCoreData liason], @"Can't reset CYCoreData until configured. Use [configureDataBaseFileName:andModelFileName:inBundle:]");
    
    [_liason.readContext performBlockAndWait:^{
        [_liason.readContext reset];
        _liason.readContext                                         = nil;
    }];
    
    [_liason.writeToDiskContext performBlockAndWait:^{
        [_liason.writeToDiskContext reset];
        _liason.writeToDiskContext                                  = nil;
    }];
    
    NSError *error                                                  = nil;
    for (NSPersistentStore *store in _liason.persistentStoreCoordinator.persistentStores) {
        [_liason.persistentStoreCoordinator  removePersistentStore:store error:&error];
        if (error) {
            NSLog(@"Unresolved error removing store from persistentStoreCoordinator url file : %@, %@", store, error);
        }
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[_liason storeURL].path]) {
        if (![[NSFileManager defaultManager] removeItemAtPath:[_liason storeURL].path error:&error]) {
            NSLog(@"Unresolved error removing store url file : %@, %@", error, [error userInfo]);
            abort();
        }
    }
    _liason.managedObjectModel                                      = nil;
    _liason.persistentStoreCoordinator                              = nil;
    _once_token                                                     = 0;
    _liason                                                         = nil;
}

+ (NSManagedObjectContext *)readContext {
    return [[CYCoreData liason] readContext];
}

+ (NSManagedObjectContext *)temporaryWriteContext {
    return [[CYCoreData liason] temporaryWriteContext];
}

+ (void)saveSynchronously {
    return [[CYCoreData liason] saveContextAndWait:YES];
}

+ (void)saveAsynchronously {
    return [[CYCoreData liason] saveContextAndWait:NO];
}

+ (void)saveContextAndWait:(BOOL)andWait {
    return [[CYCoreData liason] saveContextAndWait:andWait];
}

#pragma mark - private
- (id)init {
    if (self= [super init]) {
        [self createStoreAndManagedObjectModel];
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
    return [NSString stringWithFormat:@"%@", ModelFile];
}

- (NSURL *)storeURL {
    NSURL *cachesDirectoryURL                                       = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    return [cachesDirectoryURL URLByAppendingPathComponent:DataBaseFile];
}

- (NSString*)storeType {
    return (isTEST) ? NSInMemoryStoreType : NSSQLiteStoreType;
}

- (NSBundle *)bundleWithModelFile {
    NSBundle *dataFileBundle;
    if (BundleName.length > 0) {
        NSString *staticLibraryBundlePath                           = [[NSBundle mainBundle] pathForResource:BundleName ofType:@"bundle"];
        dataFileBundle                                              = [NSBundle bundleWithPath:staticLibraryBundlePath];
    } else {
        dataFileBundle                                              = [NSBundle mainBundle];
    }
    return dataFileBundle;
}

@end























