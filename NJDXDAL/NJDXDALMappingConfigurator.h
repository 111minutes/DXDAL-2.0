//
//  MappingConfigurator.h
//  TestConnection
//
//  Created by Yury Grinenko on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJDXDALMappingConfigurator : NSObject

@property (nonatomic, strong) NSMutableDictionary *mappingClassConfiguration;
@property (nonatomic, strong) Class mappingClass;
@property (nonatomic, strong) NSMutableDictionary *mappingCorrespondence;

- (id)initForClass:(Class)mappingClass;
- (void)setMappingOfProperty:(NSString *)propertyName toType:(NSString *)propertyType;
- (void)setMappingOfProperty:(NSString *)propertyName toMappingConfigurator:(NJDXDALMappingConfigurator *)configurator;
- (void)setDateStyle:(NSInteger)formatterDateStyle;
- (void)setTimeStyle:(NSInteger)formatterTimeStyle;
- (void)setDateFormat:(NSString *)dateFormat;
- (void)setCorrespondenceOfProperty:(NSString *)propertyName toDataField:(NSString *)dataField;

@end
