//
//  RedditListingResponseSerializer.h
//  HBCoreData-Example
//
//  Created by hatebyte on 5/7/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "AFURLResponseSerialization.h"

@interface RedditListingResponseSerializer : AFJSONResponseSerializer

@property(nonatomic, strong) NSManagedObjectContext *tempContext;

+ (instancetype)serializerWithTempContext:(NSManagedObjectContext *)tempContext;
- (instancetype)initWithTempContext:(NSManagedObjectContext *)tempContext;

@end
