//
//  Listing+API.m
//  HBCoreData-Example
//
//  Created by hatebyte on 5/7/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "Listing+API.h"
#import <AFNetworking.h>
#import "RedditListingResponseSerializer.h"
#import "ExampleCYData.h"

@implementation Listing (API)

+ (AFHTTPRequestOperation * )getRedditListingsWithComplete:(completeBlock)completeBlock failure:(failBlock)failBlock {
    
    NSManagedObjectContext *tempContext                         = [ExampleCYData temporaryWriteContext];
    RedditListingResponseSerializer *responseSerializer         = [RedditListingResponseSerializer serializerWithTempContext:tempContext];

    NSURLRequest * request                                      = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://reddit.com/.json"]];
    AFHTTPRequestOperation * operation                          = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer                                = responseSerializer;

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [responseSerializer.tempContext saveAsynchronously];
        completeBlock();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failBlock(error);
    
    }];
    [operation start];
    return operation;
}

@end
