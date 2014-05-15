//
//  Listing+Util.m
//  HBCoreData-Example
//
//  Created by hatebyte on 5/7/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//

#import "Listing+Util.h"

@implementation Listing (Util)

#pragma mark - get int conversion
- (BOOL)clickedBool {
    return [self.clicked boolValue];
}

- (int)numCommentsInt {
    return [self.numComments intValue];
}

- (int)upsInt {
    return [self.ups intValue];
}

- (BOOL)isSelfBool {
    return [self.isSelf boolValue];
}

#pragma mark - set int conversion
- (void)setNumCommentsInt:(int)numComments {
    [self setValue:[NSNumber numberWithInt:numComments] forKeyPath:@"numComments"];
}

- (void)setUpsInt:(int)ups {
    [self setValue:[NSNumber numberWithInt:ups] forKeyPath:@"ups"];
}

- (void)setIsSelfBool:(BOOL)isSelf {
    [self setValue:[NSNumber numberWithBool:isSelf] forKeyPath:@"isSelf"];
}

- (void)setClickedBool:(BOOL)clicked {
    [self setValue:[NSNumber numberWithBool:clicked] forKeyPath:@"clicked"];
}


#pragma mark - string utils for textfields
- (NSString *)clickedString {
    return [NSString stringWithFormat:@"%@", self.clicked];
}

- (NSString *)numCommentsString {
    return [NSString stringWithFormat:@"%@", self.numComments];
}

- (NSString *)upsString {
    return [NSString stringWithFormat:@"%@", self.ups];
}

@end
