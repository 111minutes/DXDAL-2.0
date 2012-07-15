//
//  NJDXDALRequestBuilder.h
//  NJDXDAL
//
//  Created by Maks on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NJDXDALOperationsCenter;
@class NJDXDALOperation;

typedef void (^NJDXDALOperationConfigurationBlock)(id request);



@interface NJDXDALRequestBuilder : NSObject

@property (nonatomic,strong) NJDXDALOperationsCenter *operationsCenter;

- (void)addDefaultConfig:(NJDXDALOperationConfigurationBlock) configurationBlock;
- (NJDXDALOperation*) operationWithUrl:(NSString*) url configurationBlock:(NJDXDALOperationConfigurationBlock) configBlock contentType:(NSString *) aContentType;
- (Class)defaultRequestClass;

@end
