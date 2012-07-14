//
//  ObjectMapper.h
//  TestConnection
//
//  Created by Yury Grinenko on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJDXDALMappingConfigurator.h"

@interface NJDXDALMappingController : NSObject

- (id)initWithContainer:(id)container mappingConfigurator:(NJDXDALMappingConfigurator *)mappingConfigurator;
- (NSArray *)start;

@end