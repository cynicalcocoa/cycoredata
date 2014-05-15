//
//  Listing+Util.h
//  HBCoreData-Example
//
//  Created by hatebyte on 5/7/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "Listing.h"

@interface Listing (Util)

#pragma mark - get int conversion
- (int)numCommentsInt;
- (int)upsInt;
- (BOOL)isSelfBool;
- (BOOL)clickedBool;

#pragma mark - set int conversion
- (void)setNumCommentsInt:(int)numComments;
- (void)setUpsInt:(int)ups;
- (void)setIsSelfBool:(BOOL)isSelf;
- (void)setClickedBool:(BOOL)clicked;

#pragma mark - string utils for textfields
- (NSString *)clickedString;
- (NSString *)numCommentsString;
- (NSString *)upsString;

@end
