//
//  Listing+Read.h
//  HBCoreData-Example
//
//  Created by hatebyte on 5/7/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "Listing.h"

@interface Listing (Read)

+ (NSArray *)fetchListingsWithCommentsOver:(int)commentCount withContext:(NSManagedObjectContext *)context;

+ (NSArray *)fetchMostRecentWithContext:(NSManagedObjectContext *)context;

@end
