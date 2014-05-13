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
- (int)clickedInt;
- (int)numCommentsInt;
- (int)upsInt;
- (BOOL)isSelfBool;

#pragma mark - set int conversion
- (void)setClickedInt:(int)clicked;
- (void)setNumCommentsInt:(int)numComments;
- (void)setUpsInt:(int)ups;
- (void)setIsSelfBool:(BOOL)isSelf;

#pragma mark - string utils for textfields
- (NSString *)clickedString;
- (NSString *)numCommentsString;
- (NSString *)upsString;

@end
