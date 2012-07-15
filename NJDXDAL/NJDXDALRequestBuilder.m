//
//  NJDXDALRequestBuilder.m
//  NJDXDAL
//
//  Created by Maks on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALRequestBuilder.h"
#import "NJDXDALOperationsCenter.h"
#import "NJDXDALOperation.h"
#import "NJDXDALHTTPOperation.h"

@implementation NJDXDALRequestBuilder
{
    NSMutableArray *_configurationBlock;
}

@synthesize operationsCenter = _operationsCenter;

- (id)init
{
    self = [super init];
    if (self) 
    {
        _operationsCenter = [NJDXDALOperationsCenter new];
        _configurationBlock = [NSMutableArray array];
    }
    return self;
}

- (NJDXDALOperation*) operationWithUrl:(NSString*) url configurationBlock:(NJDXDALOperationConfigurationBlock) configBlock contentType:(NSString *) aContentType
{
    assert(url != nil);
    NJDXDALHTTPOperation *operation = [_operationsCenter addRequest:url contentType:aContentType];    
    for (id block in _configurationBlock) 
    {
        NJDXDALOperationConfigurationBlock config = block;
        config(operation);
    }
    if (configBlock != nil) 
    {
        configBlock(operation);
    }
    return (NJDXDALOperation*)operation;
}

- (void)addDefaultConfig:(NJDXDALOperationConfigurationBlock) configurationBlock
{
    [_configurationBlock addObject:configurationBlock];
}

- (Class)defaultRequestClass
{
  //  NSAssert(NO, @"Override this method in subclasses!");
    return nil;
}

@end
