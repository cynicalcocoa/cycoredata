//
//  NSManagedObject+CYCoreData.m
//  SharedFiles
//
//  Created by hatebyte on 5/6/14.
//  Copyright (c) 2014 hatebyte. All rights reserved.
//


#import "NSManagedObject+CYCoreData.h"
#import "NSManagedObjectContext+CYCoreData.h"
#import "NSDate+Util.h"

static UniqueObjectValueType UniqueValueType    = UniqueObjectValueTypeInteger;
static NSString *JsonPropertyKey                = @"id";
static NSString *UniquePropertyKey              = @"uid";

@implementation NSManagedObject (CYCoreData)


/**************************************************************************************
 CONFIG
 **************************************************************************************/
+ (void)configureUniqueIdentifier:(UniqueIdentiferStruct)uniqueIdentiferStruct {
    [self configureModelUniqueIdentifier:uniqueIdentiferStruct.uniquePropertyKey
                              ofDataType:uniqueIdentiferStruct.uniqueObjectValueType
                    withJSONSearchString:uniqueIdentiferStruct.jsonSearchPropertyKey];
}

+ (void)configureModelUniqueIdentifier:(NSString *)uniquePropertyKey
                            ofDataType:(UniqueObjectValueType)uniqueObjectValueType
                  withJSONSearchString:(NSString *)jsonSearchPropertyKey {
    if (uniqueObjectValueType) {
        UniqueValueType                         = uniqueObjectValueType;
    }
    if (jsonSearchPropertyKey) {
        JsonPropertyKey                         = jsonSearchPropertyKey;
    }
    if (uniquePropertyKey) {
        UniquePropertyKey                       = uniquePropertyKey;
    }
}

/**************************************************************************************
 WRITE
 **************************************************************************************/
+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}

+ (instancetype)newObjectInContext:(NSManagedObjectContext *)context {
    return [context insertNewObjectWithEntityName:[self entityName]];
}

+ (instancetype)updateOrCreateObjectInContext:(NSManagedObjectContext *)context withDictionary:(NSDictionary *)dictionary {
    NSManagedObject *entity                     = nil;
    id jsonproperty                             = [dictionary valueForKey:JsonPropertyKey];
    switch (UniqueValueType) {
        case UniqueObjectValueTypeInt:
            jsonproperty                        = [NSNumber numberWithInt:[jsonproperty intValue]];
            break;
        case UniqueObjectValueTypeInteger:
            jsonproperty                        = [NSNumber numberWithInteger:[jsonproperty integerValue]];
            break;
        case UniqueObjectValueTypeDouble:
            jsonproperty                        = [NSNumber numberWithFloat:[jsonproperty doubleValue]];
            break;
        case UniqueObjectValueTypeFloat:
            jsonproperty                        = [NSNumber numberWithFloat:[jsonproperty floatValue]];
            break;
        default:
            break;
    }
    if (jsonproperty && ![jsonproperty isEqual:[NSNull null]]) {
        NSPredicate *predicate                  = [NSPredicate predicateWithFormat:@"self.%@ == %@", UniquePropertyKey, jsonproperty];
        entity                                  = [context fetchFirstObjectWithEntityName:[self entityName] sortedBy:nil withPredicate:predicate];
    }
    if (!entity) {
        entity                                  = [self newObjectInContext:context];
    }
    
    [entity updateWithDictionary:dictionary];
    return entity;
}

+ (void)deleteAllObjectsInContext:(NSManagedObjectContext *)context {
    [context deleteAllObjectsWithEntityName:[self entityName]];
}

+ (void)deleteObjectsInContext:(NSManagedObjectContext *)context sortedBy:(NSArray *)sortDescriptors withPredicate:(NSPredicate *)predicate {
    [context deleteObjectsWithEntityName:[self entityName] sortDescriptors:sortDescriptors andPredicate:predicate];
}

#pragma mark - override methods
- (void)updateWithDictionary:(NSDictionary *)dictionary {
    NSAssert(false, @"updateWithDictionary must be overridded in %@+Write.m", NSStringFromClass([self class]));
}

#pragma mark - object mapping methods
- (void)setBoolValuesInDictionary:(NSDictionary *)dictionary forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args; va_start(args, first);
    [self setManagedObjectValueType:UniqueObjectValueTypeBool withDictionary:dictionary firstAttribute:first args:args];
}

- (void)setIntValuesInDictionary:(NSDictionary *)dictionary forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args; va_start(args, first);
    [self setManagedObjectValueType:UniqueObjectValueTypeInt withDictionary:dictionary firstAttribute:first args:args];
}

- (void)setIntegerValuesInDictionary:(NSDictionary *)dictionary forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args; va_start(args, first);
    [self setManagedObjectValueType:UniqueObjectValueTypeInteger withDictionary:dictionary firstAttribute:first args:args];
}

- (void)setFloatValuesInDictionary:(NSDictionary *)dictionary forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args; va_start(args, first);
    [self setManagedObjectValueType:UniqueObjectValueTypeFloat withDictionary:dictionary firstAttribute:first args:args];
}

- (void)setDoubleValuesInDictionary:(NSDictionary *)dictionary forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args; va_start(args, first);
    [self setManagedObjectValueType:UniqueObjectValueTypeDouble withDictionary:dictionary firstAttribute:first args:args];
}

- (void)setDateValuesInDictionary:(NSDictionary *)dictionary forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args; va_start(args, first);
    [self setManagedObjectValueType:UniqueObjectValueTypeDate withDictionary:dictionary firstAttribute:first args:args];
}

- (void)setUnixDateValuesInDictionary:(NSDictionary *)dictionary forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args; va_start(args, first);
    [self setManagedObjectValueType:UniqueObjectValueTypeUnixDate withDictionary:dictionary firstAttribute:first args:args];
}

- (void)setMicrosecondDateValuesInDictionary:(NSDictionary *)dictionary forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args; va_start(args, first);
    [self setManagedObjectValueType:UniqueObjectValueTypeMicrosecondDate withDictionary:dictionary firstAttribute:first args:args];
}

- (void)setStringValuesInDictionary:(NSDictionary *)dictionary forKeys:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION {
    va_list args; va_start(args, first);
    [self setManagedObjectValueType:UniqueObjectValueTypeString withDictionary:dictionary firstAttribute:first args:args];
}

- (void)setManagedObjectValueType:(UniqueObjectValueType)type withDictionary:(NSDictionary *)dictionary firstAttribute:(NSString *)first args:(va_list)args {
    for (NSString *objectKey = first; objectKey != nil; objectKey = va_arg(args, NSString *)) {
        NSString *dictionaryKey                     = [self camelCaseToUnderscore:objectKey];
        [self setKeyValue:objectKey fromKey:dictionaryKey inDictionary:dictionary forManagedObjectValueType:type];
    }
    va_end(args);
}

- (void)setKeyValue:(NSString *)keyValue fromKey:(NSString *)key inDictionary:(NSDictionary *)dictionary forManagedObjectValueType:(UniqueObjectValueType)type {
    id attribute                                    = [dictionary objectForKey:key];
    if (attribute && attribute != [NSNull null]) {
        switch (type) {
            case UniqueObjectValueTypeBool:
                [self setValue:[NSNumber numberWithInt:[attribute boolValue]] forKey:keyValue];
                break;
            case UniqueObjectValueTypeInt:
                [self setValue:[NSNumber numberWithInt:[attribute intValue]] forKey:keyValue];
                break;
            case UniqueObjectValueTypeInteger:
                [self setValue:[NSNumber numberWithInteger:[attribute integerValue]] forKey:keyValue];
                break;
            case UniqueObjectValueTypeFloat:
                [self setValue:[NSNumber numberWithFloat:[attribute floatValue]] forKey:keyValue];
                break;
            case UniqueObjectValueTypeDouble:
                [self setValue:[NSNumber numberWithDouble:[attribute doubleValue]] forKey:keyValue];
                break;
            case UniqueObjectValueTypeMicrosecondDate:
                [self setValue:[NSDate dateFromMicroSecondsString:attribute] forKey:keyValue];
                break;
            case UniqueObjectValueTypeUnixDate:
                [self setValue:[NSDate dateForUnixString:attribute] forKey:keyValue];
                break;
            case UniqueObjectValueTypeDate:
                [self setValue:[NSDate dateFromString:attribute] forKey:keyValue];
                break;
            case UniqueObjectValueTypeString:
                [self setValue:attribute forKey:keyValue];
                break;
        }
    }
}

- (NSString *)camelCaseToUnderscore:(NSString *)dataAttribute {
    NSRegularExpression *capitals                   = [NSRegularExpression regularExpressionWithPattern:@"[A-Z]"
                                                                                                options:0
                                                                                                  error:nil];
    dataAttribute                                   = [capitals stringByReplacingMatchesInString:dataAttribute
                                                                                         options:0
                                                                                           range:NSMakeRange(0, dataAttribute.length)
                                                                                    withTemplate:@"_$0"];
    return [dataAttribute lowercaseString];
}


/**************************************************************************************
 READ
 **************************************************************************************/
+ (NSArray *)fetchObjectsInContext:(NSManagedObjectContext *)context sortedBy:(NSArray *)sortDescriptors withPredicate:(NSPredicate *)predicate {
    return [context fetchObjectsWithEntityName:[self entityName] sortedBy:sortDescriptors withPredicate:predicate];
}

+ (NSUInteger)fetchCountInContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate {
    return [context fetchCountWithEntityName:[self entityName] andPredicate:predicate];
}

+ (instancetype)fetchFirstObjectInContext:(NSManagedObjectContext *)context sortedBy:(NSArray *)sortDescriptors withPredicate:(NSPredicate *)predicate {
    return [context fetchFirstObjectWithEntityName:[self entityName] sortedBy:sortDescriptors withPredicate:predicate];
}

+ (NSArray *)fetchAllInContext:(NSManagedObjectContext *)context {
    return [self fetchObjectsInContext:context sortedBy:nil withPredicate:nil];
}

+ (NSArray *)fetchObjectsInContext:(NSManagedObjectContext *)context byPageNumber:(NSInteger)pageNumber withObjectsPerPage:(NSInteger)perPage withSortDescriptors:(NSArray *)sortDescriptors {
    return [context fetchObjectsWithEntityName:[self entityName]
                                  byPageNumber:pageNumber
                            withObjectsPerPage:perPage
                                  andPredicate:nil
                           withSortDescriptors:sortDescriptors];
}

+ (NSArray *)fetchObjectsInContext:(NSManagedObjectContext *)context byPageNumber:(NSInteger)pageNumber withObjectsPerPage:(NSInteger)perPage andPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors {
    return [context fetchObjectsWithEntityName:[self entityName]
                                  byPageNumber:pageNumber
                            withObjectsPerPage:perPage
                                  andPredicate:predicate
                           withSortDescriptors:sortDescriptors];
}

@end
