//
//  MappingConfigurator.h
//  TestConnection
//
//  Created by Yury Grinenko on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJDXDALMappingConfigurator : NSObject

@property (nonatomic, strong) NSMutableDictionary *mappingConfig;
@property (nonatomic, strong) Class mappingClass;

- (id)initForClass:(Class)mappingClass;
- (void)setMappingOfProperty:(NSString *)propertyName toType:(NSString *)propertyType;
- (void)setMappingOfProperty:(NSString *)propertyName toMappingConfigurator:(NJDXDALMappingConfigurator *)configurator;
- (void)setDateStyle:(NSInteger)formatterDateStyle;
- (void)setTimeStyle:(NSInteger)formatterTimeStyle;
- (void)setDateFormat:(NSString *)dateFormat;

@end
