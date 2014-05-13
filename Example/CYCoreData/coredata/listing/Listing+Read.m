//
//  Listing+Read.m
//  HBCoreData-Example
//
//  Created by hatebyte on 5/7/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "Listing+Read.h"
#import "CYCoreData.h"

@implementation Listing (Read)

+ (NSArray *)fetchListingsWithCommentsOver:(int)commentCount withContext:(NSManagedObjectContext *)context {
    NSSortDescriptor *dateDescriptor                = [[NSSortDescriptor alloc] initWithKey:@"createdUtc" ascending:NO];
    NSPredicate *predicate                          = [NSPredicate predicateWithFormat:@"self.numComments > %@", [NSNumber numberWithInt:commentCount]];
    return [Listing fetchObjectsInContext:context sortedBy:@[dateDescriptor] withPredicate:predicate];
}

+ (NSArray *)fetchMostRecentWithContext:(NSManagedObjectContext *)context {
    NSSortDescriptor *dateDescriptor                = [[NSSortDescriptor alloc] initWithKey:@"createdUtc" ascending:NO];
    return [Listing fetchObjectsInContext:context sortedBy:@[dateDescriptor] withPredicate:nil];
}


@end
