//
//  Listing.h
//  HBCoreData-Example
//
//  Created by hatebyte on 5/8/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Listing : NSManagedObject

@property (nonatomic, retain) NSNumber * clicked;
@property (nonatomic, retain) NSDate * createdUtc;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSNumber * isSelf;
@property (nonatomic, retain) NSNumber * numComments;
@property (nonatomic, retain) NSString * permalink;
@property (nonatomic, retain) NSString * subredditId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * ups;

@end
