//
//  ObjectMapper.h
//  TestConnection
//
//  Created by Yury Grinenko on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJDXDALMappingConfigurator.h"

@protocol MappingDelegate <NSObject>

- (void)didFinishMappingWithErrorLog:(NSArray *)mappingErrorArray;
- (void)didCrashedParsing:(NSError *)parsingError;

@end

@interface NJDXDALMappingController : NSObject

@property (nonatomic, strong) id<MappingDelegate> delegate;
- (id)initWithContainer:(id)container mappingConfigurator:(NJDXDALMappingConfigurator *)mappingConfigurator;
- (id)initWithRootMappingConfigurator:(NJDXDALMappingConfigurator *)mappingConfigurator;
- (NSArray *)start;

@end