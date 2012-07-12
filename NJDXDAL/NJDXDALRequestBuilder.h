//
//  NJDXDALRequestBuilder.h
//  NJDXDAL
//
//  Created by Maks on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NJDXDALHTTPOperation;

typedef void (^NJDXDALOperationConfigurationBlock)(id request);

@interface NJDXDALRequestBuilder : NSObject

- (void)addDefaultConfig:(NJDXDALOperationConfigurationBlock) configurationBlock;
- (NJDXDALHTTPOperation*) operationWithUrl:(NSString*) url configurationBlock:(NJDXDALOperationConfigurationBlock) configBlock;
- (void)defaultConfig;

@end
