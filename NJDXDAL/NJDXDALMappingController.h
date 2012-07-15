//
//  ObjectMapper.h
//  TestConnection
//
//  Created by Yury Grinenko on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJDXDALMappingConfigurator.h"
#import "NJDXDALParser.h"

@protocol MappingDelegate <NSObject>

- (void)didFinishMapping:(NSArray *)realObjects withErrorLog:(NSArray *)mappingErrorArray;
- (void)didCrashedParsing:(NSError *)parsingError;

@end

@interface NJDXDALMappingController : NSObject <SmartParserDelegate> 

@property (nonatomic, strong) id<MappingDelegate> delegate; //for informing parentOperation when data's mapped.
@property (nonatomic, strong) id container;

- (id)initWithRootMappingConfigurator:(NJDXDALMappingConfigurator *)mappingConfigurator keyPath:(NSString *)keyPath;
- (NSArray *)start;

@end