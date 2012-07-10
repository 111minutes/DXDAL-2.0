//
//  NJDXDALRequestBuilder.m
//  NJDXDAL
//
//  Created by Maks on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NJDXDALRequestBuilder.h"
#import "NJDXDALOperationsCenter.h"

@interface NJDXDALRequestBuilder ()

@property (nonatomic,strong) NJDXDALOperationsCenter *operationsCenter;

@end

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

- (void)defaultConfig
{
    
}

- (NJDXDALHTTPOperation*) operationWithRequest:(NSURLRequest*) request configurationBlock:(NJDXDALRequestConfigurationBlock) configBlock
{
    assert(request != nil);
    for (id block in _configurationBlock) 
    {
        NJDXDALRequestConfigurationBlock config = block;
        config(request);
    }
    if (configBlock != nil) 
    {
        configBlock(request);
    }
    return [_operationsCenter addRequest:request];
}

- (void)addDefaultConfig:(NJDXDALRequestConfigurationBlock) configurationBlock
{
    [_configurationBlock addObject:configurationBlock];
}

@end
