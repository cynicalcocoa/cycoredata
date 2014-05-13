//
//  Listing+Write.m
//  HBCoreData-Example
//
//  Created by hatebyte on 5/7/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "Listing+Write.h"
#import "CYCoreData.h"

@implementation Listing (Write)

- (void)updateWithDictionary:(NSDictionary *)dictionary {
    
    // lowercase underscored keys can be convertedt to camel case properties, insert them as camelcase
    [self setUnixDateValuesInDictionary:dictionary  forKeys:@"createdUtc", nil];
    [self setBoolValuesInDictionary:dictionary      forKeys:@"isSelf", @"clicked", nil];
    [self setStringValuesInDictionary:dictionary    forKeys:@"title", @"permalink", @"subredditId", nil];
    [self setIntegerValuesInDictionary:dictionary   forKeys:@"numComments", @"ups", nil];
    
    // id and others may need to be set manually because the keys dont match
    [self setValue:[dictionary objectForKey:@"id"]  forKey:@"uid"];
    
}

@end
