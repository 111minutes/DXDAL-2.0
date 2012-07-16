//
//  NJDXDALRequestBuilderTests.m
//  NJDXDAL
//
//  Created by Maks on 10.07.12.
//  Copyright (c) 2012 111Minutes. All rights reserved.
//

#import "NJDXDALRequestBuilderTests.h"
#import "NJDXDALRequestBuilder.h"
#import "NJDXDALHTTPOperation.h"

@implementation NJDXDALRequestBuilderTests
{
    NJDXDALRequestBuilder *_requestBuilder;
}

- (void)setUp
{
    _requestBuilder = [NJDXDALRequestBuilder new];
    [super setUp];
}

- (void)testAddedConfigBlock
{
    NJDXDALOperationConfigurationBlock configBlock = ^(NJDXDALHTTPOperation *operation)
    {
        operation.httpMethod = @"POST";
    };
    NJDXDALOperation *operation = [_requestBuilder operationWithUrl:@"https://api.foursquare.com/v2/venues/40a55d80f964a52020f31ee3?oauth_token=XXX&v=YYYYMMDD" configurationBlock:configBlock];
    [operation start];
}

@end
