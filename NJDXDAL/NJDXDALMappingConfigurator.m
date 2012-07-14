//
//  MappingConfigurator.m
//  TestConnection
//
//  Created by Yury Grinenko on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALMappingConfigurator.h"

@implementation NJDXDALMappingConfigurator

@synthesize mappingClassConfiguration = _mappingClassConfiguration;
@synthesize mappingClass = _mappingClass;
@synthesize mappingCorrespondence = _mappingCorrespondence;

- (id)initForClass:(Class)mappingClass 
{
    self= [super init];
    if (self) {
        _mappingClassConfiguration = [NSMutableDictionary new];
        _mappingClass = mappingClass;
        _mappingCorrespondence = [NSMutableDictionary new];
    }
    return self;
}

- (void)setMappingOfProperty:(NSString *)propertyName toType:(NSString *)propertyType 
{
    [_mappingClassConfiguration setValue:propertyType forKey:propertyName];    
}

- (void)setMappingOfProperty:(NSString *)propertyName toMappingConfigurator:(NJDXDALMappingConfigurator *)configurator 
{
    [_mappingClassConfiguration setValue:configurator forKey:propertyName];
}

- (void)setDateStyle:(NSInteger)formatterDateStyle 
{
    [_mappingClassConfiguration setValue:[NSNumber numberWithInt:formatterDateStyle] forKey:@"FormatterDateStyle"];
}

- (void)setTimeStyle:(NSInteger)formatterTimeStyle 
{
    [_mappingClassConfiguration setValue:[NSNumber numberWithInt:formatterTimeStyle] forKey:@"FormatterTimeStyle"]; 
}

- (void)setDateFormat:(NSString *)dateFormat 
{
    [_mappingClassConfiguration setValue:dateFormat forKey:@"CustomDateFormat"];
}

- (void)setCorrespondenceOfProperty:(NSString *)propertyName toDataField:(NSString *)dataField 
{
    [_mappingCorrespondence setValue:dataField forKey:propertyName];
}

@end
