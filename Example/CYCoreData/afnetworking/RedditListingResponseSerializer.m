//
//  RedditListingResponseSerializer.m
//  HBCoreData-Example
//
//  Created by hatebyte on 5/7/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "RedditListingResponseSerializer.h"
#import "CYCoreData.h"
#import "Listing.h"

@interface RedditListingResponseSerializer ()

@end

@implementation RedditListingResponseSerializer

+ (instancetype)serializerWithTempContext:(NSManagedObjectContext *)tempContext {
    return [[RedditListingResponseSerializer alloc] initWithTempContext:tempContext];
}

- (instancetype)initWithTempContext:(NSManagedObjectContext *)tempContext {
    if (self = [super init]) {
        _tempContext                                    = tempContext;
    }
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    NSDictionary *responseObject                        = [super responseObjectForResponse:response data:data error:error];
    id returnObject                                     = [@[] mutableCopy];
    NSArray *jsonObject                                 = [[responseObject objectForKey:@"data"] objectForKey:@"children"];

    [jsonObject enumerateObjectsUsingBlock:^(NSDictionary *listingDict, NSUInteger idx, BOOL *stop) {
        NSDictionary *properties                        = [listingDict objectForKey:@"data"];
        Listing *listing                                = [Listing updateOrCreateObjectInContext:_tempContext withDictionary:properties];
        [returnObject addObject:listing];
    }];
    
    return returnObject;
}

@end
