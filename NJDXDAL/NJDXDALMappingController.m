//
//  ObjectMapper.m
//  TestConnection
//
//  Created by Yury Grinenko on 11.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import <objc/runtime.h>
#import "NSString+Extensions.h"
#import "NJDXDALMappingController.h"
#import "NJDXDALMappingError.m"

@interface NJDXDALMappingController ()
{
    Class _mappingClass;
    NSDictionary *_classProperties;
    NSDictionary *_mappingClassesConfiguration;
    NSDictionary *_mappingPropertiesCorrespondence;
    objc_property_t *_objcClassProperties;   
    NSMutableArray *_errorsArray;
    NSString *_containerKeyPath;
}

- (NSArray *)makeObjectsFromContainer:(id)container;
- (NSArray *)start;
- (NSDictionary *)getPropertiesOfClass:(Class)class;
- (id)getObjectWithClass:(Class)class fromDictionary:(NSDictionary *)dictionary;
- (void)setValue:(id)propertyValue forProperty:(NSString *)propertyName ofObject:(id)object;
- (NSSet *)getSetOfPossibleNames:(NSString *)name;
- (id)formatDateFrom:(NSString *)dateString;
- (BOOL)isDateProperty:(NSString *)propertyName;
- (NSArray *)getDataForMapping:(id)container;

@end


@implementation NJDXDALMappingController

@synthesize delegate = _delegate;
@synthesize container = _container;

- (id)initWithRootMappingConfigurator:(NJDXDALMappingConfigurator *)mappingConfigurator keyPath:(NSString *)keyPath
{
    self = [super init];
    if (self) {
        _container = nil;
        if (mappingConfigurator.mappingClass == NSClassFromString(@"NSDictionary")) {
            _mappingClass = NSClassFromString(@"NSMutableDictionary");
        }
        else {
            _mappingClass = mappingConfigurator.mappingClass;
        }
        _classProperties = nil;
        _mappingClassesConfiguration = mappingConfigurator.mappingClassConfiguration;
        _mappingPropertiesCorrespondence = mappingConfigurator.mappingCorrespondence;
        _errorsArray = [NSMutableArray new];
        _containerKeyPath = keyPath;
    }
    return self;

}

- (NSArray *)start 
{
    _classProperties = [self getPropertiesOfClass:_mappingClass];
    if (_classProperties == nil) {
        [NSException raise:@"UnknownClassException" format:[NSString stringWithFormat:@"Cannot find class %@", NSStringFromClass(_mappingClass)]];
    }
    NSArray *array;
    if (_containerKeyPath != nil) {
        NSArray *dataForMappingContainer = [self getDataForMapping:_container];
        array = [self makeObjectsFromContainer:dataForMappingContainer];
    }    
    else {
        array = [self makeObjectsFromContainer:_container];    
    }
    
    [_delegate didFinishMapping:array withErrorLog:_errorsArray];
    return array;
}

- (NSArray *)getDataForMapping:(id)container 
{
    BOOL findedDataFlag = NO;
    id findedData;
    NSMutableArray *dataForMapping = [NSMutableArray new];
    if ([container isKindOfClass:[NSDictionary class]]) {
        findedData = [container valueForKeyPath:_containerKeyPath];
        if (findedData != NULL) {
            [dataForMapping addObject:findedData];
            findedDataFlag = YES;
        }
    }
    else {
        for (NSDictionary *dictionary in container) {
            findedData = [dictionary valueForKeyPath:_containerKeyPath];
            if (findedData != NULL) {
                [dataForMapping addObject:findedData];
                findedDataFlag = YES;
            }
        }
    }
    if (!findedDataFlag) {
        [NSException raise:@"WrongKeyPathException" format:[NSString stringWithFormat:@"No data for keyPath %@ found", _containerKeyPath]];
    }
    return dataForMapping;
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
        if (outCount == 0) {
            NJDXDALMappingError *mappingError = [[NJDXDALMappingError alloc] initWithClassName:NSStringFromClass(class) propertyName:@"Can't find class" propertyValue:nil];
            [_errorsArray addObject:mappingError];
            return nil;
        }
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
    id propertyValue;
    NSString *property;
    NSArray *keys = [_classProperties allKeys];
    for (int i = 0; i < [keys count]; i++) 
    {        
        property = [keys objectAtIndex:i];
        if ([_mappingPropertiesCorrespondence valueForKey:property] != NULL) {
            propertyValue = [dictionary valueForKey:[_mappingPropertiesCorrespondence valueForKey:property]];
        }
        else {
            NSSet *propertyNames = [self getSetOfPossibleNames:property];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self IN %@", propertyNames];
            NSArray *filteredPropertyKeys = [[dictionary allKeys] filteredArrayUsingPredicate:predicate];
            
            if ([filteredPropertyKeys count] == 0) {
                continue;
            }
            else {
                propertyValue = [dictionary valueForKey:[filteredPropertyKeys objectAtIndex:0]];
            }
        }
        @try {
            [self setValue:propertyValue forProperty:property ofObject:object];
        }
        @catch (NSException *exception) {
            NJDXDALMappingError *error = [[NJDXDALMappingError alloc] initWithClassName:NSStringFromClass([object class]) propertyName:property propertyValue:propertyValue];
            [_errorsArray addObject:error];
            [self setValue:nil forProperty:property ofObject:object];
        }
    }
    
    return object;
}

- (void)setValue:(id)propertyValue forProperty:(NSString *)propertyName ofObject:(id)object 
{
    if ([_mappingClassesConfiguration valueForKey:propertyName] != NULL) {
        NJDXDALMappingConfigurator *newMappingConfigurator;
        if ([[_mappingClassesConfiguration valueForKey:propertyName] isMemberOfClass:[NJDXDALMappingConfigurator class]]) {
            // if property is custom object
            newMappingConfigurator = [_mappingClassesConfiguration valueForKey:propertyName];
        }
        else {
            // if property is built-in object
            newMappingConfigurator = [[NJDXDALMappingConfigurator alloc] initForClass:NSClassFromString([_mappingClassesConfiguration valueForKey:propertyName])];
        }
        NJDXDALMappingController *newMappingController = [[NJDXDALMappingController alloc] initWithRootMappingConfigurator:newMappingConfigurator keyPath:nil];
        newMappingController.container = propertyValue;
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
    if ([_mappingClassesConfiguration valueForKey:@"CustomDateFormat"] != NULL) {
        [formatter setDateFormat:[_mappingClassesConfiguration valueForKey:@"CustomDateFormat"]];
    }
    else {
        int timeFormatter = NSDateFormatterMediumStyle;
        int dateFormatter = NSDateFormatterMediumStyle;
        if ([_mappingClassesConfiguration valueForKey:@"FormatterTimeStyle"] != NULL) {
            timeFormatter = [[_mappingClassesConfiguration valueForKey:@"FormatterTimeStyle"] intValue];
        }
        if ([_mappingClassesConfiguration valueForKey:@"FormatterDateStyle"] != NULL) {
            dateFormatter = [[_mappingClassesConfiguration valueForKey:@"FormatterDateStyle"] intValue];
        }
        
        [formatter setTimeStyle:timeFormatter];
        [formatter setDateStyle:dateFormatter];
    }
    NSDate *date;
    @try {
        date = [formatter dateFromString:dateString];
    }
    @catch (NSException *exception) {
        NJDXDALMappingError *error = [[NJDXDALMappingError alloc] initWithClassName:@"NSDate" propertyName:@"Date" propertyValue:dateString];
        [_errorsArray addObject:error];
    }
    if (date != NULL) {
        return date;
    }
    else {
        return dateString;
    }
}

#pragma --
#pragma mark SmartParserDelegate;

- (void)didFinishedParsing:(id)data 
{
    _container = data;
    [self start];
}

- (void)didFailedWithError:(NSError*) error {
    [_delegate didCrashedParsing:error];
}

@end
