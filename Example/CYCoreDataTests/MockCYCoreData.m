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

static MockCYCoreData *_liason                                      = nil;
static dispatch_once_t _once_token                                  = 0;

+ (instancetype)liason {
    if (_liason == nil) {
        dispatch_once(&_once_token, ^{
            _liason                                                 = [[MockCYCoreData alloc] init];
        });
    }
    return _liason;
}

- (void)createStoreAndManagedObjectModel {
}


@end
