//
//  MappingConfigurator.m
//  TestConnection
//
//  Created by Yury Grinenko on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALMappingConfigurator.h"

@implementation NJDXDALMappingConfigurator

@synthesize mappingConfig = _mappingConfig;
@synthesize mappingClass = _mappingClass;

- (id)initForClass:(Class)mappingClass 
{
    self= [super init];
    if (self) {
        _mappingConfig = [NSMutableDictionary new];
        _mappingClass = mappingClass;
    }
    return self;
}

- (void)setMappingOfProperty:(NSString *)propertyName toType:(NSString *)propertyType 
{
    [_mappingConfig setValue:propertyType forKey:propertyName];    
}

- (void)setMappingOfProperty:(NSString *)propertyName toMappingConfigurator:(NJDXDALMappingConfigurator *)configurator 
{
    [_mappingConfig setValue:configurator forKey:propertyName];
}

- (void)setDateStyle:(NSInteger)formatterDateStyle {
    [_mappingConfig setValue:[NSNumber numberWithInt:formatterDateStyle] forKey:@"FormatterDateStyle"];
}
- (void)setTimeStyle:(NSInteger)formatterTimeStyle {
    [_mappingConfig setValue:[NSNumber numberWithInt:formatterTimeStyle] forKey:@"FormatterTimeStyle"]; 
}
- (void)setDateFormat:(NSString *)dateFormat {
    [_mappingConfig setValue:dateFormat forKey:@"CustomDateFormat"];
}

@end
