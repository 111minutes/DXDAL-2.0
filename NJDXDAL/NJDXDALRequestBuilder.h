//
//  NJDXDALRequestBuilder.h
//  NJDXDAL
//
//  Created by Maks on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NJDXDALHTTPOperation;

typedef void (^NJDXDALRequestConfigurationBlock)(id request);

@interface NJDXDALRequestBuilder : NSObject

- (void)addDefaultConfig:(NJDXDALRequestConfigurationBlock) configurationBlock;
- (NJDXDALHTTPOperation*) operationWithRequest:(NSURLRequest*) request configurationBlock:(NJDXDALRequestConfigurationBlock) configBlock;
- (void)defaultConfig;

@end
