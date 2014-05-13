//
//  Listing+API.h
//  HBCoreData-Example
//
//  Created by hatebyte on 5/7/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "Listing.h"

typedef void (^completeBlock)();
typedef void (^failBlock)(NSError *error);

@class AFHTTPRequestOperation;
@interface Listing (API)

+ (AFHTTPRequestOperation * )getRedditListingsWithComplete:(completeBlock)completeBlock failure:(failBlock)failBlock;

@end
