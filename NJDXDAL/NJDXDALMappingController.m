//
//  ObjectMapper.m
//  TestConnection
//
//  Created by Yury Grinenko on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <objc/runtime.h>
#import "NSString+Extensions.h"
#import "NJDXDALMappingController.h"

@interface NJDXDALMappingController () 
{
    id _container;
    Class _mappingClass;
    NSDictionary *_classProperties;
    NSDictionary *_mappingConfig;
    objc_property_t *_objcClassProperties;    
}

- (NSArray *)makeObjectsFromContainer:(id)container;
- (NSDictionary *)getPropertiesOfClass:(Class)class;
- (id)getObjectWithClass:(Class)class fromDictionary:(NSDictionary *)dictionary;
- (void)setValue:(id)propertyValue forProperty:(NSString *)propertyName ofObject:(id)object;
- (NSSet *)getSetOfPossibleNames:(NSString *)name;
- (id)formatDateFrom:(NSString *)dateString;
- (BOOL)isDateProperty:(NSString *)propertyName;

@end

@implementation NJDXDALMappingController

- (id)initWithContainer:(id)container mappingConfigurator:(NJDXDALMappingConfigurator *)mappingConfigurator 
{
    self = [super init];
    if (self) {
        _container = container;
        if (mappingConfigurator.mappingClass == NSClassFromString(@"NSDictionary")) {
            _mappingClass = NSClassFromString(@"NSMutableDictionary");
        }
        else {
            _mappingClass = mappingConfigurator.mappingClass;
        }
        _classProperties = [self getPropertiesOfClass:_mappingClass];
        _mappingConfig = mappingConfigurator.mappingConfig;
    }
    return self;
}

- (NSArray *)start 
{
    return [self makeObjectsFromContainer:_container];
}

- (NSArray *)makeObjectsFromContainer:(id)container 
{
    NSMutableArray *objectsArray = [NSMutableArray new];
    if ([container isKindOfClass:[NSDictionary class]]) {
        id object = [self getObjectWithClass:_mappingClass fromDictionary:container];
        [objectsArray addObject:object];
    }
    else {
        if ([container isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictionary in container) {
                id object = [self getObjectWithClass:_mappingClass fromDictionary:dictionary];
                [objectsArray addObject:object];
            }
        }
        else {
            NSLog(@"Unknown container!");
            return nil;
        }
    }
    return objectsArray;
}


- (NSDictionary *)getPropertiesOfClass:(Class)class 
{
    NSMutableDictionary *propertiesDictionary = [NSMutableDictionary new];
    NSString *propertyName;
    NSString *propertyAttributes;
    
    if (class == NSClassFromString(@"NSMutableDictionary")) {
        propertiesDictionary = [NSMutableDictionary dictionaryWithObjects:[_container allKeys] forKeys:[_container allKeys]];
    }
    else {
        unsigned int outCount, i;
        _objcClassProperties = class_copyPropertyList(class, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = _objcClassProperties[i];
            propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            [propertiesDictionary setValue:propertyAttributes forKey:propertyName];
        }
    }
    return propertiesDictionary;
}


- (id)getObjectWithClass:(Class)class fromDictionary:(NSDictionary *)dictionary 
{
    id object = [[_mappingClass alloc] init];
    for (NSString *property in [_classProperties allKeys]) {
        
        NSSet *propertyNames = [self getSetOfPossibleNames:property];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self IN %@", propertyNames];
        NSArray *filteredPropertyKeys = [[dictionary allKeys] filteredArrayUsingPredicate:predicate];
        id propertyValue;
        if ([filteredPropertyKeys count] == 0) {
            propertyValue = nil;
        }
        else {
            propertyValue = [dictionary valueForKey:[filteredPropertyKeys objectAtIndex:0]];
        }
        @try {
            [self setValue:propertyValue forProperty:property ofObject:object];
        }
        @catch (NSException *exception) {
            NSLog(@"Cannot set value %@ for property %@ of object %@", propertyValue, property, object);
            [self setValue:nil forProperty:property ofObject:object];
        }
    }
    
    return object;
}

- (void)setValue:(id)propertyValue forProperty:(NSString *)propertyName ofObject:(id)object 
{
    if ([_mappingConfig valueForKey:propertyName] != NULL) {
        NJDXDALMappingConfigurator *newMappingConfigurator;
        if ([[_mappingConfig valueForKey:propertyName] isMemberOfClass:[NJDXDALMappingConfigurator class]]) {
            // if property is custom object
            newMappingConfigurator = [_mappingConfig valueForKey:propertyName];
        }
        else {
            // if property is built-in object
            newMappingConfigurator = [[NJDXDALMappingConfigurator alloc] initForClass:NSClassFromString([_mappingConfig valueForKey:propertyName])];
        }
        NJDXDALMappingController *newMappingController = [[NJDXDALMappingController alloc] initWithContainer:propertyValue mappingConfigurator:newMappingConfigurator];
        NSArray *results = [newMappingController start];
        if ([results count] == 1) {
            propertyValue = [results objectAtIndex:0];
        }
        else {
            propertyValue = results;
        }
    }
    if ([self isDateProperty:propertyName]) {
        propertyValue = [self formatDateFrom:propertyValue];
    }
    [object setValue:propertyValue forKeyPath:propertyName];
}

- (NSSet *)getSetOfPossibleNames:(NSString *)name 
{
    NSString *pluralizedName = [name pluralize];
    NSString *camelizedName = [name camelizeWithLowerFlag:NO];
    NSString *camelizedNameLow = [name camelizeWithLowerFlag:YES];
    return [NSSet setWithObjects:name, [name lowercaseString], pluralizedName, [pluralizedName firstCharacterUpperCase], camelizedName, camelizedNameLow, [camelizedName pluralize], [camelizedNameLow pluralize], nil];
}

- (BOOL)isDateProperty:(NSString *)propertyName 
{
    NSString *propertyAttributes = [_classProperties valueForKey:propertyName];
    if ([propertyAttributes rangeOfString:@"NSDate"].location != NSNotFound) {
        return YES;
    }
    else {
        return NO;
    }
}

- (id)formatDateFrom:(NSString *)dateString 
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([_mappingConfig valueForKey:@"CustomDateFormat"] != NULL) {
        [formatter setDateFormat:[_mappingConfig valueForKey:@"CustomDateFormat"]];
    }
    else {
        int timeFormatter = NSDateFormatterMediumStyle;
        int dateFormatter = NSDateFormatterMediumStyle;
        if ([_mappingConfig valueForKey:@"FormatterTimeStyle"] != NULL) {
            timeFormatter = [[_mappingConfig valueForKey:@"FormatterTimeStyle"] intValue];
        }
        if ([_mappingConfig valueForKey:@"FormatterDateStyle"] != NULL) {
            dateFormatter = [[_mappingConfig valueForKey:@"FormatterDateStyle"] intValue];
        }
        
        [formatter setTimeStyle:timeFormatter];
        [formatter setDateStyle:dateFormatter];
    }
    NSDate *date;
    @try {
        date = [formatter dateFromString:dateString];
    }
    @catch (NSException *exception) {
        NSLog(@"Cannot convert NSDate using custom formatter");
    }
    if (date != NULL) {
        return date;
    }
    else {
        return dateString;
    }
}

@end
