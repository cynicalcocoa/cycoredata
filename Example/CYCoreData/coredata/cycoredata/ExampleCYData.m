//
//  ExampleCYData.m
//  CYCoreData
//
//  Created by hatebyte on 8/25/14.
//  Copyright (c) 2014 cynicalcocoa. All rights reserved.
//

#import "ExampleCYData.h"

@implementation ExampleCYData

static ExampleCYData *_liason                                       = nil;
static dispatch_once_t _once_token                                  = 0;

+ (instancetype)liason {
    
    if (_liason == nil) {
        dispatch_once(&_once_token, ^{
            // Optional;
            // If the unique identifier for the model objects in not a int, and/or does not stick to the uid convention, configure immediately after.
            [ExampleCYData configureModelUniqueIdentifier:@"uid" ofDataType:UniqueObjectValueTypeString withJSONSearchString:@"id"];
            
            _liason                                                 = [[ExampleCYData alloc] initWithSqliteFileName:@"example_database"
                                                                                               withModelFileName:@"ExampleModel"];
#if TEST==1
//            [_liason setIsTest:YES];
#endif
            [_liason createStoreAndManagedObjectModel];
        });
    }
    return _liason;
}

+ (void)reset {
    NSAssert([self.class liason], @"Can't reset CYCoreData until configured. Use [configureDataBaseFileName:andModelFileName:inBundle:]");
    @synchronized(self) {
        [[ExampleCYData liason] reset];
        _once_token                                                     = 0;
        _liason                                                         = nil;
    }
}

@end



@implementation NSManagedObjectContext (CYCoreDataInstance)

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
    [ExampleCYData saveContextAndWait:wait];
}

@end
