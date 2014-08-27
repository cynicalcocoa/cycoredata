//
//  MockHBCoreData.m
//  HBCoreData-Example
//
//  Created by hatebyte on 5/10/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "MockCYCoreData.h"


@interface MockCYCoreData ()


@end


@implementation MockCYCoreData

#pragma mark - class convience methods
static id _liason                                                   = nil;
static dispatch_once_t _once_token                                  = 0;

+ (instancetype)liason {
    if (_liason == nil) {
        dispatch_once(&_once_token, ^{
            // Optional;
            // If the unique identifier for the model objects in not a int, and/or does not stick to the uid convention, configure immediately after.
            [self.class configureModelUniqueIdentifier:@"uid" ofDataType:UniqueObjectValueTypeString withJSONSearchString:@"id"];
            
            _liason                                                 = [[self.class alloc] initWithSqliteFileName:@"test_database"
                                                                                               withModelFileName:@"ExampleModel"];
     
//            Leave this commented for now. Setting the persistant store type NSInMemoryStoreType does
//            caused a EXC_BAD_ACCESS for arm64 and armv6s.   
//            NSSQLiteStoreType does not so we will just clear it after we test
//
//            [(MockCYCoreData *)_liason setIsTest:YES];

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

- (void)createStoreAndManagedObjectModel {
    
}


@end
